[CmdletBinding()]
param(
    [string]$ExpectedOpenClawVersion = '2026.6.10',
    [string]$ExpectedClawHubVersion = '0.22.0',
    [string]$ExpectedLosslessClawVersion = '0.13.1',
    [switch]$RequireNpmGlobalOpenClawAbsent
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:Results = [System.Collections.Generic.List[object]]::new()

function Add-Result {
    param(
        [Parameter(Mandatory)][string]$Check,
        [Parameter(Mandatory)][ValidateSet('PASS', 'FAIL', 'WARN')][string]$Status,
        [Parameter(Mandatory)][string]$Evidence
    )

    $script:Results.Add([pscustomobject]@{
        Check = $Check
        Status = $Status
        Evidence = $Evidence
    })
}

function Get-FirstCommandPath {
    param([Parameter(Mandatory)][string]$Name)
    $paths = @(& where.exe $Name 2>$null)
    if ($LASTEXITCODE -ne 0 -or $paths.Count -eq 0) {
        return $null
    }
    return $paths[0].Trim()
}

function Invoke-Captured {
    param([Parameter(Mandatory)][scriptblock]$Command)

    try {
        $output = @(& $Command 2>&1)
        [pscustomobject]@{
            ExitCode = $LASTEXITCODE
            Text = ($output -join [Environment]::NewLine)
        }
    }
    catch {
        [pscustomobject]@{
            ExitCode = 1
            Text = $_.Exception.Message
        }
    }
}

function Test-Owner {
    param(
        [Parameter(Mandatory)][string]$Command,
        [Parameter(Mandatory)][string]$ExpectedPrefix
    )

    $owner = Get-FirstCommandPath -Name $Command
    if ($null -ne $owner -and $owner.StartsWith($ExpectedPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        Add-Result -Check "$Command owner" -Status PASS -Evidence $owner
    }
    else {
        Add-Result -Check "$Command owner" -Status FAIL -Evidence "Expected prefix '$ExpectedPrefix'; found '$owner'"
    }
}

$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$env:Path = "$machinePath;$userPath"

$systemNodeRoot = 'C:\Program Files\nodejs'
$corepackShims = Join-Path $env:LOCALAPPDATA 'Corepack\shims'
$pnpmBin = (& pnpm bin -g).Trim()
$pnpmRoot = (& pnpm root -g).Trim()
$npmPrefix = (& npm prefix -g).Trim()
$npmRoot = (& npm root -g).Trim()
$operationalRoot = 'D:\openclaw'
$activeCmd = Join-Path $operationalRoot 'bin\openclaw.cmd'
$clawXCmd = 'C:\Program Files\ClawX\resources\cli\openclaw.cmd'

$requiredOrder = @(
    (Join-Path $operationalRoot 'bin'),
    $systemNodeRoot,
    $corepackShims,
    $pnpmBin,
    $npmPrefix,
    'C:\Program Files\ClawX\resources\cli'
)
$userSegments = @($userPath -split ';' | ForEach-Object { $_.Trim().TrimEnd('\') } | Where-Object { $_ })
$indexes = @($requiredOrder | ForEach-Object {
    $needle = $_.TrimEnd('\')
    [Array]::FindIndex($userSegments, [Predicate[string]]{ param($entry) $entry.Equals($needle, [StringComparison]::OrdinalIgnoreCase) })
})
$orderValid = -not ($indexes -contains -1)
for ($i = 1; $i -lt $indexes.Count; $i++) {
    if ($indexes[$i] -le $indexes[$i - 1]) {
        $orderValid = $false
    }
}
if ($orderValid) {
    Add-Result -Check 'User PATH order' -Status PASS -Evidence ($requiredOrder -join ' -> ')
}
else {
    Add-Result -Check 'User PATH order' -Status FAIL -Evidence "Observed indexes: $($indexes -join ', ')"
}

Test-Owner -Command node -ExpectedPrefix $systemNodeRoot
Test-Owner -Command npm -ExpectedPrefix $systemNodeRoot
Test-Owner -Command npx -ExpectedPrefix $systemNodeRoot
Test-Owner -Command corepack -ExpectedPrefix $systemNodeRoot
Test-Owner -Command pnpm -ExpectedPrefix $corepackShims
Test-Owner -Command pnpx -ExpectedPrefix $corepackShims
Test-Owner -Command clawhub -ExpectedPrefix $pnpmBin
Test-Owner -Command openclaw -ExpectedPrefix (Join-Path $operationalRoot 'bin')

$versionChecks = @(
    @{ Name = 'Node version'; Command = { & node --version }; Pattern = '^v\d+\.' }
    @{ Name = 'npm version'; Command = { & npm --version }; Pattern = '^\d+\.' }
    @{ Name = 'Corepack version'; Command = { & corepack --version }; Pattern = '^\d+\.' }
    @{ Name = 'pnpm version'; Command = { & pnpm --version }; Pattern = '^\d+\.' }
    @{ Name = 'ClawHub version'; Command = { & clawhub --cli-version }; Pattern = "^$([regex]::Escape($ExpectedClawHubVersion))$" }
    @{ Name = 'Active OpenClaw version'; Command = { & $activeCmd --version }; Pattern = [regex]::Escape($ExpectedOpenClawVersion) }
    @{ Name = 'ClawX bundled OpenClaw version'; Command = { & $clawXCmd --version }; Pattern = [regex]::Escape($ExpectedOpenClawVersion) }
)
foreach ($check in $versionChecks) {
    $probe = Invoke-Captured -Command $check.Command
    $singleLine = ($probe.Text -replace '\s+', ' ').Trim()
    if ($probe.ExitCode -eq 0 -and $singleLine -match $check.Pattern) {
        Add-Result -Check $check.Name -Status PASS -Evidence $singleLine
    }
    else {
        Add-Result -Check $check.Name -Status FAIL -Evidence "exit=$($probe.ExitCode); output=$singleLine"
    }
}

if ($pnpmRoot -eq (Join-Path $env:LOCALAPPDATA 'pnpm\global\v11')) {
    Add-Result -Check 'pnpm global root' -Status PASS -Evidence $pnpmRoot
}
else {
    Add-Result -Check 'pnpm global root' -Status FAIL -Evidence $pnpmRoot
}
if ($pnpmBin -eq (Join-Path $env:LOCALAPPDATA 'pnpm\bin')) {
    Add-Result -Check 'pnpm global bin' -Status PASS -Evidence $pnpmBin
}
else {
    Add-Result -Check 'pnpm global bin' -Status FAIL -Evidence $pnpmBin
}

$migratedCommands = @(
    'brave-search-mcp-server',
    'mcp-debugger',
    'mcp-server-filesystem',
    'mcp-server-sequential-thinking',
    'playwright-mcp',
    'computer-use-mcp',
    'agent-browser',
    'chrome-devtools-mcp',
    'cursor-agent-mcp',
    'mcp-google-maps'
)
foreach ($command in $migratedCommands) {
    Test-Owner -Command $command -ExpectedPrefix $pnpmBin
}

$clawHubSearch = Invoke-Captured -Command { & clawhub search code --no-input }
if ($clawHubSearch.ExitCode -eq 0) {
    Add-Result -Check 'ClawHub search' -Status PASS -Evidence 'clawhub search code --no-input exited 0'
}
else {
    Add-Result -Check 'ClawHub search' -Status FAIL -Evidence "exit=$($clawHubSearch.ExitCode)"
}

$configValidation = Invoke-Captured -Command { & openclaw config validate }
if ($configValidation.ExitCode -eq 0 -and $configValidation.Text -match '(?i)config valid') {
    Add-Result -Check 'OpenClaw config validation' -Status PASS -Evidence 'config valid'
}
else {
    Add-Result -Check 'OpenClaw config validation' -Status FAIL -Evidence "exit=$($configValidation.ExitCode)"
}

$pluginList = Invoke-Captured -Command { & openclaw plugins list --verbose }
if ($pluginList.ExitCode -eq 0 -and $pluginList.Text -match 'lossless-claw') {
    Add-Result -Check 'Lossless Claw listed' -Status PASS -Evidence 'lossless-claw present in verbose plugin list'
}
else {
    Add-Result -Check 'Lossless Claw listed' -Status FAIL -Evidence "exit=$($pluginList.ExitCode)"
}

$pluginInspect = Invoke-Captured -Command { & openclaw plugins inspect lossless-claw --runtime --json }
$requiredPluginPatterns = @(
    '"enabled"\s*:\s*true',
    '"activated"\s*:\s*true',
    '"status"\s*:\s*"loaded"',
    '"version"\s*:\s*"' + [regex]::Escape($ExpectedLosslessClawVersion) + '"',
    '"lossless-claw"',
    '"lcm_grep"',
    '"lcm_describe"',
    '"lcm_expand"',
    '"lcm_expand_query"'
)
$pluginHealthy = $pluginInspect.ExitCode -eq 0
foreach ($pattern in $requiredPluginPatterns) {
    if ($pluginInspect.Text -notmatch $pattern) {
        $pluginHealthy = $false
    }
}
if ($pluginHealthy) {
    Add-Result -Check 'Lossless Claw runtime' -Status PASS -Evidence "loaded, activated, version $ExpectedLosslessClawVersion, required tools present"
}
else {
    Add-Result -Check 'Lossless Claw runtime' -Status FAIL -Evidence "exit=$($pluginInspect.ExitCode); one or more required runtime fields missing"
}

$npmArtifacts = @(
    (Join-Path $npmPrefix 'openclaw'),
    (Join-Path $npmPrefix 'openclaw.cmd'),
    (Join-Path $npmPrefix 'openclaw.ps1'),
    (Join-Path $npmRoot 'openclaw')
)
$presentNpmArtifacts = @($npmArtifacts | Where-Object { Test-Path -LiteralPath $_ })
if ($presentNpmArtifacts.Count -eq 0) {
    Add-Result -Check 'npm-global OpenClaw residue' -Status PASS -Evidence 'No npm-global OpenClaw artifacts remain'
}
elseif ($RequireNpmGlobalOpenClawAbsent) {
    Add-Result -Check 'npm-global OpenClaw residue' -Status FAIL -Evidence "$($presentNpmArtifacts.Count) artifact(s) remain"
}
else {
    Add-Result -Check 'npm-global OpenClaw residue' -Status WARN -Evidence "$($presentNpmArtifacts.Count) artifact(s) remain"
}

$script:Results | Format-Table -AutoSize -Wrap
$failures = @($script:Results | Where-Object Status -eq 'FAIL')
$warnings = @($script:Results | Where-Object Status -eq 'WARN')
Write-Host ''
Write-Host "SUMMARY: $($script:Results.Count - $failures.Count - $warnings.Count) PASS, $($warnings.Count) WARN, $($failures.Count) FAIL"

if ($failures.Count -gt 0) {
    exit 1
}
exit 0
