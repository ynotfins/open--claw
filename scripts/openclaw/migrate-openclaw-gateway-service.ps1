[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$BackupPath,
    [ValidateRange(1, 65535)][int]$Port = 18789,
    [switch]$ResumeAfterInstall,
    [switch]$Execute
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$activeCmd = 'D:\openclaw\bin\openclaw.cmd'
$activeRoot = 'D:\openclaw'
$activeCliEntry = 'D:\openclaw\runtime\openclaw\node_modules\openclaw\openclaw.mjs'
$activeServiceEntry = 'D:\openclaw\runtime\openclaw\node_modules\openclaw\dist\index.js'
$approvedNode = 'C:\Program Files\nodejs\node.exe'
$npmPrefix = (& npm prefix -g).Trim()
$manifestPath = Join-Path $BackupPath 'manifest.json'
$restoreScript = Join-Path $BackupPath 'restore-openclaw-gateway-service.ps1'

function Assert-Condition {
    param(
        [Parameter(Mandatory)][bool]$Condition,
        [Parameter(Mandatory)][string]$Message
    )
    if (-not $Condition) {
        throw $Message
    }
}

function Get-Sha256 {
    param([Parameter(Mandatory)][string]$Path)
    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Invoke-Captured {
    param([Parameter(Mandatory)][scriptblock]$Command)
    $output = @(& $Command 2>&1)
    [pscustomobject]@{
        ExitCode = $LASTEXITCODE
        Text = $output -join [Environment]::NewLine
    }
}

function Get-GatewayListenerPids {
    $matches = @(& netstat.exe -ano -p tcp |
        Select-String -Pattern "^\s*TCP\s+\S+:$Port\s+\S+\s+LISTENING\s+(\d+)\s*$")
    @($matches | ForEach-Object {
        if ($_.Line -match "^\s*TCP\s+\S+:$Port\s+\S+\s+LISTENING\s+(\d+)\s*$") {
            [int]$Matches[1]
        }
    } | Sort-Object -Unique)
}

function Get-ApprovedGatewayListener {
    foreach ($listenerPid in @(Get-GatewayListenerPids)) {
        $process = Get-CimInstance Win32_Process -Filter "ProcessId=$listenerPid" -ErrorAction SilentlyContinue
        if (
            $null -ne $process -and
            [string]$process.ExecutablePath -eq $approvedNode -and
            [string]$process.CommandLine -like "*$activeServiceEntry*" -and
            [string]$process.CommandLine -match '(?i)\bgateway\b'
        ) {
            return $process
        }
    }
    return $null
}

function Wait-GatewayState {
    param(
        [Parameter(Mandatory)][ValidateSet('Listening', 'Stopped')][string]$State,
        [int]$TimeoutSeconds = 30
    )
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        $listenerPids = @(Get-GatewayListenerPids)
        $approvedListener = Get-ApprovedGatewayListener
        if ($State -eq 'Listening' -and $null -ne $approvedListener) {
            return $true
        }
        if ($State -eq 'Stopped' -and $listenerPids.Count -eq 0) {
            return $true
        }
        Start-Sleep -Seconds 1
    } while ((Get-Date) -lt $deadline)
    return $false
}

Assert-Condition -Condition (Test-Path -LiteralPath $manifestPath -PathType Leaf) -Message "Gateway backup manifest is missing: $manifestPath"
Assert-Condition -Condition (Test-Path -LiteralPath $restoreScript -PathType Leaf) -Message "Gateway rollback script is missing: $restoreScript"
Assert-Condition -Condition (Test-Path -LiteralPath $activeCmd -PathType Leaf) -Message "Active OpenClaw launcher is missing: $activeCmd"
Assert-Condition -Condition (Test-Path -LiteralPath $activeCliEntry -PathType Leaf) -Message "Approved OpenClaw CLI entrypoint is missing: $activeCliEntry"
Assert-Condition -Condition (Test-Path -LiteralPath $activeServiceEntry -PathType Leaf) -Message "Approved OpenClaw service entrypoint is missing: $activeServiceEntry"
Assert-Condition -Condition (Test-Path -LiteralPath $approvedNode -PathType Leaf) -Message "Approved Node runtime is missing: $approvedNode"

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json -Depth 100
$gatewayScript = [string]$manifest.GatewayScript.Source
$configPath = [string]$manifest.Config.Source
$taskName = [string]$manifest.TaskName
Assert-Condition -Condition (Test-Path -LiteralPath $gatewayScript -PathType Leaf) -Message "Gateway script is missing: $gatewayScript"
Assert-Condition -Condition (Test-Path -LiteralPath $configPath -PathType Leaf) -Message "OpenClaw config is missing: $configPath"
Assert-Condition -Condition ((Get-Sha256 -Path $configPath) -eq [string]$manifest.Config.SHA256) -Message 'OpenClaw config changed after backup; create a fresh backup before migration.'

$whereOpenClaw = @(& where.exe openclaw 2>$null)
Assert-Condition -Condition ($whereOpenClaw.Count -gt 0) -Message 'openclaw is not resolvable.'
Assert-Condition -Condition ($whereOpenClaw[0].StartsWith(
    (Join-Path $activeRoot 'bin'),
    [StringComparison]::OrdinalIgnoreCase
)) -Message "Active openclaw owner is not D:\openclaw\bin: $($whereOpenClaw[0])"

$versionProbe = Invoke-Captured -Command { & $activeCmd --version }
Assert-Condition -Condition ($versionProbe.ExitCode -eq 0) -Message 'Approved OpenClaw launcher failed its version probe.'
$configProbe = Invoke-Captured -Command { & $activeCmd config validate }
Assert-Condition -Condition ($configProbe.ExitCode -eq 0) -Message 'OpenClaw config validation failed before migration.'

$task = Get-ScheduledTask -TaskName $taskName -ErrorAction Stop
$taskAction = @($task.Actions)[0]
Assert-Condition -Condition ([string]$taskAction.Execute -eq $gatewayScript) -Message 'Scheduled-task action changed after backup.'
$gatewayBefore = Get-Content -LiteralPath $gatewayScript -Raw
$gatewayHashBeforeRun = Get-Sha256 -Path $gatewayScript
$matchesOriginalBackup = $gatewayHashBeforeRun -eq [string]$manifest.GatewayScript.SHA256
$matchesApprovedPostInstall = (
    $gatewayBefore -notlike "*$npmPrefix*" -and
    $gatewayBefore -like "*$approvedNode*" -and
    $gatewayBefore -like "*$activeServiceEntry*"
)
$migrationMode = if ($matchesOriginalBackup) {
    'PreMigration'
}
elseif ($ResumeAfterInstall -and $matchesApprovedPostInstall) {
    'ResumeAfterInstall'
}
else {
    throw 'Gateway script does not match either the original backup or the explicitly approved post-install resume state.'
}
if ($migrationMode -eq 'PreMigration') {
    Assert-Condition -Condition ($gatewayBefore -like "*$npmPrefix*") -Message 'Original gateway script does not reference the expected npm-global prefix.'
    Assert-Condition -Condition ($gatewayBefore -notlike "*$activeRoot*") -Message 'Original gateway script already references the operational root.'
}

$rollbackDryRun = Invoke-Captured -Command { & $restoreScript }
Assert-Condition -Condition ($rollbackDryRun.ExitCode -eq 0) -Message 'Rollback script dry run failed.'

Write-Host 'OpenClaw Gateway migration preflight'
Write-Host "Backup: $BackupPath"
Write-Host "Mode: $migrationMode"
Write-Host "Before owner category: broken npm-global OpenClaw"
Write-Host "Target owner: $approvedNode -> $activeServiceEntry"
Write-Host "Scheduled task: $taskName"
Write-Host "Port: $Port"
Write-Host 'Rollback dry run: PASS'

if (-not $Execute) {
    Write-Host ''
    Write-Host 'DRY RUN ONLY. Re-run with -Execute after reviewing the backup and preflight.'
    exit 0
}

$configHashBeforeInstall = Get-Sha256 -Path $configPath
if ($migrationMode -eq 'PreMigration') {
    $stopBefore = Invoke-Captured -Command { & $activeCmd gateway stop --json }
    Set-Content -LiteralPath (Join-Path $BackupPath 'migration-stop-before-output.txt') -Value $stopBefore.Text -Encoding utf8
    if ($stopBefore.ExitCode -ne 0) {
        throw 'Unable to stop the pre-migration gateway task.'
    }
    Assert-Condition -Condition (Wait-GatewayState -State Stopped) -Message "Gateway port $Port did not stop before reinstall."

    $installProbe = Invoke-Captured -Command {
        & $activeCmd gateway install --force --runtime node --port $Port --json
    }
    Set-Content -LiteralPath (Join-Path $BackupPath 'migration-install-output.txt') -Value $installProbe.Text -Encoding utf8
    if ($installProbe.ExitCode -ne 0) {
        throw 'Gateway service reinstall failed. Raw output is retained only in the external backup.'
    }
}

$taskAfterInstall = Get-ScheduledTask -TaskName $taskName -ErrorAction Stop
$taskActionAfterInstall = @($taskAfterInstall.Actions)[0]
Assert-Condition -Condition ([string]$taskActionAfterInstall.Execute -eq $gatewayScript) -Message 'Gateway reinstall changed the scheduled-task action unexpectedly.'
$gatewayAfter = Get-Content -LiteralPath $gatewayScript -Raw
Assert-Condition -Condition ($gatewayAfter -notlike "*$npmPrefix*") -Message 'Migrated gateway script still references npm-global OpenClaw.'
Assert-Condition -Condition ($gatewayAfter -like "*$approvedNode*") -Message 'Migrated gateway script does not reference the approved system Node runtime.'
Assert-Condition -Condition ($gatewayAfter -like "*$activeServiceEntry*") -Message 'Migrated gateway script does not reference the approved D:\openclaw service entrypoint.'
Assert-Condition -Condition ((Get-Sha256 -Path $configPath) -eq $configHashBeforeInstall) -Message 'Gateway reinstall unexpectedly changed openclaw.json.'
if ($migrationMode -eq 'ResumeAfterInstall' -and $null -eq (Get-ApprovedGatewayListener)) {
    $resumeStart = Invoke-Captured -Command { & $activeCmd gateway start --json }
    Set-Content -LiteralPath (Join-Path $BackupPath 'migration-resume-start-output.txt') -Value $resumeStart.Text -Encoding utf8
    Assert-Condition -Condition ($resumeStart.ExitCode -eq 0) -Message 'Gateway could not be started while resuming the post-install migration.'
}
Assert-Condition -Condition (Wait-GatewayState -State Listening) -Message "Gateway did not listen on port $Port after reinstall."

$healthAfterInstall = Invoke-Captured -Command { & $activeCmd gateway health --json }
Set-Content -LiteralPath (Join-Path $BackupPath 'migration-health-after-install.txt') -Value $healthAfterInstall.Text -Encoding utf8
Assert-Condition -Condition ($healthAfterInstall.ExitCode -eq 0) -Message 'Gateway health probe failed after reinstall.'

$stopProbe = Invoke-Captured -Command { & $activeCmd gateway stop --json }
Set-Content -LiteralPath (Join-Path $BackupPath 'migration-stop-proof.txt') -Value $stopProbe.Text -Encoding utf8
Assert-Condition -Condition ($stopProbe.ExitCode -eq 0) -Message 'Gateway stop proof failed.'
Assert-Condition -Condition (Wait-GatewayState -State Stopped) -Message "Gateway port $Port remained active after stop."

$startProbe = Invoke-Captured -Command { & $activeCmd gateway start --json }
Set-Content -LiteralPath (Join-Path $BackupPath 'migration-start-proof.txt') -Value $startProbe.Text -Encoding utf8
Assert-Condition -Condition ($startProbe.ExitCode -eq 0) -Message 'Gateway start proof failed.'
Assert-Condition -Condition (Wait-GatewayState -State Listening) -Message "Gateway port $Port did not return after start."
$healthAfterStart = Invoke-Captured -Command { & $activeCmd gateway health --json }
Assert-Condition -Condition ($healthAfterStart.ExitCode -eq 0) -Message 'Gateway health probe failed after start.'

$restartProbe = Invoke-Captured -Command { & $activeCmd gateway restart --force --json }
Set-Content -LiteralPath (Join-Path $BackupPath 'migration-restart-proof.txt') -Value $restartProbe.Text -Encoding utf8
Assert-Condition -Condition ($restartProbe.ExitCode -eq 0) -Message 'Gateway restart proof failed.'
Assert-Condition -Condition (Wait-GatewayState -State Listening) -Message "Gateway port $Port did not return after restart."
$healthAfterRestart = Invoke-Captured -Command { & $activeCmd gateway health --json }
Set-Content -LiteralPath (Join-Path $BackupPath 'migration-health-after-restart.txt') -Value $healthAfterRestart.Text -Encoding utf8
Assert-Condition -Condition ($healthAfterRestart.ExitCode -eq 0) -Message 'Gateway health probe failed after restart.'
$approvedListenerAfterRestart = Get-ApprovedGatewayListener
Assert-Condition -Condition ($null -ne $approvedListenerAfterRestart) -Message 'Gateway listener owner is not the approved D:\openclaw service process after restart.'

$result = [ordered]@{
    CompletedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
    BackupPath = [IO.Path]::GetFullPath($BackupPath)
    TaskName = $taskName
    TaskAction = [string]$taskActionAfterInstall.Execute
    Port = $Port
    BeforeOwnerCategory = 'broken npm-global OpenClaw'
    AfterNodeOwner = $approvedNode
    AfterCliEntry = $activeCliEntry
    AfterRuntimeEntry = $activeServiceEntry
    GatewayScriptSHA256Before = [string]$manifest.GatewayScript.SHA256
    GatewayScriptSHA256After = Get-Sha256 -Path $gatewayScript
    ConfigSHA256Before = $configHashBeforeInstall
    ConfigSHA256After = Get-Sha256 -Path $configPath
    StopVerified = $true
    StartVerified = $true
    RestartVerified = $true
    HealthVerified = $true
    ListenerProcessId = [int]$approvedListenerAfterRestart.ProcessId
    ListenerExecutable = [string]$approvedListenerAfterRestart.ExecutablePath
    NpmGlobalReferenceRemoved = $true
    RollbackDryRunVerified = $true
}
$result | ConvertTo-Json -Depth 6 |
    Set-Content -LiteralPath (Join-Path $BackupPath 'migration-result.json') -Encoding utf8

Write-Host ''
Write-Host 'GATEWAY MIGRATION COMPLETE'
Write-Host "After owner: $approvedNode -> $activeServiceEntry"
Write-Host "Task action: $($taskActionAfterInstall.Execute)"
Write-Host "Gateway script SHA256: $($result.GatewayScriptSHA256After)"
Write-Host "Listener PID: $($result.ListenerProcessId)"
Write-Host "Rollback: $restoreScript"
Write-Host 'Gateway stop, start, restart, listener, and health probes passed.'
