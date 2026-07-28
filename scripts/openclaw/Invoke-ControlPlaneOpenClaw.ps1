[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$OpenClawArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$approvedNode = 'C:\Program Files\nodejs\node.exe'
$approvedOperationalRoot = 'D:\openclaw'
$approvedWrapper = Join-Path $approvedOperationalRoot 'scripts\Invoke-ClawXOpenClaw.ps1'
$approvedEntry = Join-Path $approvedOperationalRoot 'runtime\openclaw\node_modules\openclaw\openclaw.mjs'
$approvedPackage = Join-Path $approvedOperationalRoot 'runtime\openclaw\node_modules\openclaw\package.json'

foreach ($required in @($approvedNode, $approvedWrapper, $approvedEntry, $approvedPackage)) {
    if (-not (Test-Path -LiteralPath $required -PathType Leaf)) {
        throw "Approved OpenClaw control-plane dependency is missing: $required"
    }
}

$nodeVersion = & $approvedNode -p 'process.versions.node'
if ($LASTEXITCODE -ne 0) {
    throw "Unable to query the approved Node runtime: $approvedNode"
}
$nodeParts = @($nodeVersion -split '\.' | ForEach-Object { [int]$_ })
if ($nodeParts[0] -lt 22 -or ($nodeParts[0] -eq 22 -and $nodeParts[1] -lt 19)) {
    throw "OpenClaw requires Node >=22.19.0; approved Node is $nodeVersion"
}

$package = Get-Content -LiteralPath $approvedPackage -Raw | ConvertFrom-Json
if ($package.name -ne 'openclaw' -or [string]::IsNullOrWhiteSpace($package.version)) {
    throw "Approved runtime package metadata is invalid: $approvedPackage"
}

& $approvedWrapper @OpenClawArgs
exit $LASTEXITCODE
