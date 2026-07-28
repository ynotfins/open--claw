# OpenClaw Control-Plane Migration Map

> Execution note (2026-07-28): durable blueprint, recovery, package-manager, CrewClaw discovery, verification, backup, cleanup-gate, and launcher-prototype artifacts now live in the target repo. Active execution remains `D:\openclaw`; npm-global OpenClaw cleanup is retained because `.openclaw\gateway.cmd` and the registered gateway task still reference the missing npm-global runtime. See `docs/blueprints/OPENCLAW_CLAWX_CONTROL_PLANE_BLUEPRINT.md` and `docs/audits/2026-07-28-npm-global-openclaw-cleanup-gate.md`.

Report date: 2026-07-27
Current verification refresh: 2026-07-28
Scope: migration map plus package-manager migration record. This file does not authorize copying, deleting, runtime writes, OpenClaw CLI ownership changes, commits, or pushes.

## Locked Authority Model

- Current operational authority and authoritative migration source: `D:\openclaw`.
- Future durable OpenClaw/ClawX control-plane target: `D:\github\open--claw`, after staged migration and acceptance.
- Live OpenClaw runtime state: `C:\Users\ynotf\.openclaw`; not a source repo.
- Live ClawX app data: `C:\Users\ynotf\AppData\Roaming\clawx`; not a source repo.
- Installer-managed ClawX app bundle: `C:\Program Files\ClawX`; read-only.
- Upstream OpenClaw source reference: `D:\github\open--claw\vendor\openclaw`; read-only unless fork/patch work is explicitly approved.
- CrewClaw: discovery-only until its real local install/config contract is verified.

## Migration Principle

Move only sanitized control-plane knowledge from `D:\openclaw` into `D:\github\open--claw`.

Do not bulk-copy runtime state. Do not treat historical reports, backups, or generated workspaces as source-of-truth files. Convert them into concise, redacted, current-control-plane docs when they remain useful.

## Proposed Migration Map

| Source in `D:\openclaw` | Proposed target in `D:\github\open--claw` | Action | Notes |
| --- | --- | --- | --- |
| `README.md`, `AGENTS.md`, `OPENCLAW_PROJECT_HANDOFF.md`, `.openclawrules` | `docs/operations/`, root governance docs, or `docs/handoffs/` | Rewrite/sanitize | Preserve current authority model and operational contract; remove stale runtime claims and sensitive paths where not needed. |
| `docs/*.md` | `docs/operations/` or `docs/audits/` | Review then migrate sanitized docs | Include `plugin-clawhub-audit.md`, runtime audit, remediation report, memory-stack audit if still relevant. |
| `scripts\Invoke-ClawXOpenClaw.ps1` | `scripts/launchers/` or `docs/runbooks/` | Document first; copy later only after approval | It currently defines active CLI ownership. Do not alter active CLI ownership in this pass. |
| `scripts\node-toolchain-diagnostic-cleanup.ps1` | `scripts/diagnostics/` | Mine read-only diagnostics first | Do not migrate delete/cleanup paths without separate review. |
| Other `scripts\*.ps1` and shell scripts | `scripts/` and `docs/runbooks/` | Triage individually | Exclude token-printing, remote secret, uninstall, destructive, and legacy-only scripts. |
| `agents\*` | `docs/agents/manifests/` first | Generate sanitized manifest/semantic comparison | Do not bulk-copy agents yet. Newer/custom authority lives here, but acceptance requires explicit user approval. |
| `Polished-Agents\*` | `docs/agents/polished-manifest/` first | Generate sanitized manifest/semantic comparison | Preserve provenance and role mapping before copying any agent packets. |
| `docs\plugin-clawhub-audit.md` and package-manager notes | `docs/package-management/` | Rewrite into current normalization runbook | Must include npm-to-pnpm migration gates for ClawHub and other npm-installed plugin/MCP tools. |
| `reports\*.md` | `docs/audits/derived/` | Summarize only | Do not copy raw reports. Produce redacted conclusions with current verification date. |
| `backups\...` | No direct target | Do not migrate raw backups | Extract only sanitized lessons if needed. |
| `runtime\...`, `.openclaw-prefix\...`, `bin\...` | No direct target until CLI phase | Document only | Runtime and CLI ownership changes need a separate backup/rollback plan. |
| `favorites`, `external`, `generated`, `S_25_Ultra` | No direct target by default | Discovery-only | Migrate only if a later approval identifies durable control-plane value. |

## Sanitized Migration Categories

