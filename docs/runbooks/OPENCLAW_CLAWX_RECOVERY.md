# OpenClaw / ClawX Recovery Runbook

Baseline date: 2026-07-28
Scope: CHAOSCENTRAL Windows control plane
Default posture: inspect first; no automatic runtime repair

## Recovery Invariants

- OpenClaw is runtime/control authority.
- `D:\openclaw` is the current operational launcher/runtime authority.
- `D:\github\open--claw` is the durable control-plane source.
- `.openclaw` is live state and is never restored from Git.
- ClawX is an installer-managed UI/fallback.
- `vendor\openclaw` is read-only.
- Do not run `openclaw doctor --fix` during diagnosis.

Start from a fresh PowerShell process. If a long-lived shell has stale PATH state, rebuild only the process-local PATH:

```powershell
$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$env:Path = "$machinePath;$userPath"
```

This does not persist a PATH change.

## 1. Run the Durable Audit

```powershell
Set-Location 'D:\github\open--claw'
.\scripts\openclaw\audit-openclaw-control-plane.ps1
```

Expected authority:

- `node`, `npm`, `npx`, `corepack`: `C:\Program Files\nodejs`
- `pnpm`, `pnpx`: `C:\Users\ynotf\AppData\Local\Corepack\shims`
- `clawhub`: `C:\Users\ynotf\AppData\Local\pnpm\bin`
- `openclaw`: `D:\openclaw\bin`

## 2. Verify PATH

```powershell
where.exe node
where.exe npm
where.exe npx
where.exe corepack
where.exe pnpm
where.exe pnpx
where.exe clawhub
where.exe openclaw

[Environment]::GetEnvironmentVariable('Path', 'User')
[Environment]::GetEnvironmentVariable('Path', 'Machine')
```

Required User PATH order:

```text
D:\openclaw\bin
C:\Program Files\nodejs
C:\Users\ynotf\AppData\Local\Corepack\shims
C:\Users\ynotf\AppData\Local\pnpm\bin
C:\Users\ynotf\AppData\Roaming\npm
C:\Program Files\ClawX\resources\cli
```

The Machine PATH currently contains duplicate `C:\Program Files\nodejs` entries. This is known hygiene debt, not a reason to change Machine PATH during recovery.

## 3. Verify Node, npm, Corepack, and pnpm

```powershell
node --version
npm --version
npx --version
corepack --version
pnpm --version
pnpm root -g
pnpm bin -g
```

2026-07-28 baseline:

| Check | Expected |
| --- | --- |
| Node | `v24.16.0` |
| npm / npx | `11.13.0` |
| Corepack | `0.35.0` |
| pnpm | `11.7.0` |
| pnpm root | `C:\Users\ynotf\AppData\Local\pnpm\global\v11` |
| pnpm bin | `C:\Users\ynotf\AppData\Local\pnpm\bin` |

If pnpm is missing, inspect Corepack ownership and PATH before installing anything. Do not install a second pnpm through npm.

## 4. Verify ClawHub

```powershell
clawhub --cli-version
clawhub search code --no-input
where.exe clawhub
```

Expected:

- version `0.22.0`;
- search exits `0`;
- first owner is pnpm global bin.

Do not upgrade ClawHub during recovery.

## 5. Verify the Active OpenClaw Launcher

```powershell
where.exe openclaw
Get-Command openclaw -All

Get-Content -LiteralPath 'D:\openclaw\bin\openclaw.cmd'
Get-Content -LiteralPath 'D:\openclaw\bin\openclaw.ps1'
Get-Content -LiteralPath 'D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1'

openclaw --version
openclaw config validate
```

Expected chain:

```text
D:\openclaw\bin
  -> D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1
  -> C:\Program Files\nodejs\node.exe
  -> D:\openclaw\runtime\openclaw\node_modules\openclaw\openclaw.mjs
```

Expected version: `OpenClaw 2026.6.10 (aa69b12)`.

The source-controlled prototype can be tested without PATH cutover:

```powershell
& 'D:\github\open--claw\bin\openclaw-control.cmd' --version
```

## 6. Verify the ClawX Bundle

```powershell
& 'C:\Program Files\ClawX\resources\cli\openclaw.cmd' --version

$active = 'D:\openclaw\runtime\openclaw\node_modules\openclaw\openclaw.mjs'
$clawx = 'C:\Program Files\ClawX\resources\openclaw\openclaw.mjs'
Get-FileHash -LiteralPath $active, $clawx -Algorithm SHA256
```

