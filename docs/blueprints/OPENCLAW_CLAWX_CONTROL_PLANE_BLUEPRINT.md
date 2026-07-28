# OpenClaw / ClawX Control-Plane Blueprint

Status: durable control-plane baseline implemented; gateway ownership stabilized; npm-global cleanup complete; active launcher cutover staged
Baseline date: 2026-07-28
Machine: CHAOSCENTRAL
Control-plane repository: `D:\github\open--claw`

This blueprint governs machine-level OpenClaw and ClawX operations. It is subordinate to the repository's supreme product charter, `open-claw/AI_Employee_knowledgebase/FINAL_OUTPUT_PRODUCT.md`; it does not amend product law or the curated employee standard.

## Architecture Outcome

OpenClaw is the runtime and command-control authority. ClawX is an optional desktop UI and installer-managed fallback. The two applications may share compatible OpenClaw binaries, but ClawX does not own live OpenClaw configuration, plugins, agents, or control-plane history.

Two authority transitions are intentionally staged:

1. `D:\openclaw` remains the current operational authority and migration source.
2. `D:\github\open--claw` is the durable, source-controlled control-plane authority for sanitized documentation, scripts, runbooks, audits, and launcher source.
3. Active machine command ownership remains `D:\openclaw\bin` until a separate launcher-cutover acceptance phase.

The repository becomes the durable source for how the system is operated and recovered. It does not become the live runtime-state store.

## Authority Model

| Surface | Current role | Target role | Write policy |
| --- | --- | --- | --- |
| `D:\github\open--claw` | Durable governance repo | Source-controlled control-plane authority | Writable for reviewed, sanitized control-plane artifacts |
| `D:\openclaw` | Current operational authority and migration source | Approved runtime/launcher target until staged cutover; later legacy or managed operational root | Preserve intact until migration acceptance |
| `C:\Users\ynotf\.openclaw` | Live OpenClaw runtime state | Live runtime state only | Backup-first, narrowly scoped writes only |
| `C:\Users\ynotf\AppData\Roaming\clawx` | Live ClawX desktop app data | ClawX app data only | Backup-first, narrowly scoped writes only |
| `C:\Program Files\ClawX` | Installed ClawX bundle | Installer-managed UI/fallback bundle | Read-only; update through the installer |
| `D:\github\open--claw\vendor\openclaw` | Upstream checkout/vendor reference | Read-only source and policy reference | No edits without explicit fork/patch decision |

### Authority precedence

1. Product behavior and employee standards: repository product charter and subordinate standards.
2. Durable machine control-plane policy: this blueprint and current runbooks under `docs`.
3. Current operational execution: approved launchers and runtime under `D:\openclaw`.
4. Live mutable state: `.openclaw`.
5. Optional desktop UI and fallback: ClawX.
6. Historical audits: evidence of what was true at the audit date, not current policy.

## Runtime-State Model

`C:\Users\ynotf\.openclaw` is production state. It may contain configuration, credentials, device identity, sessions, databases, logs, plugin projects, agent workspaces, and generated material. It is not a normal Git working tree even if Git metadata exists inside it.

Rules:

- Never bulk-copy the directory into the control-plane repository.
- Never commit raw `openclaw.json`, credentials, tokens, identities, databases, logs, session state, browser state, plugin islands, or caches.
- Back up the exact target before any authorized write.
- Validate configuration after a change with `openclaw config validate`.
- Do not run `openclaw doctor --fix` without first reviewing its proposed repair scope.
- Treat `C:\Users\ynotf\.openclaw\npm\projects` as OpenClaw-managed plugin islands. Do not manually move or normalize them.

## OpenClaw Role

OpenClaw owns:

- runtime and gateway behavior;
- the active CLI contract;
- live configuration and plugin state under `.openclaw`;
- agent/workspace execution;
- plugin lifecycle and plugin-owned package islands;
- runtime verification and recovery commands.

Current approved CLI chain:

```text
PATH
  -> D:\openclaw\bin\openclaw.cmd / openclaw.ps1
  -> D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1
  -> C:\Program Files\nodejs\node.exe
  -> D:\openclaw\runtime\openclaw\node_modules\openclaw\openclaw.mjs
```

Baseline output: `OpenClaw 2026.6.10 (aa69b12)`.

The active runtime entrypoint hash matched the ClawX bundled OpenClaw entrypoint at the 2026-07-28 audit. Hash equality is useful compatibility evidence; it does not transfer authority to ClawX.

## ClawX Role

ClawX is:

- an optional desktop UI;
- an installer-managed OpenClaw bundle;
- a fallback CLI path after the active operational launcher;
- a recovery option when `D:\openclaw\bin` is unavailable.
- configured with `gatewayAutoStart=false` so it does not compete with the authoritative Windows gateway task.

ClawX is not:

- the source-controlled control-plane authority;
- the owner of `.openclaw` state;
- the package manager for machine-global developer tools;
- a directory to patch manually.