- Authority and governance docs.
- Human-readable runbooks.
- Read-only diagnostics.
- Sanitized audit summaries.
- Agent inventory manifests and semantic comparisons.
- Control-plane launcher documentation.
- Package-manager normalization runbooks.
- Recovery and rollback procedures that do not contain credentials, token material, raw logs, raw DBs, or session state.

## Never-Migrate List

- Secrets, credentials, tokens, API keys, auth profiles, cookies, OAuth material, ClawHub login state, or inline command secrets.
- `.env`, local env files, token scripts, token output files, QR codes, screenshots containing account/session state, and key material.
- Raw runtime databases, SQLite files, WAL/SHM files, browser/app storage, local storage, session storage, identity files, device identity files, lock files, and active app state.
- Raw logs, transcripts, crash dumps, PID files, watchdog logs, generated reports, and unredacted audit output.
- `node_modules`, npm/pnpm stores, `.openclaw-prefix`, OpenClaw-managed plugin runtime islands, generated caches, package-manager caches, and binary installers.
- `.git`, `.serena`, `.cursor`, `.context-fabric`, `.playwright-mcp`, IDE caches, and local indexing state.
- Raw backups and preserved machine snapshots.
- Vendored upstream OpenClaw source from `D:\github\open--claw\vendor\openclaw`.
- ClawX app data from `C:\Users\ynotf\AppData\Roaming\clawx`.
- Live OpenClaw runtime state from `C:\Users\ynotf\.openclaw`.

## Package-Manager Migration Record

Executed on 2026-07-28 after backup `C:\Users\ynotf\openclaw-control-plane-backups\20260728-001233`.

- `C:\Users\ynotf\AppData\Local\pnpm\bin` was added to User PATH after `C:\Users\ynotf\AppData\Local\Corepack\shims` and before the npm global prefix.
- `D:\openclaw\bin` remains ahead of pnpm in User PATH, so active `openclaw` CLI ownership remains unchanged.
- `pnpm root -g` resolves to `C:\Users\ynotf\AppData\Local\pnpm\global\v11`.
- `pnpm bin -g` resolves to `C:\Users\ynotf\AppData\Local\pnpm\bin`.
- Preserved-version pnpm global installs completed for `clawhub@0.22.0`, `@brave/brave-search-mcp-server@2.0.85`, `@debugmcp/mcp-debugger@0.21.0`, `@modelcontextprotocol/server-filesystem@2026.1.14`, `@modelcontextprotocol/server-sequential-thinking@2025.12.18`, `@playwright/mcp@0.0.76`, `@zavora-ai/computer-use-mcp@6.2.0`, `agent-browser@0.23.0`, `chrome-devtools-mcp@0.6.1`, `cursor-agent-mcp@1.0.5`, and `mcp-google-maps@0.1.0`.
- Matching npm-global duplicate packages were removed after pnpm command ownership was verified.
- `@debugmcp/logs` appeared in pre-migration npm output without package metadata and was removed from npm global during duplicate cleanup; no pnpm replacement was installed because no installed version could be proven locally.
- `openclaw` was not migrated or removed from npm global because live evidence still contains npm-global OpenClaw path references and active command ownership is pinned to `D:\openclaw\bin`.
- `clawhub --cli-version` reports `0.22.0` from pnpm-owned command resolution.

## Remaining Package-Manager Conflict List

- npm global still contains developer CLIs outside the current OpenClaw plugin/MCP migration scope: `@anthropic-ai/claude-code`, `@bitwarden/cli`, `@expo/ngrok`, `@google/clasp`, `@tobilu/qmd`, `cursor-agent`, `depwire-cli`, `eas-cli`, `firebase-tools`, `mmx-cli`, `pm2`, and `wrangler`.
- npm global still contains `openclaw` without a version in `npm list -g --depth=0`; do not remove it until live OpenClaw launcher/runtime references are migrated or proven obsolete.
- `D:\github\open--claw` has no root package.json and should not receive a package manager layer merely for these docs.
- `D:\github\open--claw\vendor\openclaw` declares `pnpm@10.23.0`; do not normalize this vendored reference unless intentionally updating/forking upstream.
- `C:\Program Files\ClawX\resources\openclaw` and `D:\openclaw\runtime\openclaw\node_modules\openclaw` declare OpenClaw `2026.6.10` with `pnpm@11.2.2+sha512...`; those are runtime/bundled package pins.
- OpenClaw-managed plugin runtime islands under `C:\Users\ynotf\.openclaw\npm\projects` use npm locks. Do not manually move them; document and let OpenClaw manage plugin lifecycle unless a later verified tool contract says otherwise.
- Existing target docs contain `npx clawhub` and `npm install -g openclaw` examples. These should be rewritten in a later docs-cleanup phase to reflect the Corepack/pnpm target where applicable.

