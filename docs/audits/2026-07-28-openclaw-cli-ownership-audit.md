# OpenClaw CLI ownership audit

Date: 2026-07-28

Scope: read-only investigation of OpenClaw command ownership after Node PATH hygiene correction. This audit determines whether npm-global OpenClaw appears actively required, what owns the active `openclaw` command, and what a safe future cleanup plan should look like.

No PATH entries, packages, runtime state, ClawX app data, `D:\openclaw`, or `vendor\openclaw` were modified during this audit.

## Current command ownership

Command resolution was checked from a fresh PowerShell with PATH reconstructed from persisted Machine PATH plus persisted User PATH.

| Command | First owner | Additional owners / notes |
| --- | --- | --- |
| `openclaw` | `D:\openclaw\bin\openclaw.cmd` | npm-global shims and ClawX bundle wrappers remain lower in PATH |
| `node` | `C:\Program Files\nodejs\node.exe` | `C:\Users\ynotf\AppData\Local\pnpm\bin\node.EXE` remains second |
| `npm` | `C:\Program Files\nodejs\npm` | system Node.js npm |
| `pnpm` | `C:\Users\ynotf\AppData\Local\Corepack\shims\pnpm` | Corepack shim owner |
| `clawhub` | `C:\Users\ynotf\AppData\Local\pnpm\bin\clawhub` | pnpm-global owner |

PowerShell-specific `Get-Command openclaw -All` resolves `D:\openclaw\bin\openclaw.ps1` before `D:\openclaw\bin\openclaw.cmd`, but both wrappers are owned by the same `D:\openclaw\bin` active owner. `where.exe openclaw` resolves the `.cmd` wrapper first.

## Discovered OpenClaw command paths

| Path | Present | Role |
| --- | --- | --- |
| `D:\openclaw\bin\openclaw.cmd` | yes | active CMD owner; delegates to `D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1` |
| `D:\openclaw\bin\openclaw.ps1` | yes | active PowerShell owner; delegates to `D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1` |
| `C:\Users\ynotf\AppData\Roaming\npm\openclaw` | yes | npm-generated POSIX shim; lower priority |
| `C:\Users\ynotf\AppData\Roaming\npm\openclaw.cmd` | yes | npm-generated CMD shim; lower priority and currently broken |
| `C:\Users\ynotf\AppData\Roaming\npm\openclaw.ps1` | yes | npm-generated PowerShell shim; lower priority and currently broken |
| `C:\Program Files\ClawX\resources\cli\openclaw` | yes | ClawX bundled POSIX wrapper; lower priority |
| `C:\Program Files\ClawX\resources\cli\openclaw.cmd` | yes | ClawX bundled CMD wrapper; lower priority |
| `C:\Program Files\ClawX\resources\cli\openclaw.ps1` | no | missing |

## Version comparison

Each owner was executed directly without relying on PATH:

| Owner | Command | Result |
| --- | --- | --- |
| `D:\openclaw` active wrapper | `D:\openclaw\bin\openclaw.cmd --version` | `OpenClaw 2026.6.10 (aa69b12)`, exit `0` |
| npm-global shim | `C:\Users\ynotf\AppData\Roaming\npm\openclaw.cmd --version` | fails with `MODULE_NOT_FOUND` for `C:\Users\ynotf\AppData\Roaming\npm\node_modules\openclaw\openclaw.mjs`, exit `1` |
| ClawX bundled wrapper | `C:\Program Files\ClawX\resources\cli\openclaw.cmd --version` | `OpenClaw 2026.6.10 (aa69b12)`, exit `0` |

The active `D:\openclaw` runtime package is `openclaw` version `2026.6.10` with `packageManager` `pnpm@11.2.2+sha512...` and `bin` `{ "openclaw": "openclaw.mjs" }`.

