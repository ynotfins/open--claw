[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$OpenClawArgs
)

$launcher = Join-Path $PSScriptRoot '..\scripts\openclaw\Invoke-ControlPlaneOpenClaw.ps1'
& $launcher @OpenClawArgs
exit $LASTEXITCODE
