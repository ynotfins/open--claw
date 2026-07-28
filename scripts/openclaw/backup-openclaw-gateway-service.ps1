[CmdletBinding()]
param(
    [string]$BackupRoot = (Join-Path $env:USERPROFILE 'openclaw-control-plane-backups\gateway-service'),
    [string]$TaskName = 'OpenClaw Gateway',
    [switch]$Execute
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupPath = Join-Path $BackupRoot $timestamp
$liveStateRoot = Join-Path $env:USERPROFILE '.openclaw'
$gatewayScript = Join-Path $liveStateRoot 'gateway.cmd'
$configPath = Join-Path $liveStateRoot 'openclaw.json'
$activeCmd = 'D:\openclaw\bin\openclaw.cmd'
$activePowerShell = 'D:\openclaw\bin\openclaw.ps1'
$activeWrapper = 'D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1'
$activeEntry = 'D:\openclaw\runtime\openclaw\node_modules\openclaw\openclaw.mjs'
$activeServiceEntry = 'D:\openclaw\runtime\openclaw\node_modules\openclaw\dist\index.js'
$activePackage = 'D:\openclaw\runtime\openclaw\node_modules\openclaw\package.json'
$startupRoot = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup'
$startupCandidates = @(
    (Join-Path $startupRoot "$TaskName.vbs"),
    (Join-Path $startupRoot "$TaskName.cmd")
)

function Get-Sha256 {
    param([Parameter(Mandatory)][string]$Path)
    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Get-TextSha256 {
    param([Parameter(Mandatory)][string]$Text)
    $bytes = [Text.Encoding]::Unicode.GetBytes($Text)
    [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($bytes))
}

function Assert-Leaf {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Label
    )
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "$Label is missing: $Path"
    }
}

foreach ($required in @(
    @{ Path = $gatewayScript; Label = 'Gateway task script' },
    @{ Path = $configPath; Label = 'OpenClaw config' },
    @{ Path = $activeCmd; Label = 'Active OpenClaw launcher' },
    @{ Path = $activePowerShell; Label = 'Active OpenClaw PowerShell launcher' },
    @{ Path = $activeWrapper; Label = 'Active OpenClaw wrapper' },
    @{ Path = $activeEntry; Label = 'Active OpenClaw runtime entrypoint' },
    @{ Path = $activeServiceEntry; Label = 'Active OpenClaw service entrypoint' },
    @{ Path = $activePackage; Label = 'Active OpenClaw package metadata' }
)) {
    Assert-Leaf -Path $required.Path -Label $required.Label
}

$task = Get-ScheduledTask -TaskName $TaskName -ErrorAction Stop
$taskInfo = Get-ScheduledTaskInfo -TaskName $TaskName -ErrorAction Stop
$taskAction = @($task.Actions)[0]
if ($null -eq $taskAction) {
    throw "Scheduled task has no executable action: $TaskName"
}
if (-not ([string]$taskAction.Execute).Equals($gatewayScript, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Scheduled task action is not the expected gateway script: $($taskAction.Execute)"
}

$taskXml = Export-ScheduledTask -TaskName $TaskName -ErrorAction Stop
$gatewayContent = Get-Content -LiteralPath $gatewayScript -Raw
$config = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json -Depth 100
$secretRisk = [ordered]@{
    GatewayScriptContainsTokenLikeName = [bool]($gatewayContent -match '(?i)(token|secret|api[_-]?key|password)')
    ConfigUsesTokenAuth = [bool]([string]$config.gateway.auth.mode -eq 'token')
    ConfigContainsConfiguredToken = [bool](
        $null -ne $config.gateway.auth.token -and
        -not [string]::IsNullOrWhiteSpace([string]$config.gateway.auth.token)
    )
}

Write-Host 'OpenClaw Gateway backup plan'
Write-Host "Target: $backupPath"
Write-Host "Scheduled task: $TaskName"
Write-Host "Task action: $($taskAction.Execute)"
Write-Host "Gateway script: $gatewayScript"
Write-Host "Config: $configPath"
Write-Host 'Sensitive values will be copied only into the external backup and will not be printed.'

if (-not $Execute) {
    Write-Host ''
    Write-Host 'DRY RUN ONLY. Re-run with -Execute to create the timestamped backup and rollback script.'
    exit 0
}

New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
$liveBackup = New-Item -ItemType Directory -Path (Join-Path $backupPath 'live-state') -Force
$taskBackup = New-Item -ItemType Directory -Path (Join-Path $backupPath 'scheduled-task') -Force
$runtimeBackup = New-Item -ItemType Directory -Path (Join-Path $backupPath 'runtime-contract') -Force
$startupBackup = New-Item -ItemType Directory -Path (Join-Path $backupPath 'startup-entries') -Force

$gatewayBackupPath = Join-Path $liveBackup.FullName 'gateway.cmd'
$configBackupPath = Join-Path $liveBackup.FullName 'openclaw.json'
$taskXmlPath = Join-Path $taskBackup.FullName 'OpenClaw-Gateway.xml'
Copy-Item -LiteralPath $gatewayScript -Destination $gatewayBackupPath -Force
Copy-Item -LiteralPath $configPath -Destination $configBackupPath -Force
Set-Content -LiteralPath $taskXmlPath -Value $taskXml -Encoding unicode

$runtimeCopies = [ordered]@{}
foreach ($source in @(
    $activeCmd,
    $activePowerShell,
    $activeWrapper,
    $activeEntry,
    $activeServiceEntry,
    $activePackage
)) {
    $destination = Join-Path $runtimeBackup.FullName ([IO.Path]::GetFileName($source))
    if (Test-Path -LiteralPath $destination) {
        $destination = Join-Path $runtimeBackup.FullName (
            '{0}-{1}{2}' -f
                ([IO.Path]::GetFileNameWithoutExtension($source)),
                $runtimeCopies.Count,
                ([IO.Path]::GetExtension($source))
        )
    }
    Copy-Item -LiteralPath $source -Destination $destination -Force
    $runtimeCopies[$source] = [ordered]@{
        BackupPath = $destination
        SHA256 = Get-Sha256 -Path $source
    }
}

$startupCopies = [ordered]@{}
foreach ($source in $startupCandidates) {
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        continue
    }
    $destination = Join-Path $startupBackup.FullName ([IO.Path]::GetFileName($source))
    Copy-Item -LiteralPath $source -Destination $destination -Force
    $startupCopies[$source] = [ordered]@{
        BackupPath = $destination
        SHA256 = Get-Sha256 -Path $source
    }
}