The ClawX bundled package is also `openclaw` version `2026.6.10` with the same package manager declaration and bin mapping. The `openclaw.mjs` hash in `D:\openclaw\runtime\openclaw\node_modules\openclaw\openclaw.mjs` matches `C:\Program Files\ClawX\resources\openclaw\openclaw.mjs`.

## npm-global OpenClaw package details

Commands run:

```text
npm root -g
npm prefix -g
npm list -g --depth=0
npm list -g openclaw --depth=2
npm view openclaw version
npm view openclaw dist-tags
npm view openclaw bin
npm view openclaw packageManager
```

Findings:

- npm global root: `C:\Users\ynotf\AppData\Roaming\npm\node_modules`
- npm global prefix: `C:\Users\ynotf\AppData\Roaming\npm`
- `npm list -g --depth=0` reports `openclaw@` with no version.
- `npm list -g openclaw --depth=2` reports `openclaw@` with no version.
- `C:\Users\ynotf\AppData\Roaming\npm\node_modules\openclaw` exists but is an empty directory.
- `C:\Users\ynotf\AppData\Roaming\npm\node_modules\openclaw\package.json` is missing.
- `C:\Users\ynotf\AppData\Roaming\npm\node_modules\openclaw\openclaw.mjs` is missing.
- Direct npm-global shim execution fails because the expected `openclaw.mjs` entrypoint is missing.

Registry metadata:

```text
npm view openclaw version
2026.7.1-2

npm view openclaw dist-tags
alpha: 2026.5.19-alpha.1
latest: 2026.7.1-2
extended-stable: 2026.6.33
beta: 2026.7.2-beta.5

npm view openclaw bin
{ openclaw: 'openclaw.mjs' }

npm view openclaw packageManager
pnpm@11.2.2+sha512...
```

Conclusion: npm-global OpenClaw is not a working fallback in its current state. It is an orphaned/broken npm shim plus an empty global package directory, below the active `D:\openclaw` owner in PATH.

## pnpm-global OpenClaw presence

Commands run from persisted PATH:

```text
pnpm root -g
pnpm bin -g
pnpm list -g --depth=0 | Select-String -Pattern 'openclaw'
```

Findings:

- pnpm global root: `C:\Users\ynotf\AppData\Local\pnpm\global\v11`
- pnpm global bin: `C:\Users\ynotf\AppData\Local\pnpm\bin`
- `pnpm list -g --depth=0 | Select-String -Pattern 'openclaw'` returned no match.

Conclusion: OpenClaw is not currently installed as a pnpm-global package. ClawHub and selected migrated MCP tools are pnpm-global owned, but OpenClaw is not.

## `D:\openclaw` launcher relationship

`D:\openclaw\bin\openclaw.cmd` delegates to:

```text
D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1
```

`D:\openclaw\bin\openclaw.ps1` also delegates to the same wrapper.

`D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1`:

- uses `C:\Program Files\nodejs\node.exe`;
- requires Node `>=22.19.0`;
- sets `OPENCLAW_EMBEDDED_IN=ClawX`;
- executes `D:\openclaw\runtime\openclaw\node_modules\openclaw\openclaw.mjs`;
- does not invoke `C:\Users\ynotf\AppData\Roaming\npm\openclaw`;
- does not invoke `C:\Program Files\ClawX\resources\cli\openclaw.cmd`;
- does not invoke `ClawX.exe`;
- does not modify PATH;
- pins behavior to the local `D:\openclaw\runtime` OpenClaw package, currently version `2026.6.10`.

The script contains a historical comment saying it was repointed to the writable `D:\openclaw\runtime` install because an earlier bundle was `2026.6.5` and write-denied. Current live evidence shows both the active `D:\openclaw` runtime and the ClawX bundle are now `2026.6.10`.

## ClawX bundle relationship

`C:\Program Files\ClawX\resources\openclaw\package.json` reports:

```text
name: openclaw
version: 2026.6.10
packageManager: pnpm@11.2.2+sha512...
bin: { "openclaw": "openclaw.mjs" }
```

