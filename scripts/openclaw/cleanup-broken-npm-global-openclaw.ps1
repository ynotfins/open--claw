[CmdletBinding()]
param(
    [string]$BackupPath,
    [switch]$Execute
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

trap {
    Write-Host ''
    Write-Host "BLOCKED: $($_.Exception.Message)"
    exit 2
}

function Assert-Condition {
    param(
        [Parameter(Mandatory)][bool]$Condition,
        [Parameter(Mandatory)][string]$Message
    )
    if (-not $Condition) {
        throw $Message
    }
}

function Invoke-Captured {
    param([Parameter(Mandatory)][scriptblock]$Command)
    try {
        $output = @(& $Command 2>&1)
        [pscustomobject]@{ ExitCode = $LASTEXITCODE; Text = ($output -join [Environment]::NewLine) }
    }
    catch {
        [pscustomobject]@{ ExitCode = 1; Text = $_.Exception.Message }
    }
}

function Get-SafeLiveStateReferenceCount {
    param(
        [Parameter(Mandatory)][string]$Root,
        [Parameter(Mandatory)][string]$Needle
    )

    if (-not (Test-Path -LiteralPath $Root)) {
        return 0
    }

    $allowedExtensions = @('.json', '.json5', '.yaml', '.yml', '.md', '.ps1', '.cmd', '.js', '.mjs')
    $excludedPathPattern = '\\(secrets|credentials|logs|npm|backups|mcp-oauth|data|state|memory|sessions|cache|browser)(\\|$)'
    $matches = foreach ($file in Get-ChildItem -LiteralPath $Root -File -Recurse -Force -ErrorAction SilentlyContinue) {
        if ($allowedExtensions -notcontains $file.Extension.ToLowerInvariant()) {
            continue
        }
        if ($file.FullName -match $excludedPathPattern) {
            continue
        }
        if (Select-String -LiteralPath $file.FullName -SimpleMatch -Pattern $Needle -Quiet -ErrorAction SilentlyContinue) {
            $file.FullName
        }
    }
    return @($matches).Count
}

$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$env:Path = "$machinePath;$userPath"

$npmPrefix = (& npm prefix -g).Trim()
$npmRoot = (& npm root -g).Trim()
$activePrefix = 'D:\openclaw\bin'
$activeCmd = Join-Path $activePrefix 'openclaw.cmd'
$activeWrapper = 'D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1'
$clawXCmd = 'C:\Program Files\ClawX\resources\cli\openclaw.cmd'
$expectedMissingEntry = Join-Path $npmRoot 'openclaw\openclaw.mjs'
$targets = @(
    (Join-Path $npmPrefix 'openclaw'),
    (Join-Path $npmPrefix 'openclaw.cmd'),
    (Join-Path $npmPrefix 'openclaw.ps1'),
    (Join-Path $npmRoot 'openclaw')
)

Write-Host 'Preflight: active command ownership'
$whereBefore = @(& where.exe openclaw 2>$null)
Assert-Condition -Condition ($whereBefore.Count -gt 0) -Message 'openclaw is not resolvable.'
Assert-Condition -Condition ($whereBefore[0].StartsWith($activePrefix, [StringComparison]::OrdinalIgnoreCase)) -Message "Active OpenClaw owner is not $activePrefix."
Write-Host "PASS: active owner is $($whereBefore[0])"

$activeProbe = Invoke-Captured -Command { & $activeCmd --version }
Assert-Condition -Condition ($activeProbe.ExitCode -eq 0) -Message 'The active D:\openclaw launcher failed its version probe.'
Write-Host "PASS: active launcher reports $(($activeProbe.Text -replace '\s+', ' ').Trim())"

$clawXProbe = Invoke-Captured -Command { & $clawXCmd --version }
Assert-Condition -Condition ($clawXProbe.ExitCode -eq 0) -Message 'The ClawX bundled fallback failed its version probe.'
Write-Host "PASS: ClawX fallback reports $(($clawXProbe.Text -replace '\s+', ' ').Trim())"

Write-Host 'Preflight: npm-global residue'
Assert-Condition -Condition (-not (Test-Path -LiteralPath $expectedMissingEntry)) -Message 'npm-global OpenClaw entrypoint exists; this is not the known broken-empty state.'
$packageDirectory = Join-Path $npmRoot 'openclaw'
if (Test-Path -LiteralPath $packageDirectory) {
    $payload = @(Get-ChildItem -LiteralPath $packageDirectory -Force -Recurse -ErrorAction Stop)
    Assert-Condition -Condition ($payload.Count -eq 0) -Message 'npm-global OpenClaw package directory is not empty; cleanup requires a new review.'
}

$shimPaths = $targets[0..2]
foreach ($shim in $shimPaths) {
    if (Test-Path -LiteralPath $shim) {
        $content = (Get-Content -LiteralPath $shim -Raw) -replace '\\', '/'
        Assert-Condition -Condition ($content -match 'node_modules/openclaw/openclaw\.mjs') -Message "Unexpected content in npm-global shim: $shim"
    }
}
$brokenShim = Invoke-Captured -Command { & (Join-Path $npmPrefix 'openclaw.cmd') --version }
Assert-Condition -Condition ($brokenShim.ExitCode -ne 0) -Message 'npm-global OpenClaw shim unexpectedly works; cleanup requires a new review.'
Write-Host 'PASS: npm-global shim is broken and its package directory is empty.'

Write-Host 'Preflight: dependency references'
foreach ($launcher in @($activeCmd, $activeWrapper, $clawXCmd)) {
    $referencesNpmPrefix = Select-String -LiteralPath $launcher -SimpleMatch -Pattern $npmPrefix -Quiet
    Assert-Condition -Condition (-not $referencesNpmPrefix) -Message "Approved launcher references npm-global OpenClaw: $launcher"
}
$liveReferenceCount = Get-SafeLiveStateReferenceCount -Root (Join-Path $env:USERPROFILE '.openclaw') -Needle $npmPrefix
Assert-Condition -Condition ($liveReferenceCount -eq 0) -Message "Safe-scope live-state scan found $liveReferenceCount npm-global path reference(s)."
Write-Host 'PASS: approved launcher chain and safe-scope live runtime files do not reference the npm-global prefix.'

Write-Host 'Planned exact removals'
foreach ($target in $targets) {
    Write-Host "$target (present=$(Test-Path -LiteralPath $target))"
}

if (-not $Execute) {
    Write-Host ''
    Write-Host 'DRY RUN ONLY. No files were removed.'
    Write-Host 'Create a backup with backup-openclaw-control-plane-state.ps1 -Execute, then re-run with -Execute -BackupPath <path>.'
    exit 0
}

Assert-Condition -Condition (-not [string]::IsNullOrWhiteSpace($BackupPath)) -Message '-BackupPath is required with -Execute.'
$resolvedBackup = [IO.Path]::GetFullPath($BackupPath)
$manifestPath = Join-Path $resolvedBackup 'manifest.json'
$npmBackupPath = Join-Path $resolvedBackup 'npm-global-openclaw'
$npmPrefixBackupPath = Join-Path $npmBackupPath 'prefix'
$npmRootBackupPath = Join-Path $npmBackupPath 'node_modules'
Assert-Condition -Condition (Test-Path -LiteralPath $manifestPath) -Message "Backup manifest missing: $manifestPath"
Assert-Condition -Condition (Test-Path -LiteralPath $npmBackupPath) -Message "npm-global backup folder missing: $npmBackupPath"
Assert-Condition -Condition (Test-Path -LiteralPath $npmPrefixBackupPath) -Message "npm prefix backup folder missing: $npmPrefixBackupPath"
Assert-Condition -Condition (Test-Path -LiteralPath $npmRootBackupPath) -Message "npm node_modules backup folder missing: $npmRootBackupPath"

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
Assert-Condition -Condition ($manifest.NpmPrefix -eq $npmPrefix) -Message 'Backup npm prefix does not match the current npm prefix.'
Assert-Condition -Condition ($manifest.NpmRoot -eq $npmRoot) -Message 'Backup npm root does not match the current npm root.'
foreach ($source in $targets) {
    if (Test-Path -LiteralPath $source) {
        $leaf = Split-Path -Leaf $source
        $backupCandidate = if ((Get-Item -LiteralPath $source -Force).PSIsContainer) {
            Join-Path $npmRootBackupPath $leaf
        }
        else {
            Join-Path $npmPrefixBackupPath $leaf
        }
        Assert-Condition -Condition (Test-Path -LiteralPath $backupCandidate) -Message "Backup is missing current artifact: $leaf"
    }
}

$expectedPackagePath = [IO.Path]::GetFullPath((Join-Path $npmRoot 'openclaw'))
foreach ($target in $targets) {
    if (-not (Test-Path -LiteralPath $target)) {
        continue
    }
    $resolvedTarget = [IO.Path]::GetFullPath($target)
    if ((Get-Item -LiteralPath $target -Force).PSIsContainer) {
        Assert-Condition -Condition ($resolvedTarget -eq $expectedPackagePath) -Message "Refusing recursive removal outside the exact npm-global OpenClaw package path: $resolvedTarget"
        Remove-Item -LiteralPath $resolvedTarget -Recurse -Force
    }
    else {
        Assert-Condition -Condition ($resolvedTarget.StartsWith(([IO.Path]::GetFullPath($npmPrefix) + [IO.Path]::DirectorySeparatorChar), [StringComparison]::OrdinalIgnoreCase)) -Message "Refusing file removal outside npm prefix: $resolvedTarget"
        Remove-Item -LiteralPath $resolvedTarget -Force
    }
}

$whereAfter = @(& where.exe openclaw 2>$null)
Assert-Condition -Condition ($whereAfter.Count -gt 0) -Message 'openclaw no longer resolves after cleanup.'
Assert-Condition -Condition ($whereAfter[0].StartsWith($activePrefix, [StringComparison]::OrdinalIgnoreCase)) -Message 'Active OpenClaw ownership changed after cleanup.'
Assert-Condition -Condition (-not (@($whereAfter | Where-Object { $_.StartsWith($npmPrefix, [StringComparison]::OrdinalIgnoreCase) }).Count)) -Message 'npm-global OpenClaw still appears in command resolution.'
Assert-Condition -Condition (@($whereAfter | Where-Object { $_.StartsWith('C:\Program Files\ClawX\resources\cli', [StringComparison]::OrdinalIgnoreCase) }).Count -gt 0) -Message 'ClawX fallback is missing from command resolution after cleanup.'

$postProbe = Invoke-Captured -Command { & openclaw --version }
Assert-Condition -Condition ($postProbe.ExitCode -eq 0) -Message 'Active OpenClaw version probe failed after cleanup.'

$result = [ordered]@{
    CompletedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
    BackupPath = $resolvedBackup
    Removed = $targets
    CommandResolutionAfter = $whereAfter
    ActiveVersionAfter = ($postProbe.Text -replace '\s+', ' ').Trim()
    LiveRuntimeStateModified = $false
    ClawXAppDataModified = $false
    ProgramFilesClawXModified = $false
    OperationalRootModified = $false
}
$result | ConvertTo-Json -Depth 4 |
    Set-Content -LiteralPath (Join-Path $resolvedBackup 'cleanup-result.json') -Encoding utf8

Write-Host ''
Write-Host 'CLEANUP COMPLETE'
Write-Host "Backup and rollback: $resolvedBackup"
Write-Host "Active owner: $($whereAfter[0])"
Write-Host "Active version: $(($postProbe.Text -replace '\s+', ' ').Trim())"