The installed fallback is `C:\Program Files\ClawX\resources\cli\openclaw.cmd`. It must remain below the approved operational launcher on PATH. Its package pin and bundled dependencies remain vendor-managed.

## `D:\openclaw` Migration Role

`D:\openclaw` remains intact until all staged acceptance gates pass. It is the authoritative migration source for current operational knowledge, custom scripts, agent material, and runtime-launcher behavior.

Only sanitized, recoverable control-plane material may be migrated:

- documentation and runbooks;
- reviewed PowerShell scripts;
- sanitized audits and manifests;
- launcher source that delegates to an approved runtime;
- policy and acceptance checklists.

Do not migrate:

- secrets or `.env` files;
- raw runtime databases or logs;
- credentials, tokens, session state, identity, or device state;
- `node_modules`, generated caches, reports, screenshots, or backups;
- live plugin islands;
- raw copies of `.openclaw`;
- material whose provenance or authority is unresolved.

`D:\openclaw` may be retired only after launcher cutover, runtime recovery, plugin health, and rollback have been proven and the user explicitly approves retirement.

## Target Repository Role

`D:\github\open--claw` owns:

- this blueprint;
- recovery and package-manager runbooks;
- audit and verification scripts;
- cleanup scripts with dry-run defaults and explicit execution gates;
- the source-controlled launcher prototype;
- sanitized audit history;
- future migration acceptance records.

It does not own live runtime databases/config, ClawX app state, installed app files, package-manager stores, global shims, or vendored source modifications.

## Package-Manager Policy

| Capability | Owner |
| --- | --- |
| `node`, `npm`, `npx`, `corepack` | `C:\Program Files\nodejs` |
| `pnpm`, `pnpx` | Corepack shims under `C:\Users\ynotf\AppData\Local\Corepack\shims` |
| pnpm-global command shims | `C:\Users\ynotf\AppData\Local\pnpm\bin` |
| npm-global commands intentionally retained | `C:\Users\ynotf\AppData\Roaming\npm` |

Policy:

- Use Corepack to provision pnpm.
- Follow each workspace's `packageManager` field.
- Do not mix npm and pnpm in one repository workflow.
- Do not rewrite vendored or bundled package pins to the machine-global pnpm version.
- `vendor\openclaw` keeps its declared pnpm pin.
- ClawX and `D:\openclaw\runtime` keep their bundled OpenClaw package pin.
- OpenClaw plugin islands keep the package-manager state OpenClaw created for them.

See `docs/runbooks/PACKAGE_MANAGER_POLICY.md`.

## CLI Ownership Policy

Current machine order:

1. `D:\openclaw\bin`
2. `C:\Program Files\nodejs`
3. `C:\Users\ynotf\AppData\Local\Corepack\shims`
4. `C:\Users\ynotf\AppData\Local\pnpm\bin`
5. `C:\Users\ynotf\AppData\Roaming\npm`
6. `C:\Program Files\ClawX\resources\cli`

Rules:

- System Node must remain the first `node` owner.
- Corepack shims must remain the first `pnpm`/`pnpx` owner.
- pnpm-global must remain ahead of npm-global so migrated MCP and ClawHub shims stay authoritative.
- `D:\openclaw\bin` remains the first `openclaw` owner until explicit cutover acceptance.
- Broken lower-priority shims must never be removed until backup, dependency proof, and fallthrough verification pass.

The non-invasive prototype is:

- `scripts/openclaw/Invoke-ControlPlaneOpenClaw.ps1`
- `bin/openclaw-control.cmd`
- `bin/openclaw-control.ps1`

The prototype validates the approved Node, wrapper, runtime entrypoint, and package metadata, then delegates to the current operational wrapper. It is not added to PATH in this phase.

## Plugin and Skill Policy

- OpenClaw owns active plugin lifecycle.
- Use OpenClaw commands to inspect, install, update, disable, or remove plugins.
- Never manually move directories under `.openclaw\npm\projects`.
- Keep plugin provenance and version evidence in sanitized audits.
- Do not commit plugin caches, extracted npm projects, runtime lockfiles, or plugin data.
- Review community skills before installation.
- Use the pnpm-owned `clawhub` command directly; do not route it through `npx`.
- Do not bulk-copy agents or skills from `D:\openclaw` until provenance, freshness, and target role are approved.

## ClawHub Policy

- Machine owner: pnpm global.
- Baseline version: `0.22.0`.
- Preserve `0.22.0` until a separate compatibility phase proves an upgrade.
- Operate through `clawhub`, not `npx clawhub`.
- Keep the pnpm global bin on PATH.
- An upgrade must record before/after versions, ownership, search health, rollback, and OpenClaw compatibility.

## Lossless Claw Policy

Baseline:

- plugin: `lossless-claw`;
- version: `0.13.1`;
- enabled: true;
- activated: true;
- status: loaded;
- context engine: `lossless-claw`;
- required tools: `lcm_grep`, `lcm_describe`, `lcm_expand`, `lcm_expand_query`.

Rules:

- Verify both plugin registration and runtime activation.
- Do not copy or commit the plugin's live database or npm project.
- Keep context-engine selection explicit.
- Use Lossless Claw for workflow continuity and retrieval, not as a substitute for source-controlled decisions or runbooks.
- Back up live state before any plugin upgrade or context-engine change.

## CrewClaw Policy

CrewClaw is discovery-only until a current local install/configuration contract is verified.

Existing repository material proves that purchased CrewClaw packets and legacy worker references exist. It does not prove a supported current installer, CLI, configuration schema, or live runtime integration. Purchased packet shells contain outdated OpenClaw installation assumptions and are not accepted as production deployment authority.

No CrewClaw command, package install, worker start, or agent bulk-copy is authorized by this blueprint. See `docs/workflows/CREWCLAW_DISCOVERY_AND_INTEGRATION_PLAN.md`.

## Broken npm-global OpenClaw Policy

The npm-global OpenClaw entry was stale and broken. Its dependency gate was resolved on 2026-07-28.

At the 2026-07-28 gate:

- the three npm-global shims existed;
- the npm-global OpenClaw package directory existed but was empty;
- the shims failed because `openclaw.mjs` was missing;
- `C:\Users\ynotf\.openclaw\gateway.cmd` still referenced the npm-global package's missing `dist\index.js`;
- the registered `OpenClaw Gateway` scheduled task executed that live-state launcher and had last result `1`.

The gateway service was reinstalled through the approved `D:\openclaw` runtime, ClawX embedded gateway auto-start was disabled, lifecycle and health passed, and the safe-scope dependency scan returned no npm-global reference. The four stale npm-global artifacts were then removed from the exact timestamped backup set.

Current gateway chain:

```text
OpenClaw Gateway scheduled task
  -> C:\Users\ynotf\.openclaw\gateway.cmd
  -> C:\Program Files\nodejs\node.exe
  -> D:\openclaw\runtime\openclaw\node_modules\openclaw\dist\index.js
  -> gateway --port 18789
```

The interactive CLI continues to use `openclaw.mjs`; the Windows service uses `dist\index.js`. Both belong to the approved `D:\openclaw` runtime package.

See `docs/audits/2026-07-28-openclaw-gateway-ownership-migration.md`.

## Rollback Model

Every persistent machine change must have:

1. exact current-state capture;
2. timestamped backup outside the repository;
3. a dry-run or preflight;
4. narrowly resolved targets;
5. post-change command-resolution and health verification;
6. an executable or documented rollback;
7. a sanitized audit record.

Default backup root: `C:\Users\ynotf\openclaw-control-plane-backups`.

The backup script intentionally excludes live runtime state, ClawX app data, installed application payloads, and vendor source. Those surfaces require separate, explicitly scoped backups when a future phase authorizes changes.

## What Must Never Be Committed

- credentials, tokens, API keys, OAuth data, cookies, session state, or identity material;
- `.openclaw` databases, WAL/SHM files, logs, state, or raw configuration;
- ClawX browser/app state, caches, or provider configuration;
- `node_modules`, pnpm/npm stores, global shims, generated caches, or package-manager homes;
- raw plugin islands or plugin databases;
- raw reports, screenshots, QR codes, crash dumps, or backup archives;
- machine-specific secret-bearing environment files;
- `C:\Program Files\ClawX` application files;
- local changes inside `vendor\openclaw`;
- unreviewed bulk agent exports.

Sanitized evidence may include paths, versions, hashes, exit codes, ownership, and category-only secret-risk descriptions.

## Six-Month Recovery Model

A future operator should be able to recover from only this repository plus external backups:

1. Read this blueprint.
2. Run `scripts/openclaw/audit-openclaw-control-plane.ps1`.
3. Run `scripts/openclaw/verify-openclaw-control-plane.ps1`.
4. Follow `docs/runbooks/OPENCLAW_CLAWX_RECOVERY.md`.
5. Confirm PATH ownership before changing packages.
6. Confirm `D:\openclaw` and the approved runtime entrypoint exist.
7. Use `bin/openclaw-control.cmd --version` as a non-invasive prototype check.
8. Use the ClawX CLI only as a fallback.
9. Restore PATH or exact command artifacts from the timestamped backup referenced by the relevant audit.
10. Never restore raw live state from Git.

Recovery is successful only when command ownership, configuration validation, ClawHub, Lossless Claw, and the active launcher all pass fresh verification.

## Migration Acceptance Gates

The active launcher may move from `D:\openclaw\bin` to a target-owned pattern only when:

- the target launcher prototype passes on a fresh shell;
- the approved runtime path is documented and backed up;
- a PATH rollback is prepared;
- `openclaw --version` and `openclaw config validate` pass before and after;
- Lossless Claw remains loaded and activated;
- ClawHub ownership is unchanged;
- ClawX fallback remains available;
- gateway service ownership no longer depends on broken npm-global artifacts;
- the user approves cutover.

Until then, the architecture is intentionally split: repository-owned control-plane source with `D:\openclaw` operational execution.
