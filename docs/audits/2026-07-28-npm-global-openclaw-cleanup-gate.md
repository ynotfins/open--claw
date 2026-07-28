# npm-global OpenClaw Cleanup Gate

Date: 2026-07-28
Decision: retained; cleanup not executed
Scope: read-only go/no-go proof for the broken npm-global OpenClaw artifacts

Resolution note: this historical gate was satisfied later on 2026-07-28. The gateway service moved to the approved `D:\openclaw` runtime, lifecycle and listener ownership passed, and the four stale npm-global artifacts were removed from a fresh exact backup. See `docs/audits/2026-07-28-openclaw-gateway-ownership-migration.md`.

Timestamped control-plane backup created:

`C:\Users\ynotf\openclaw-control-plane-backups\control-plane\20260728-031416`

The backup manifest, exact npm-global artifacts, active launcher copies, ClawX fallback copy, command-resolution evidence, health evidence, and dry-run restore script were verified present. The generated restore script completed its dry run with exit `0`.

## Proposed Exact Cleanup Targets

- `C:\Users\ynotf\AppData\Roaming\npm\openclaw`
- `C:\Users\ynotf\AppData\Roaming\npm\openclaw.cmd`
- `C:\Users\ynotf\AppData\Roaming\npm\openclaw.ps1`
- `C:\Users\ynotf\AppData\Roaming\npm\node_modules\openclaw`

No other npm-global package was in scope.

## Evidence That Passed

| Gate | Result | Evidence |
| --- | --- | --- |
| Active CLI owner | PASS | `where.exe openclaw` resolved first to `D:\openclaw\bin\openclaw.cmd` |
| PowerShell CLI owner | PASS | `Get-Command openclaw -All` resolved first to `D:\openclaw\bin\openclaw.ps1` |
| Active version | PASS | `OpenClaw 2026.6.10 (aa69b12)` |
| Active runtime | PASS | `D:\openclaw\runtime\openclaw\node_modules\openclaw\openclaw.mjs` |
| Active Node owner | PASS | `C:\Program Files\nodejs\node.exe` |
| ClawX fallback | PASS | bundled CLI returned `OpenClaw 2026.6.10 (aa69b12)` |
| npm-global package payload | BROKEN | npm listed `openclaw@` without a version; package directory was empty |
| npm-global shim probe | BROKEN | shim failed because `openclaw.mjs` was missing |
| pnpm-global OpenClaw | ABSENT | pnpm global did not list OpenClaw |
| Active wrapper dependency | PASS | `D:\openclaw\bin` and its wrapper did not delegate to npm-global OpenClaw |
| ClawX dependency | PASS | ClawX CLI did not delegate to npm-global OpenClaw |

## Blocking Evidence

The live runtime-state file:

`C:\Users\ynotf\.openclaw\gateway.cmd`

still invokes:

`C:\Users\ynotf\AppData\Roaming\npm\node_modules\openclaw\dist\index.js`

The `OpenClaw Gateway` scheduled task:

- exists;
- executes `C:\Users\ynotf\.openclaw\gateway.cmd`;
- was in `Ready` state at inspection time;
- had last task result `1`;
- did not point at `D:\openclaw` or the ClawX CLI.

`openclaw gateway status` also identified the scheduled task and the same npm-global service command. The command returned exit `0` while describing the registered runtime as stopped. This mixed status is not sufficient proof that the live-state gateway contract is retired.

Therefore the required statement "npm-global OpenClaw is not required by `.openclaw`" cannot be proven. The cleanup script correctly halted during its safe-scope dependency scan.

## Cleanup Decision

Do not remove the four npm-global OpenClaw artifacts in this phase.

Although the package is already broken and empty, deleting the residue before migrating or explicitly retiring the gateway service contract would leave a live-state recovery path unresolved and violate the cleanup acceptance gate.

No PATH, package, scheduled task, `.openclaw` file, ClawX file, `D:\openclaw` file, or vendor source was changed.

## Exact Evidence Required Before Cleanup

1. Export the `OpenClaw Gateway` scheduled task definition to a timestamped external backup.
2. Back up `C:\Users\ynotf\.openclaw\gateway.cmd`.
3. Capture gateway status, task status, listener ownership, and active CLI ownership.
4. Define the approved replacement service command using the current OpenClaw runtime authority.
5. Obtain approval for the live-state and scheduled-task change.
6. Repoint the service in a narrowly scoped, rollback-ready phase.
7. Start/restart the service and prove task, listener, connectivity, CLI, config, and plugin health.
8. Prove no remaining safe-scope `.openclaw` file references the npm-global prefix.
9. Run `backup-openclaw-control-plane-state.ps1 -Execute`.
10. Run `cleanup-broken-npm-global-openclaw.ps1` in dry-run mode.
11. Only after every gate passes, run cleanup with `-Execute -BackupPath <path>`.
12. Verify fallthrough from `D:\openclaw\bin` to the ClawX CLI and run the full control-plane verifier with `-RequireNpmGlobalOpenClawAbsent`.

## Rollback Model

The backup script creates:

- exact npm-global OpenClaw artifact copies;
- command-resolution evidence;
- PATH snapshots;
- package-manager health evidence;
- active launcher copies and hashes;
- the ClawX fallback launcher copy and hash;
- `manifest.json`;
- `restore-npm-global-openclaw.ps1`.

The restore script is dry-run by default and requires `-Execute`.

## Remaining Risk

The active interactive OpenClaw CLI is healthy, but the registered gateway service contract references a missing npm-global package payload. Gateway service repair is the next high-leverage stabilization phase because it is the only discovered dependency blocking safe cleanup of the stale npm-global OpenClaw artifacts.