Expected version: `OpenClaw 2026.6.10 (aa69b12)`.

Matching hashes prove binary compatibility at the captured date. Do not edit Program Files to repair a mismatch; repair or update ClawX through its installer.

## 7. Verify Lossless Claw

```powershell
openclaw plugins list --verbose
openclaw plugins inspect lossless-claw --runtime --json
```

Required runtime state:

- enabled: true;
- activated: true;
- status: loaded;
- version: `0.13.1`;
- context engine: `lossless-claw`;
- tools: `lcm_grep`, `lcm_describe`, `lcm_expand`, `lcm_expand_query`.

Do not copy or restore the plugin's live database or npm project from this repository.

## 8. Run the Complete Verifier

```powershell
.\scripts\openclaw\verify-openclaw-control-plane.ps1
```

Require npm-global OpenClaw residue absence:

```powershell
.\scripts\openclaw\verify-openclaw-control-plane.ps1 -RequireNpmGlobalOpenClawAbsent
```

The accepted 2026-07-28 baseline is `38 PASS`, `0 WARN`, `0 FAIL`.

## 9. Verify Gateway Ownership

```powershell
openclaw gateway status
openclaw gateway health --json
Get-ScheduledTask -TaskName 'OpenClaw Gateway'
Get-ScheduledTaskInfo -TaskName 'OpenClaw Gateway'
```

Required chain:

```text
OpenClaw Gateway scheduled task
  -> C:\Users\ynotf\.openclaw\gateway.cmd
  -> C:\Program Files\nodejs\node.exe
  -> D:\openclaw\runtime\openclaw\node_modules\openclaw\dist\index.js
  -> gateway --port 18789
```

Confirm listener ownership with the host-proven method:

```powershell
netstat.exe -ano -p tcp | Select-String ':18789'
Get-CimInstance Win32_Process -Filter 'ProcessId=<listener-pid>'
```

`Get-NetTCPConnection` produced false negatives during the accepted migration and is not sufficient by itself on this host.

Verify ClawX does not compete for the gateway:

```powershell
$settings = Get-Content -LiteralPath 'C:\Users\ynotf\AppData\Roaming\clawx\settings.json' -Raw |
    ConvertFrom-Json -Depth 100
$settings.gatewayAutoStart
```

Expected: `False`.

## 10. Gateway Backup, Migration, and Rollback

Durable scripts:

```powershell
.\scripts\openclaw\backup-openclaw-gateway-service.ps1
.\scripts\openclaw\migrate-openclaw-gateway-service.ps1 -BackupPath '<gateway-backup>'
.\scripts\openclaw\disable-clawx-embedded-gateway-autostart.ps1 -BackupPath '<gateway-backup>'
```

All are dry-run by default. Do not execute a migration without a fresh timestamped backup and passing rollback dry run.

Accepted backup:

`C:\Users\ynotf\openclaw-control-plane-backups\gateway-service\20260728-190702`

Gateway/task/config rollback:

```powershell
& 'C:\Users\ynotf\openclaw-control-plane-backups\gateway-service\20260728-190702\restore-openclaw-gateway-service.ps1'
```

ClawX setting rollback:

```powershell
& 'C:\Users\ynotf\openclaw-control-plane-backups\gateway-service\20260728-190702\clawx-app-data\restore-clawx-gateway-settings.ps1'
```

Run either without `-Execute` first. The original gateway rollback restores the historical broken npm-global service reference, so use it only as an emergency state restoration while the npm-global artifact backup is also available.

## 11. npm-global OpenClaw Cleanup Recovery

The stale npm-global artifacts were removed after the dependency gate passed.

Accepted cleanup backup:

`C:\Users\ynotf\openclaw-control-plane-backups\control-plane\20260728-191721`

Dry-run restore:

```powershell
& 'C:\Users\ynotf\openclaw-control-plane-backups\control-plane\20260728-191721\restore-npm-global-openclaw.ps1'
```

Only restore these artifacts if an explicit rollback requires reconstructing the pre-migration state.

## Restore PATH from Backup

Primary PATH-hygiene evidence and rollback snapshot:

`C:\Users\ynotf\openclaw-control-plane-backups\path-hygiene\20260728-021430`

Inspect before restoring:

```powershell
$backup = 'C:\Users\ynotf\openclaw-control-plane-backups\path-hygiene\20260728-021430'
Get-Content -LiteralPath (Join-Path $backup 'before-user-path.txt')
Get-Content -LiteralPath (Join-Path $backup 'final-user-path.txt')
```

Restore only after selecting the intended snapshot:

```powershell
$backup = 'C:\Users\ynotf\openclaw-control-plane-backups\path-hygiene\20260728-021430'
$restoredUserPath = Get-Content -LiteralPath (Join-Path $backup 'final-user-path.txt') -Raw
[Environment]::SetEnvironmentVariable('Path', $restoredUserPath.Trim(), 'User')
```

Close and reopen shells, then repeat PATH and command-resolution verification. Do not change Machine PATH in the same recovery step.

## Recover from npm-global OpenClaw Cleanup

Cleanup is currently blocked and has not been executed because the live gateway service contract still references npm-global OpenClaw.

If a later authorized cleanup has run:

1. Locate the timestamped backup recorded in its cleanup audit.
2. Inspect `manifest.json` and `cleanup-result.json`.
3. Dry-run the generated restore script:

```powershell
& '<backup-path>\restore-npm-global-openclaw.ps1'
```

4. Restore only the exact backed-up npm-global OpenClaw artifacts:

```powershell
& '<backup-path>\restore-npm-global-openclaw.ps1' -Execute
```

5. Verify:

```powershell
where.exe openclaw
Get-Command openclaw -All
openclaw --version
openclaw config validate
```

The restore must not touch unrelated npm-global packages.

## Current Gateway Service Blocker

As of 2026-07-28:

- `C:\Users\ynotf\.openclaw\gateway.cmd` invokes `C:\Users\ynotf\AppData\Roaming\npm\node_modules\openclaw\dist\index.js`;
- that npm-global package directory is empty;
- the `OpenClaw Gateway` scheduled task executes `.openclaw\gateway.cmd`;
- the task was `Ready` with last result `1`;
- the service contract is therefore stale and requires a separate backup-first live-state migration.

Do not delete the npm-global residue and do not edit `gateway.cmd` as an incidental cleanup. A future phase must back up the scheduled task, `gateway.cmd`, relevant config, and command/service status, then repoint the service to the approved OpenClaw runtime and prove restart/rollback.

## Recover if `D:\openclaw\bin` Breaks

1. Do not change PATH first.
2. Test the approved wrapper directly:

```powershell
& 'D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1' --version
```

3. Test the source-controlled prototype:

```powershell
& 'D:\github\open--claw\bin\openclaw-control.cmd' --version
```

4. Test the ClawX fallback:

```powershell
& 'C:\Program Files\ClawX\resources\cli\openclaw.cmd' --version
```

5. Restore `D:\openclaw\bin\openclaw.cmd`, `openclaw.ps1`, and `scripts\Invoke-ClawXOpenClaw.ps1` from the timestamped control-plane backup that recorded their hashes.
6. Re-run command-resolution and configuration checks.

Do not replace the active launcher with npm-global OpenClaw.

## Recover if ClawX UI Fails

1. Verify the OpenClaw CLI remains healthy independently.
2. Verify the ClawX bundled CLI directly.
3. Capture ClawX version and app status.
4. Back up `C:\Users\ynotf\AppData\Roaming\clawx` before any app-data repair.
5. Use the ClawX installer/updater for Program Files repair.
6. Do not copy OpenClaw live runtime state into ClawX app data.
7. Do not make ClawX the CLI authority to work around a UI problem.

## What Not to Delete

- `D:\openclaw`;
- `C:\Users\ynotf\.openclaw`;
- `C:\Users\ynotf\AppData\Roaming\clawx`;
- `C:\Program Files\ClawX`;
- `D:\github\open--claw\vendor\openclaw`;
- `.openclaw\npm\projects`;
- Lossless Claw state;
- pnpm global bin or Corepack shims;
- ClawHub `0.22.0`;
- any backup referenced by an audit;
- npm-global OpenClaw artifacts until the gateway service blocker is resolved.

## Escalation Boundary

Stop and request approval if recovery requires:

- editing `.openclaw`;
- editing ClawX app data;
- repairing Program Files manually;
- changing User or Machine PATH;
- installing/removing packages;
- changing scheduled tasks;
- deleting backup or runtime data;
- changing the active launcher owner.
