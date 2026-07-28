[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$BackupPath,
    [switch]$Execute
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$settingsPath = Join-Path $env:APPDATA 'clawx\settings.json'
$clawXExe = 'C:\Program Files\ClawX\ClawX.exe'
$appAsar = 'C:\Program Files\ClawX\resources\app.asar'
$backupRoot = Join-Path $BackupPath 'clawx-app-data'
$settingsBackup = Join-Path $backupRoot 'settings.json'
$evidencePath = Join-Path $backupRoot 'gateway-autostart-change.sanitized.json'
$restorePath = Join-Path $backupRoot 'restore-clawx-gateway-settings.ps1'

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

function Get-PortListenerPids {
    $matches = @(& netstat.exe -ano -p tcp |
        Select-String -Pattern '^\s*TCP\s+\S+:18789\s+\S+\s+LISTENING\s+(\d+)\s*$')
    @($matches | ForEach-Object {
        if ($_.Line -match '^\s*TCP\s+\S+:18789\s+\S+\s+LISTENING\s+(\d+)\s*$') {
            [int]$Matches[1]
        }
    } | Sort-Object -Unique)
}

foreach ($required in @($settingsPath, $clawXExe, $appAsar)) {
    Assert-Condition -Condition (Test-Path -LiteralPath $required -PathType Leaf) -Message "Required ClawX file is missing: $required"
}
Assert-Condition -Condition (Test-Path -LiteralPath $BackupPath -PathType Container) -Message "Gateway backup path is missing: $BackupPath"

$settingsText = [IO.File]::ReadAllText($settingsPath)
$settings = $settingsText | ConvertFrom-Json -Depth 100
Assert-Condition -Condition ($settings.PSObject.Properties.Name -contains 'gatewayAutoStart') -Message 'ClawX settings do not contain gatewayAutoStart.'
$gatewayAutoStartBefore = [bool]$settings.gatewayAutoStart
if (-not $gatewayAutoStartBefore) {
    Write-Host 'ClawX embedded gateway auto-start preflight'
    Write-Host "Settings: $settingsPath"
    Write-Host 'Current gatewayAutoStart: false'
    Write-Host 'Target gatewayAutoStart: false'
    Write-Host 'ALREADY DISABLED. No file or process change is required.'
    exit 0
}
$matchCount = [regex]::Matches(
    $settingsText,
    '("gatewayAutoStart"\s*:\s*)true',
    [Text.RegularExpressions.RegexOptions]::IgnoreCase
).Count
Assert-Condition -Condition ($matchCount -eq 1) -Message "Expected exactly one true gatewayAutoStart JSON field; found $matchCount."

$asarBytes = [IO.File]::ReadAllBytes($appAsar)
$asarText = [Text.Encoding]::UTF8.GetString($asarBytes)
Assert-Condition -Condition ($asarText.Contains('gatewayAutoStart')) -Message 'Installed ClawX app bundle does not contain the gatewayAutoStart contract.'
Assert-Condition -Condition ($asarText.Contains('Auto-starting Gateway')) -Message 'Installed ClawX app bundle does not contain the embedded gateway auto-start behavior.'

$clawXProcesses = @(Get-Process -Name ClawX -ErrorAction SilentlyContinue)
$clawXListenerPids = @(
    Get-PortListenerPids |
        Where-Object {
            $process = Get-CimInstance Win32_Process -Filter "ProcessId=$_" -ErrorAction SilentlyContinue
            $null -ne $process -and [string]$process.ExecutablePath -eq $clawXExe
        }
)

Write-Host 'ClawX embedded gateway auto-start preflight'
Write-Host "Settings: $settingsPath"
Write-Host 'Current gatewayAutoStart: true'
Write-Host 'Target gatewayAutoStart: false'
Write-Host "ClawX process count: $($clawXProcesses.Count)"
Write-Host "ClawX-owned gateway listener count: $($clawXListenerPids.Count)"
Write-Host "Backup target: $settingsBackup"

if (-not $Execute) {
    Write-Host ''
    Write-Host 'DRY RUN ONLY. Re-run with -Execute to back up the settings, close ClawX, and disable only its embedded gateway auto-start flag.'
    exit 0
}

New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
Copy-Item -LiteralPath $settingsPath -Destination $settingsBackup -Force
$settingsHashBefore = Get-Sha256 -Path $settingsPath
Assert-Condition -Condition ((Get-Sha256 -Path $settingsBackup) -eq $settingsHashBefore) -Message 'ClawX settings backup hash mismatch.'

$restoreScript = @'
[CmdletBinding()]
param([switch]$Execute)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$backupRoot = $PSScriptRoot
$evidence = Get-Content -LiteralPath (Join-Path $backupRoot 'gateway-autostart-change.sanitized.json') -Raw |
    ConvertFrom-Json -Depth 20
$settingsBackup = Join-Path $backupRoot 'settings.json'
if (-not (Test-Path -LiteralPath $settingsBackup -PathType Leaf)) {
    throw "ClawX settings backup is missing: $settingsBackup"
}
if ((Get-FileHash -LiteralPath $settingsBackup -Algorithm SHA256).Hash -ne [string]$evidence.SettingsSHA256Before) {
    throw 'ClawX settings backup hash mismatch.'
}
if (Get-Process -Name ClawX -ErrorAction SilentlyContinue) {
    throw 'Close ClawX before restoring its settings.'
}
Write-Host "Restore source: $settingsBackup"
Write-Host "Restore target: $($evidence.SettingsPath)"
Write-Host 'Backup hash: PASS'
if (-not $Execute) {
    Write-Host 'DRY RUN ONLY. Re-run with -Execute after ClawX is closed.'
    exit 0
}
Copy-Item -LiteralPath $settingsBackup -Destination ([string]$evidence.SettingsPath) -Force
if ((Get-FileHash -LiteralPath ([string]$evidence.SettingsPath) -Algorithm SHA256).Hash -ne [string]$evidence.SettingsSHA256Before) {
    throw 'Restored ClawX settings hash mismatch.'
}
Write-Host 'CLAWX SETTINGS ROLLBACK COMPLETE'
'@

$evidence = [ordered]@{
    CapturedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
    SettingsPath = $settingsPath
    SettingsBackup = $settingsBackup
    SettingsSHA256Before = $settingsHashBefore
    GatewayAutoStartBefore = $true
    GatewayAutoStartAfter = $false
    InstalledContractContainsSetting = $true
    InstalledContractContainsAutoStartBehavior = $true
    ClawXProcessCountBefore = $clawXProcesses.Count
    ClawXListenerPidsBefore = $clawXListenerPids
}
$evidence | ConvertTo-Json -Depth 5 |
    Set-Content -LiteralPath $evidencePath -Encoding utf8
Set-Content -LiteralPath $restorePath -Value $restoreScript -Encoding utf8

foreach ($process in $clawXProcesses | Sort-Object Id -Descending) {
    [void]$process.CloseMainWindow()
}
$deadline = (Get-Date).AddSeconds(15)
do {
    $remaining = @(Get-Process -Name ClawX -ErrorAction SilentlyContinue)
    if ($remaining.Count -eq 0) {
        break
    }
    Start-Sleep -Seconds 1
} while ((Get-Date) -lt $deadline)
$remaining = @(Get-Process -Name ClawX -ErrorAction SilentlyContinue)
if ($remaining.Count -gt 0) {
    $remaining | Stop-Process -Force
    Start-Sleep -Seconds 2
}
Assert-Condition -Condition (@(Get-Process -Name ClawX -ErrorAction SilentlyContinue).Count -eq 0) -Message 'ClawX did not close.'
Assert-Condition -Condition (@(Get-PortListenerPids).Count -eq 0) -Message 'Port 18789 is still owned after ClawX shutdown.'

$updatedText = [regex]::Replace(
    $settingsText,
    '("gatewayAutoStart"\s*:\s*)true',
    '${1}false',
    [Text.RegularExpressions.RegexOptions]::IgnoreCase
)
[IO.File]::WriteAllText($settingsPath, $updatedText, [Text.UTF8Encoding]::new($false))
$updated = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json -Depth 100
Assert-Condition -Condition (-not [bool]$updated.gatewayAutoStart) -Message 'ClawX gatewayAutoStart did not persist as false.'
$settingsHashAfter = Get-Sha256 -Path $settingsPath
Assert-Condition -Condition ($settingsHashAfter -ne $settingsHashBefore) -Message 'ClawX settings hash did not change.'

$evidence['SettingsSHA256After'] = $settingsHashAfter
$evidence['CompletedAtUtc'] = (Get-Date).ToUniversalTime().ToString('o')
$evidence | ConvertTo-Json -Depth 5 |
    Set-Content -LiteralPath $evidencePath -Encoding utf8

& $restorePath

Write-Host ''
Write-Host 'CLAWX EMBEDDED GATEWAY AUTO-START DISABLED'
Write-Host "Settings SHA256 before: $settingsHashBefore"
Write-Host "Settings SHA256 after: $settingsHashAfter"
Write-Host "Rollback: $restorePath"
Write-Host 'ClawX is closed and port 18789 is free for the authoritative OpenClaw scheduled task.'