## Required Backups Before Any Future Write

- Create an ACL-restricted backup root such as `C:\Users\ynotf\openclaw-control-plane-backups\YYYYMMDD-HHMMSS`.
- Capture Git evidence for `D:\openclaw`, `D:\github\open--claw`, and `D:\github\open--claw\vendor\openclaw`: branch, head, remote, short status, diff names, and relevant untracked manifests.
- Back up any target files that would be overwritten or merged, especially if they overlap current `.serena` modifications or older control-plane docs.
- Before runtime writes, back up selected `C:\Users\ynotf\.openclaw` config files, plugin manifests, and lockfiles without printing or committing contents.
- Before ClawX app-data writes, back up selected `C:\Users\ynotf\AppData\Roaming\clawx` config files and app state needed for rollback.
- Before package-manager changes, back up PATH/User environment values, npm global list, pnpm global list, npm prefix/root, pnpm home/root/bin evidence, and shim paths.
- Before ClawHub changes, back up ClawHub config/state files in a restricted backup location and record only redacted metadata in Git.
- Keep rollback manifests out of Git if they contain local paths that reveal sensitive state, credentials, or session details.

## Remaining Corepack, pnpm, and ClawHub Normalization Plan

1. Verify the new User PATH in a completely new interactive PowerShell session outside Codex.
2. Run a ClawHub non-mutating smoke test such as `clawhub search <query> --no-input` or `clawhub inspect <known-safe-slug> --no-input` before any real skill install/update.
3. Do not upgrade ClawHub yet. Upgrade from `clawhub@0.22.0` to `clawhub@0.23.1` remains a later compatibility change.
4. Do not alter active OpenClaw CLI ownership until live launcher references and runtime config are migrated or proven obsolete.
5. Do not remove npm-global OpenClaw yet. Investigate the unversioned npm-global `openclaw` entry and current launcher ownership before any change.
6. Do not manually move OpenClaw-managed runtime plugin islands under `C:\Users\ynotf\.openclaw\npm\projects`.
7. For remaining npm-global developer CLIs, decide package-by-package whether they belong in the pnpm global toolchain or should remain npm-owned.

## OpenClaw vs ClawX Authority Model

- OpenClaw live runtime state is `C:\Users\ynotf\.openclaw`.
- ClawX app runtime state is `C:\Users\ynotf\AppData\Roaming\clawx`.
- ClawX installed application code is `C:\Program Files\ClawX`.
- Current operational docs/scripts/agent authority is `D:\openclaw`.
- Future durable control-plane authority is `D:\github\open--claw` after migration acceptance.
- Upstream OpenClaw implementation reference is `D:\github\open--claw\vendor\openclaw`.
- `D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1` remains the active launcher evidence until the CLI ownership phase explicitly changes it.

## Acceptance Gates

- The two classification/migration docs exist in `D:\github\open--claw`.
- Only approved documentation files are changed by the documentation-only pass; existing Serena modifications remain untouched.
- `git diff --check` passes.
- A secret scan against only the new docs passes, or any finding is category-reported without printing values.
- Migration map explicitly keeps `D:\openclaw` authoritative until staged target acceptance.
- Migration map records completed ClawHub/npm-global plugin/MCP migration to pnpm-global with preserved versions.
- No runtime roots are modified.
- Package manager and User PATH changes are limited to pnpm global enablement plus migrated plugin/MCP command ownership; npm-global OpenClaw and plugin runtime islands are unchanged.
- No commit, stage, push, delete, merge, reinstall, or bulk copy is performed.

## Unresolved Approval Questions

- Should the later pnpm migration include `openclaw` from npm global, or should active OpenClaw CLI ownership remain pinned to the ClawX/runtime launcher path?
- Should target docs replace existing `npx clawhub` examples with pnpm-global examples now that ClawHub is pnpm-owned?
- Which `D:\openclaw\agents` and `D:\openclaw\Polished-Agents` roles should become durable source-controlled agent packets, and which should remain legacy reference?
- Should `D:\openclaw\scripts\Invoke-ClawXOpenClaw.ps1` be copied into the target repo as a source-controlled launcher later, or only documented as active machine state?
- What acceptance test proves ClawHub "works properly" for this machine: version output, search, inspect, auth status, install dry run, or a real skill install/update into a disposable OpenClaw test home?
- When should `D:\openclaw` be frozen, archived, or retired after target acceptance?