`C:\Program Files\ClawX\resources\cli\openclaw.cmd`:

- sets `OPENCLAW_EMBEDDED_IN=ClawX`;
- prefers bundled `C:\Program Files\ClawX\resources\bin\node.exe` when it satisfies Node `>=22.19.0`;
- otherwise falls back to `ELECTRON_RUN_AS_NODE=1` and `ClawX.exe`;
- runs `C:\Program Files\ClawX\resources\openclaw\openclaw.mjs`;
- prints that OpenClaw is managed by ClawX for `openclaw update`.

Current active CLI flow does not directly execute the ClawX CLI wrapper or `ClawX.exe`. It executes the `D:\openclaw` runtime copy with system Node while preserving the `OPENCLAW_EMBEDDED_IN=ClawX` environment marker. ClawX remains the desktop/runtime authority in the documented machine model, but it is not the first PATH owner for the CLI.

## Runtime reference findings

Searches were path-reference-only. No live `.openclaw` file contents were printed.

Search roots:

- `D:\github\open--claw`
- `D:\openclaw`
- `C:\Users\ynotf\.openclaw`

Terms:

- `C:\Users\ynotf\AppData\Roaming\npm\openclaw`
- `AppData\Roaming\npm\openclaw`
- `D:\openclaw\bin`
- `C:\Program Files\ClawX\resources\cli`
- `openclaw.cmd`
- `openclaw.ps1`

Findings by category:

| Root | Finding |
| --- | --- |
| `D:\github\open--claw` | npm-global OpenClaw references appear in docs state material; `D:\openclaw\bin` and ClawX CLI references appear in audit/migration docs; `openclaw.cmd` appears in docs and agent runner references. |
| `D:\openclaw` | npm-global OpenClaw references appear in historical generated reports and an old uninstall-preserve plan; `D:\openclaw\bin` appears in README/handoff/runtime docs; ClawX CLI references appear in historical reports/docs; `openclaw.cmd` appears widely in agent runner references and docs. |
| `C:\Users\ynotf\.openclaw` | no matches for the requested terms with secret-safe path-only search. |

No live runtime path reference was found that proves npm-global OpenClaw is actively required.

## Health checks

Health commands were run without `doctor --fix`.

```text
openclaw --version
OpenClaw 2026.6.10 (aa69b12)
EXIT_CODE::0

openclaw config validate
Config valid: ~\.openclaw\openclaw.json
1 warning(s):
  ! plugins.entries.hirey: plugin disabled (disabled in config) but config is present
EXIT_CODE::0

openclaw plugins list --verbose
Plugins (57/82 enabled)
Doctor warning: migrated plugin install index archive already exists
Config warning: plugins.entries.hirey disabled but config present
Lossless Context Management (lossless-claw) enabled, origin global, version 0.13.1
EXIT_CODE::0

openclaw plugins inspect lossless-claw --runtime --json
lossless-claw enabled: true
activated: true
status: loaded
origin: global
version: 0.13.1
contextEngineIds: lossless-claw
toolNames: lcm_grep, lcm_describe, lcm_expand, lcm_expand_query
install source: npm
EXIT_CODE::0
```

## Is npm-global OpenClaw actively required?

Evidence does not show npm-global OpenClaw is actively required.

Reasons:

- active `openclaw` resolves to `D:\openclaw\bin`;
- active wrappers execute `D:\openclaw\runtime\openclaw\node_modules\openclaw\openclaw.mjs`;
- active wrappers do not reference npm-global OpenClaw;
- live `.openclaw` path-reference search found no requested npm-global OpenClaw references;
- npm-global shim execution fails because the npm package entrypoint is missing;
- npm-global package directory is empty;
- pnpm-global does not contain OpenClaw.

However, removal should not happen in this pass. The npm-global shim is broken, but there are historical docs/reports and agent tooling references that should be reviewed before destructive cleanup. A rollback model should be prepared first.