$taskEvidence = [ordered]@{
    TaskName = $TaskName
    State = [string]$task.State
    Execute = [string]$taskAction.Execute
    ArgumentsPresent = -not [string]::IsNullOrWhiteSpace([string]$taskAction.Arguments)
    WorkingDirectory = [string]$taskAction.WorkingDirectory
    RunAs = [string]$task.Principal.UserId
    LogonType = [string]$task.Principal.LogonType
    RunLevel = [string]$task.Principal.RunLevel
    LastRunTime = $taskInfo.LastRunTime.ToUniversalTime().ToString('o')
    LastTaskResult = $taskInfo.LastTaskResult
}
$taskEvidence | ConvertTo-Json -Depth 5 |
    Set-Content -LiteralPath (Join-Path $taskBackup.FullName 'task-metadata.sanitized.json') -Encoding utf8

$manifest = [ordered]@{
    SchemaVersion = 1
    CreatedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
    BackupPath = $backupPath
    TaskName = $TaskName
    GatewayScript = [ordered]@{
        Source = $gatewayScript
        BackupPath = $gatewayBackupPath
        SHA256 = Get-Sha256 -Path $gatewayScript
        ReferencesNpmGlobal = [bool]($gatewayContent -like '*AppData\Roaming\npm*')
        ReferencesOperationalRoot = [bool]($gatewayContent -like '*D:\openclaw*')
    }
    Config = [ordered]@{
        Source = $configPath
        BackupPath = $configBackupPath
        SHA256 = Get-Sha256 -Path $configPath
        GatewayMode = [string]$config.gateway.mode
        GatewayBind = [string]$config.gateway.bind
        GatewayAuthMode = [string]$config.gateway.auth.mode
    }
    ScheduledTask = [ordered]@{
        XmlBackupPath = $taskXmlPath
        XmlSHA256 = Get-TextSha256 -Text $taskXml
        ActionExecute = [string]$taskAction.Execute
        OriginalState = [string]$task.State
        OriginalLastTaskResult = $taskInfo.LastTaskResult
    }
    RuntimeContract = $runtimeCopies
    StartupEntries = $startupCopies
    SecretRisk = $secretRisk
}
$manifestPath = Join-Path $backupPath 'manifest.json'
$manifest | ConvertTo-Json -Depth 10 |
    Set-Content -LiteralPath $manifestPath -Encoding utf8

$restoreScript = @'
[CmdletBinding()]
param(
    [switch]$Execute,
    [switch]$StartAfterRestore
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-Sha256 {
    param([Parameter(Mandatory)][string]$Path)
    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Assert-BackupArtifact {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$ExpectedHash,
        [Parameter(Mandatory)][string]$Label
    )
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "$Label backup is missing: $Path"
    }
    $actualHash = Get-Sha256 -Path $Path
    if ($actualHash -ne $ExpectedHash) {
        throw "$Label backup hash mismatch."
    }
}

