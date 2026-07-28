[CmdletBinding()]
param(
    [string]$OperationalRoot = 'D:\openclaw',
    [string]$ControlPlaneRoot = 'D:\github\open--claw',
    [string]$ClawXRoot = 'C:\Program Files\ClawX',
    [string]$LiveStateRoot = (Join-Path $env:USERPROFILE '.openclaw')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Section {
    param([Parameter(Mandatory)][string]$Title)
    Write-Host ''
    Write-Host "== $Title =="
}

function Get-CommandPaths {
    param([Parameter(Mandatory)][string]$Name)

    $resolved = @(& where.exe $Name 2>$null)
    if ($LASTEXITCODE -ne 0) {
        return @()
    }
    return @($resolved | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

function Invoke-VersionProbe {
    param(
        [Parameter(Mandatory)][string]$Label,
        [Parameter(Mandatory)][scriptblock]$Command
    )

    try {
        $output = @(& $Command 2>&1)
        $exitCode = $LASTEXITCODE
        $summary = ($output | Select-Object -First 1).ToString().Trim()
        [pscustomobject]@{
            Component = $Label
            ExitCode = $exitCode
            Result = $summary
        }
    }
    catch {
        [pscustomobject]@{
            Component = $Label
            ExitCode = 1
            Result = $_.Exception.Message
        }
    }
}

$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$env:Path = "$machinePath;$userPath"

$systemNode = 'C:\Program Files\nodejs\node.exe'
$activeCmd = Join-Path $OperationalRoot 'bin\openclaw.cmd'
$activePs1 = Join-Path $OperationalRoot 'bin\openclaw.ps1'
$activeWrapper = Join-Path $OperationalRoot 'scripts\Invoke-ClawXOpenClaw.ps1'
$activeEntry = Join-Path $OperationalRoot 'runtime\openclaw\node_modules\openclaw\openclaw.mjs'
$activeServiceEntry = Join-Path $OperationalRoot 'runtime\openclaw\node_modules\openclaw\dist\index.js'
$clawXCmd = Join-Path $ClawXRoot 'resources\cli\openclaw.cmd'
$clawXEntry = Join-Path $ClawXRoot 'resources\openclaw\openclaw.mjs'
$clawXSettings = Join-Path $env:APPDATA 'clawx\settings.json'
$gatewayScript = Join-Path $LiveStateRoot 'gateway.cmd'
$gatewayTaskName = 'OpenClaw Gateway'
$gatewayPort = 18789
$npmPrefix = (& npm prefix -g).Trim()
$npmRoot = (& npm root -g).Trim()
$pnpmRoot = (& pnpm root -g).Trim()
$pnpmBin = (& pnpm bin -g).Trim()

Write-Section 'Authority roots'
@(
    [pscustomobject]@{ Role = 'Current operational authority'; Path = $OperationalRoot; Exists = Test-Path -LiteralPath $OperationalRoot }
    [pscustomobject]@{ Role = 'Future durable control plane'; Path = $ControlPlaneRoot; Exists = Test-Path -LiteralPath $ControlPlaneRoot }
    [pscustomobject]@{ Role = 'Live runtime state'; Path = $LiveStateRoot; Exists = Test-Path -LiteralPath $LiveStateRoot }
    [pscustomobject]@{ Role = 'Installer-managed ClawX'; Path = $ClawXRoot; Exists = Test-Path -LiteralPath $ClawXRoot }
) | Format-Table -AutoSize

Write-Section 'Command ownership'
@(
foreach ($name in @('node', 'npm', 'npx', 'corepack', 'pnpm', 'pnpx', 'clawhub', 'openclaw')) {
    $paths = @(Get-CommandPaths -Name $name)
    [pscustomobject]@{
        Command = $name
        FirstOwner = if ($paths.Count -gt 0) { $paths[0] } else { '<not found>' }
        AlternateCount = [Math]::Max(0, $paths.Count - 1)
    }
}
) | Format-Table -AutoSize

Write-Section 'Package manager roots'
[pscustomobject]@{
    NpmPrefix = $npmPrefix
    NpmRoot = $npmRoot
    PnpmRoot = $pnpmRoot
    PnpmBin = $pnpmBin
} | Format-List

Write-Section 'Version probes'
@(
    Invoke-VersionProbe -Label 'Node' -Command { & $systemNode --version }
    Invoke-VersionProbe -Label 'npm' -Command { & npm --version }
    Invoke-VersionProbe -Label 'Corepack' -Command { & corepack --version }
    Invoke-VersionProbe -Label 'pnpm' -Command { & pnpm --version }
    Invoke-VersionProbe -Label 'ClawHub' -Command { & clawhub --cli-version }
    Invoke-VersionProbe -Label 'Active OpenClaw' -Command { & $activeCmd --version }
    Invoke-VersionProbe -Label 'ClawX bundled OpenClaw' -Command { & $clawXCmd --version }
) | Format-Table -AutoSize

Write-Section 'OpenClaw launcher chain'
@(
    [pscustomobject]@{ Artifact = 'Active cmd shim'; Path = $activeCmd; Exists = Test-Path -LiteralPath $activeCmd }
    [pscustomobject]@{ Artifact = 'Active PowerShell shim'; Path = $activePs1; Exists = Test-Path -LiteralPath $activePs1 }
    [pscustomobject]@{ Artifact = 'Active wrapper'; Path = $activeWrapper; Exists = Test-Path -LiteralPath $activeWrapper }
    [pscustomobject]@{ Artifact = 'Approved runtime entry'; Path = $activeEntry; Exists = Test-Path -LiteralPath $activeEntry }
    [pscustomobject]@{ Artifact = 'Approved service entry'; Path = $activeServiceEntry; Exists = Test-Path -LiteralPath $activeServiceEntry }
    [pscustomobject]@{ Artifact = 'System Node'; Path = $systemNode; Exists = Test-Path -LiteralPath $systemNode }
    [pscustomobject]@{ Artifact = 'ClawX fallback cmd'; Path = $clawXCmd; Exists = Test-Path -LiteralPath $clawXCmd }
    [pscustomobject]@{ Artifact = 'ClawX bundled entry'; Path = $clawXEntry; Exists = Test-Path -LiteralPath $clawXEntry }
) | Format-Table -AutoSize

Write-Section 'Gateway ownership'
$gatewayTask = Get-ScheduledTask -TaskName $gatewayTaskName -ErrorAction SilentlyContinue
$gatewayInfo = if ($null -ne $gatewayTask) {
    Get-ScheduledTaskInfo -TaskName $gatewayTaskName -ErrorAction SilentlyContinue
}
$gatewayAction = if ($null -ne $gatewayTask) {
    @($gatewayTask.Actions)[0]
}
$gatewayText = if (Test-Path -LiteralPath $gatewayScript -PathType Leaf) {
    Get-Content -LiteralPath $gatewayScript -Raw
}
$listenerLine = @(& netstat.exe -ano -p tcp |
    Select-String -Pattern "^\s*TCP\s+\S+:$gatewayPort\s+\S+\s+LISTENING\s+(\d+)\s*$" |
    Select-Object -First 1)
$listenerProcess = $null
if ($listenerLine.Count -gt 0 -and $listenerLine[0].Line -match "^\s*TCP\s+\S+:$gatewayPort\s+\S+\s+LISTENING\s+(\d+)\s*$") {
    $listenerProcess = Get-CimInstance Win32_Process -Filter "ProcessId=$([int]$Matches[1])" -ErrorAction SilentlyContinue
}
$clawXGatewayAutoStart = $null
if (Test-Path -LiteralPath $clawXSettings -PathType Leaf) {
    $clawXGatewayAutoStart = [bool](
        (Get-Content -LiteralPath $clawXSettings -Raw | ConvertFrom-Json -Depth 100).gatewayAutoStart
    )
}
[pscustomobject]@{
    TaskRegistered = $null -ne $gatewayTask
    TaskState = if ($null -ne $gatewayTask) { [string]$gatewayTask.State } else { '<missing>' }
    TaskLastResult = if ($null -ne $gatewayInfo) { $gatewayInfo.LastTaskResult } else { $null }
    TaskAction = if ($null -ne $gatewayAction) { [string]$gatewayAction.Execute } else { '<missing>' }
    GatewayScriptReferencesNpmGlobal = [bool]($gatewayText -like "*$npmPrefix*")
    GatewayScriptReferencesOperationalService = [bool]($gatewayText -like "*$activeServiceEntry*")
    ListenerPid = if ($null -ne $listenerProcess) { $listenerProcess.ProcessId } else { $null }
    ListenerExecutable = if ($null -ne $listenerProcess) { $listenerProcess.ExecutablePath } else { '<missing>' }
    ListenerUsesOperationalService = [bool](
        $null -ne $listenerProcess -and
        [string]$listenerProcess.CommandLine -like "*$activeServiceEntry*"
    )
    ClawXGatewayAutoStart = $clawXGatewayAutoStart
} | Format-List

Write-Section 'npm-global OpenClaw residue'
$npmArtifacts = @(
    (Join-Path $npmPrefix 'openclaw'),
    (Join-Path $npmPrefix 'openclaw.cmd'),
    (Join-Path $npmPrefix 'openclaw.ps1'),
    (Join-Path $npmRoot 'openclaw')
)
@(
foreach ($path in $npmArtifacts) {
    $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
    [pscustomobject]@{
        Path = $path
        Present = $null -ne $item
        Type = if ($null -eq $item) { '-' } elseif ($item.PSIsContainer) { 'Directory' } else { 'File' }
        Length = if ($null -eq $item -or $item.PSIsContainer) { $null } else { $item.Length }
    }
}
) | Format-Table -AutoSize

Write-Section 'Runtime hash relationship'
if ((Test-Path -LiteralPath $activeEntry) -and (Test-Path -LiteralPath $clawXEntry)) {
    $activeHash = (Get-FileHash -LiteralPath $activeEntry -Algorithm SHA256).Hash
    $clawXHash = (Get-FileHash -LiteralPath $clawXEntry -Algorithm SHA256).Hash
    [pscustomobject]@{
        ActiveRuntimeHashMatchesClawXBundle = $activeHash -eq $clawXHash
        Algorithm = 'SHA256'
    } | Format-List
}
else {
    Write-Warning 'One or both OpenClaw entrypoints are missing; hash comparison was skipped.'
}

Write-Section 'Safety posture'
Write-Host 'Read-only audit complete. No persisted PATH, package, runtime-state, app-data, Program Files, or vendor files were changed.'