## Risk classification

Current risk: medium.

The active CLI is healthy, but a lower-priority broken npm-global OpenClaw shim remains in PATH. If `D:\openclaw\bin` were removed, reordered, or unavailable, `openclaw` could fall through to the broken npm-global shim before the working ClawX bundle wrapper.

Cleanup risk: medium-low if performed with backup and explicit restore plan.

The npm-global OpenClaw package payload is already missing, so the material value of the current npm-global installation is low. The risk is mainly command-resolution rollback, stale references, and accidental removal of unrelated npm-global tools.

## Recommendation

A. Keep npm-global OpenClaw for now.

Recommended future action: B. Remove npm-global OpenClaw later, but only after a dedicated cleanup phase with backups and approval.

Do not choose C, replacing active ownership, based on current evidence. Active ownership via `D:\openclaw\bin` is working and should remain pinned.

Do not choose D as the primary state. More evidence is useful for cleanup safety, but enough evidence exists to classify npm-global OpenClaw as not actively required by the current CLI flow.

## Future cleanup plan

Do not execute in this audit.

Proposed safe future phase:

1. Capture before-state:
   - User PATH and Machine PATH.
   - `where.exe openclaw`.
   - `Get-Command openclaw -All`.
   - full listing of `C:\Users\ynotf\AppData\Roaming\npm\openclaw*`.
   - full listing of `C:\Users\ynotf\AppData\Roaming\npm\node_modules\openclaw`.
   - `npm list -g --depth=0`.
2. Back up only the npm-global OpenClaw shims and empty package directory:
   - `C:\Users\ynotf\AppData\Roaming\npm\openclaw`
   - `C:\Users\ynotf\AppData\Roaming\npm\openclaw.cmd`
   - `C:\Users\ynotf\AppData\Roaming\npm\openclaw.ps1`
   - `C:\Users\ynotf\AppData\Roaming\npm\node_modules\openclaw`
3. Remove only those npm-global OpenClaw artifacts after explicit approval.
4. Verify:
   - `where.exe openclaw` resolves first to `D:\openclaw\bin\openclaw.cmd`.
   - npm-global OpenClaw no longer appears.
   - ClawX bundle remains lower-priority fallback.
   - `openclaw --version`, `openclaw config validate`, and Lossless Claw inspection still pass.
5. Do not run `openclaw doctor --fix`.

## Rollback model if npm-global OpenClaw is later removed

Rollback should restore only the backed-up npm-global OpenClaw artifacts to their original locations:

- `C:\Users\ynotf\AppData\Roaming\npm\openclaw`
- `C:\Users\ynotf\AppData\Roaming\npm\openclaw.cmd`
- `C:\Users\ynotf\AppData\Roaming\npm\openclaw.ps1`
- `C:\Users\ynotf\AppData\Roaming\npm\node_modules\openclaw`

Rollback should not modify `D:\openclaw`, ClawX, live runtime state, pnpm global packages, or PATH unless a later cleanup phase explicitly changes PATH.

After rollback, re-run:

```text
where.exe openclaw
Get-Command openclaw -All
D:\openclaw\bin\openclaw.cmd --version
C:\Users\ynotf\AppData\Roaming\npm\openclaw.cmd --version
C:\Program Files\ClawX\resources\cli\openclaw.cmd --version
```

## Unresolved approval questions

1. Should a later cleanup phase remove the broken npm-global OpenClaw shims and empty package directory after backing them up?
2. Should the control-plane docs record `D:\openclaw\runtime` as the active CLI runtime implementation even though ClawX remains the desktop/runtime authority?
3. Should old `D:\openclaw` reports and generated bootstrap material that reference npm-global OpenClaw be migrated, archived, or left as historical evidence?
4. Should a future ClawX alignment pass compare `D:\openclaw\runtime` against the current ClawX bundle and decide whether the writable runtime copy is still needed?