$backupRoot = $PSScriptRoot
$manifestPath = Join-Path $backupRoot 'manifest.json'
if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    throw "Backup manifest is missing: $manifestPath"
}
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json -Depth 100
$gatewayBackup = [string]$manifest.GatewayScript.BackupPath
$configBackup = [string]$manifest.Config.BackupPath
$taskXmlBackup = [string]$manifest.ScheduledTask.XmlBackupPath

Assert-BackupArtifact -Path $gatewayBackup -ExpectedHash ([string]$manifest.GatewayScript.SHA256) -Label 'Gateway script'
Assert-BackupArtifact -Path $configBackup -ExpectedHash ([string]$manifest.Config.SHA256) -Label 'OpenClaw config'
if (-not (Test-Path -LiteralPath $taskXmlBackup -PathType Leaf)) {
    throw "Scheduled-task XML backup is missing: $taskXmlBackup"
}

Write-Host "Restore source: $backupRoot"
Write-Host "Task: $($manifest.TaskName)"
Write-Host "Gateway script target: $($manifest.GatewayScript.Source)"
Write-Host "Config target: $($manifest.Config.Source)"
Write-Host 'Backup artifacts and hashes are valid.'

if (-not $Execute) {
    Write-Host 'DRY RUN ONLY. Re-run with -Execute to restore the exact task, gateway script, and config.'
    exit 0
}

$preRollback = Join-Path $backupRoot ('pre-rollback-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $preRollback -Force | Out-Null
foreach ($target in @([string]$manifest.GatewayScript.Source, [string]$manifest.Config.Source)) {
    if (Test-Path -LiteralPath $target -PathType Leaf) {
        Copy-Item -LiteralPath $target -Destination $preRollback -Force
    }
}
$currentTask = Get-ScheduledTask -TaskName ([string]$manifest.TaskName) -ErrorAction SilentlyContinue
if ($null -ne $currentTask) {
    Export-ScheduledTask -TaskName ([string]$manifest.TaskName) |
        Set-Content -LiteralPath (Join-Path $preRollback 'OpenClaw-Gateway.xml') -Encoding unicode
    & schtasks.exe /End /TN ([string]$manifest.TaskName) 1>$null 2>$null
}

Copy-Item -LiteralPath $gatewayBackup -Destination ([string]$manifest.GatewayScript.Source) -Force
Copy-Item -LiteralPath $configBackup -Destination ([string]$manifest.Config.Source) -Force
& schtasks.exe /Create /F /TN ([string]$manifest.TaskName) /XML $taskXmlBackup 1>$null
if ($LASTEXITCODE -ne 0) {
    throw "Failed to restore scheduled task '$($manifest.TaskName)'."
}

if ((Get-Sha256 -Path ([string]$manifest.GatewayScript.Source)) -ne [string]$manifest.GatewayScript.SHA256) {
    throw 'Restored gateway script hash mismatch.'
}
if ((Get-Sha256 -Path ([string]$manifest.Config.Source)) -ne [string]$manifest.Config.SHA256) {
    throw 'Restored OpenClaw config hash mismatch.'
}
$restoredTask = Get-ScheduledTask -TaskName ([string]$manifest.TaskName) -ErrorAction Stop
$restoredAction = @($restoredTask.Actions)[0]
if (-not ([string]$restoredAction.Execute).Equals(
    [string]$manifest.ScheduledTask.ActionExecute,
    [StringComparison]::OrdinalIgnoreCase
)) {
    throw 'Restored scheduled-task action does not match the backup.'
}

if ($StartAfterRestore) {
    & schtasks.exe /Run /TN ([string]$manifest.TaskName) 1>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Scheduled task was restored but could not be started: $($manifest.TaskName)"
    }
}

Write-Host 'ROLLBACK COMPLETE'
Write-Host "Pre-rollback snapshot: $preRollback"
Write-Host "Task started: $([bool]$StartAfterRestore)"
'@
$restorePath = Join-Path $backupPath 'restore-openclaw-gateway-service.ps1'
Set-Content -LiteralPath $restorePath -Value $restoreScript -Encoding utf8

Write-Host ''
Write-Host "BACKUP_PATH=$backupPath"
Write-Host "ROLLBACK_SCRIPT=$restorePath"
Write-Host 'Gateway service backup completed. No live state, task definition, runtime, PATH, packages, ClawX files, or vendor files were modified.'
