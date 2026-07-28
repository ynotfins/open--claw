[CmdletBinding()]
param(
    [string]$BackupRoot = (Join-Path $env:USERPROFILE 'openclaw-control-plane-backups\control-plane'),
    [switch]$Execute
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupPath = Join-Path $BackupRoot $timestamp
$npmPrefix = (& npm prefix -g).Trim()
$npmRoot = (& npm root -g).Trim()
$sourceMap = [ordered]@{
    NpmShimPosix = Join-Path $npmPrefix 'openclaw'
    NpmShimCmd = Join-Path $npmPrefix 'openclaw.cmd'
    NpmShimPowerShell = Join-Path $npmPrefix 'openclaw.ps1'
    NpmPackageDirectory = Join-Path $npmRoot 'openclaw'
    ActiveCmd = 'D:\openclaw\bin\openclaw.cmd'
    ActivePowerShell = 'D:\openclaw\bin\openclaw.ps1'
    ActiveWrapper = 'D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1'
    ClawXCmd = 'C:\Program Files\ClawX\resources\cli\openclaw.cmd'
}

Write-Host 'OpenClaw control-plane backup plan'
Write-Host "Target: $backupPath"
foreach ($entry in $sourceMap.GetEnumerator()) {
    Write-Host ("{0}: {1} (present={2})" -f $entry.Key, $entry.Value, (Test-Path -LiteralPath $entry.Value))
}

if (-not $Execute) {
    Write-Host ''
    Write-Host 'DRY RUN ONLY. Re-run with -Execute to create the timestamped backup.'
    exit 0
}

New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
$npmBackup = New-Item -ItemType Directory -Path (Join-Path $backupPath 'npm-global-openclaw') -Force
$npmPrefixBackup = New-Item -ItemType Directory -Path (Join-Path $npmBackup.FullName 'prefix') -Force
$npmRootBackup = New-Item -ItemType Directory -Path (Join-Path $npmBackup.FullName 'node_modules') -Force
$launcherBackup = New-Item -ItemType Directory -Path (Join-Path $backupPath 'active-launcher') -Force
$clawXBackup = New-Item -ItemType Directory -Path (Join-Path $backupPath 'clawx-fallback') -Force

$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$persistedProcessPath = "$machinePath;$userPath"

Set-Content -LiteralPath (Join-Path $backupPath 'machine-path.txt') -Value $machinePath -Encoding utf8
Set-Content -LiteralPath (Join-Path $backupPath 'user-path.txt') -Value $userPath -Encoding utf8
Set-Content -LiteralPath (Join-Path $backupPath 'process-path.txt') -Value $env:Path -Encoding utf8

$previousPath = $env:Path
$env:Path = $persistedProcessPath
try {
    $commandEvidence = foreach ($command in @('node', 'npm', 'npx', 'corepack', 'pnpm', 'pnpx', 'clawhub', 'openclaw')) {
        "[$command]"
        @(& where.exe $command 2>$null)
    }
    Set-Content -LiteralPath (Join-Path $backupPath 'command-resolution.txt') -Value $commandEvidence -Encoding utf8

    $healthEvidence = @(
        "node=$(& node --version)"
        "npm=$(& npm --version)"
        "npx=$(& npx --version)"
        "corepack=$(& corepack --version)"
        "pnpm=$(& pnpm --version)"
        "pnpm-root=$((& pnpm root -g).Trim())"
        "pnpm-bin=$((& pnpm bin -g).Trim())"
        "clawhub=$(& clawhub --cli-version)"
        "openclaw=$(& 'D:\openclaw\bin\openclaw.cmd' --version)"
        "clawx-openclaw=$(& 'C:\Program Files\ClawX\resources\cli\openclaw.cmd' --version)"
    )
    Set-Content -LiteralPath (Join-Path $backupPath 'package-manager-health.txt') -Value $healthEvidence -Encoding utf8
    npm list -g openclaw --depth=2 2>&1 |
        Set-Content -LiteralPath (Join-Path $backupPath 'npm-list-openclaw.txt') -Encoding utf8
}
finally {
    $env:Path = $previousPath
}

$copied = [System.Collections.Generic.List[object]]::new()
foreach ($key in @('NpmShimPosix', 'NpmShimCmd', 'NpmShimPowerShell')) {
    $source = $sourceMap[$key]
    if (Test-Path -LiteralPath $source) {
        Copy-Item -LiteralPath $source -Destination $npmPrefixBackup.FullName -Force
        $item = Get-Item -LiteralPath $source -Force
        $hash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
        $copied.Add([pscustomobject]@{ Key = $key; Source = $source; Hash = $hash })
    }
}
$packageSource = $sourceMap.NpmPackageDirectory
if (Test-Path -LiteralPath $packageSource) {
    Copy-Item -LiteralPath $packageSource -Destination $npmRootBackup.FullName -Recurse -Force
    $copied.Add([pscustomobject]@{ Key = 'NpmPackageDirectory'; Source = $packageSource; Hash = $null })
}
foreach ($key in @('ActiveCmd', 'ActivePowerShell', 'ActiveWrapper')) {
    $source = $sourceMap[$key]
    if (Test-Path -LiteralPath $source) {
        Copy-Item -LiteralPath $source -Destination $launcherBackup.FullName -Force
        $copied.Add([pscustomobject]@{
            Key = $key
            Source = $source
            Hash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
        })
    }
}
if (Test-Path -LiteralPath $sourceMap.ClawXCmd) {
    Copy-Item -LiteralPath $sourceMap.ClawXCmd -Destination $clawXBackup.FullName -Force
    $copied.Add([pscustomobject]@{
        Key = 'ClawXCmd'
        Source = $sourceMap.ClawXCmd
        Hash = (Get-FileHash -LiteralPath $sourceMap.ClawXCmd -Algorithm SHA256).Hash
    })
}

$manifest = [ordered]@{
    SchemaVersion = 1
    CreatedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
    BackupPath = $backupPath
    NpmPrefix = $npmPrefix
    NpmRoot = $npmRoot
    Sources = $sourceMap
    CopiedArtifacts = $copied
    ExcludedRoots = @(
        (Join-Path $env:USERPROFILE '.openclaw'),
        (Join-Path $env:APPDATA 'clawx'),
        'C:\Program Files\ClawX\resources\openclaw',
        'D:\github\open--claw\vendor\openclaw'
    )
}
$manifest | ConvertTo-Json -Depth 6 |
    Set-Content -LiteralPath (Join-Path $backupPath 'manifest.json') -Encoding utf8

$restoreScript = @'
[CmdletBinding()]
param([switch]$Execute)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$backupRoot = $PSScriptRoot
$manifest = Get-Content -LiteralPath (Join-Path $backupRoot 'manifest.json') -Raw | ConvertFrom-Json
$prefixSource = Join-Path $backupRoot 'npm-global-openclaw\prefix'
$nodeModulesSource = Join-Path $backupRoot 'npm-global-openclaw\node_modules'
$targets = @(
    @{ Source = (Join-Path $prefixSource 'openclaw'); Destination = $manifest.NpmPrefix },
    @{ Source = (Join-Path $prefixSource 'openclaw.cmd'); Destination = $manifest.NpmPrefix },
    @{ Source = (Join-Path $prefixSource 'openclaw.ps1'); Destination = $manifest.NpmPrefix },
    @{ Source = (Join-Path $nodeModulesSource 'openclaw'); Destination = $manifest.NpmRoot }
)

Write-Host "Restore source: $backupRoot"
Write-Host "npm prefix: $($manifest.NpmPrefix)"
Write-Host "npm root: $($manifest.NpmRoot)"

if (-not $Execute) {
    Write-Host 'DRY RUN ONLY. Re-run with -Execute to restore the backed-up npm-global OpenClaw artifacts.'
    exit 0
}

foreach ($target in $targets) {
    if (Test-Path -LiteralPath $target.Source) {
        Copy-Item -LiteralPath $target.Source -Destination $target.Destination -Recurse -Force
    }
}
Write-Host 'Restore completed. Verify command ownership with where.exe openclaw and Get-Command openclaw -All.'
'@
Set-Content -LiteralPath (Join-Path $backupPath 'restore-npm-global-openclaw.ps1') -Value $restoreScript -Encoding utf8

Write-Host ''
Write-Host "BACKUP_PATH=$backupPath"
Write-Host 'Backup completed. No live runtime state, ClawX app data, Program Files application files, or vendor source was modified.'
