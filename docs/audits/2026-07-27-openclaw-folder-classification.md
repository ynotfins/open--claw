# OpenClaw Folder Classification

Report date: 2026-07-27
Current verification refresh: 2026-07-28
Scope: folder classification plus package-manager ownership update evidence. This report does not authorize moves, deletes, runtime edits, commits, or pushes.

## Authority Summary

Current operational authority and migration source: `D:\openclaw`.

Intended future durable OpenClaw/ClawX control-plane authority: `D:\github\open--claw`, but only after staged migration, acceptance review, and explicit user approval.

Live runtime authority: `C:\Users\ynotf\.openclaw`. This is production runtime state, not a normal source repo.

ClawX desktop app runtime state: `C:\Users\ynotf\AppData\Roaming\clawx`.

Installer-managed app bundle: `C:\Program Files\ClawX`.

Upstream source reference: `D:\github\open--claw\vendor\openclaw`.

## Classification Matrix

| Root | Classification | Recommended final role | Source controlled | Codex write policy | Backup policy |
| --- | --- | --- | --- | --- | --- |
| `C:\Users\ynotf\.openclaw` | live runtime state; custom agent/config source; backup-only material | Live OpenClaw runtime state only | No, except a separate sanitized export repo if explicitly designed | Read-only for this pass; future writes only after targeted backup and validation | Back up before any runtime/config/plugin write |
| `C:\Users\ynotf\AppData\Roaming\clawx` | ClawX app data | Live ClawX desktop app data only | No | Read-only for this pass; future writes only after targeted app-data backup | Back up before any app config/session-impacting write |
| `C:\Program Files\ClawX` | installed application bundle | Installer/vendor-managed application bundle | No | Read-only | Back up only before official repair or reinstall work |
| `D:\github\open--claw` | intended control-plane repo; legacy workspace material | Future durable control-plane target after staged migration | Yes, for sanitized docs, runbooks, scripts, manifests, audits, and control-plane history | Write allowed only for approved docs in this pass | Back up dirty overlapping files before future overlapping edits |
| `D:\github\open--claw\vendor\openclaw` | upstream source checkout; vendored dependency | Read-only upstream OpenClaw source reference | Parent repo should ignore it; nested checkout may track upstream separately | Read-only unless explicit fork/patch approval | Back up or branch before any approved fork/patch |
| `D:\openclaw` | intended current operational authority; legacy workspace; custom agent/config source; backup-only material | Current migration source and operational authority until target acceptance | Not as-is; only sanitized extracted material should move to target | Read-only for this pass | Back up before any extraction that reads sensitive source in bulk, and before any later mutation |

## Root Details

### `C:\Users\ynotf\.openclaw`

- Classification: live runtime state; custom agent/config source; backup-only material.
- Evidence found: runtime folders include `.clawhub`, `.context-fabric`, `.serena`, `agents`, `credentials`, `data`, `devices`, `extensions`, `identity`, `logs`, `mcp-oauth`, `memory`, `nodes`, `npm`, `plugin-skills`, `plugins`, `secrets`, `state`, `workspace`, and runtime DB files including `lcm.db`, `openclaw.sqlite`, `*-wal`, and `*-shm`.
- Git status if applicable: Git repo on `main`, remote `https://github.com/ynotfins/openclaw-home.git`, short head `1aebc0c`, 7 short-status entries at verification time.
- Package manager files found: no root `package.json`; package files under runtime-managed areas such as `extensions\hirey`, `extensions\whatsapp`, and `npm\projects\...`.
- Lockfiles found: runtime/plugin `package-lock.json` files under `npm\projects\...`; `npm-shrinkwrap.json` under `extensions\whatsapp`.
- `packageManager` field: no root field because no root package.json was found.
- `node_modules` presence: present under extension and npm project runtime islands, including `extensions\hirey`, `extensions\whatsapp`, and `npm\projects\...`.
- OpenClaw config files: `openclaw.json`, `openclaw.json.last-good`, multiple historical `openclaw.json.*` backups, `gateway.cmd`, `node.json`, runtime DBs, identity, devices, credentials, secrets, mcp-oauth, and plugin/skill state.
- ClawX config files: `.openclaw\clawx` exists and may contain ClawX-adjacent runtime state; do not conflate it with the Roaming ClawX app-data root.
- Scripts: many runtime and repair scripts at root and under `scripts`, including token, gateway, Obsidian, OpenMemory, watchdog, and launch helpers.
- Agents: `agents` exists and may include active runtime agent material.
- Plugin/skill references: `plugins`, `plugin-skills`, `skills`, `skill-workshop`, `extensions`, and `npm\projects` are present. Runtime-managed plugin islands include npm-managed projects such as `openclaw-acpx`, `openclaw-brave-plugin`, `openclaw-deepseek-provider`, `openclaw-exa-plugin`, `openclaw-firecrawl-plugin`, `openclaw-perplexity-plugin`, and `martian-engineering-lossless-claw`.
- Secrets risk by category only: credentials, tokens, OAuth material, session state, identity/device state, runtime databases, lockfiles, logs, command wrappers, and historical backups.
- Should it be source controlled: no, not as a whole. Only sanitized derived documentation/manifests should be committed elsewhere.
- Codex may write to it: no for this pass.
- Should it be read-only: yes by default.
- Should it be backed up: yes before any future runtime write.
- Recommended final role: production OpenClaw runtime state and evidence source only; never the durable control-plane repo.

### `C:\Users\ynotf\AppData\Roaming\clawx`

- Classification: ClawX app data.
- Evidence found: Electron/Chromium-style app data including `Cache`, `Code Cache`, `GPUCache`, `Local Storage`, `Session Storage`, `Network`, `Partitions`, `Preferences`, `Local State`, app locks, logs, `clawx-device-identity.json`, `clawx-providers.json`, and `settings.json`.
- Git status if applicable: no Git repo found.
- Package manager files found: none found in the bounded inspection.
- Lockfiles found: none found in the bounded inspection.
- `packageManager` field: none found.
- `node_modules` presence: none found.
- OpenClaw config files: no primary OpenClaw source config; app may reference OpenClaw runtime indirectly.
- ClawX config files: `settings.json`, `clawx-providers.json`, `clawx-device-identity.json`, `Preferences`, `Local State`, lock files, and browser/app storage.
- Scripts: none found in the top-level evidence.
- Agents: none found in the top-level evidence.
- Plugin/skill references: app storage may contain UI state and references; do not treat as source.
- Secrets risk by category only: provider config, app identity, local/browser storage, session state, caches, logs, and app locks.
- Should it be source controlled: no.
- Codex may write to it: no for this pass.
- Should it be read-only: yes by default.
- Should it be backed up: yes before future ClawX app-data writes.
- Recommended final role: live ClawX desktop app state.

### `C:\Program Files\ClawX`

- Classification: installed application bundle.
- Evidence found: `ClawX.exe`, `Uninstall ClawX.exe`, Electron/Chromium DLLs and resource files, `locales`, and `resources`.
- Git status if applicable: no Git repo found.
- Package manager files found: `resources\openclaw\package.json`, bundled extension package files under `resources\openclaw\dist\extensions\...`, and plugin shrinkwrap files under `resources\openclaw-plugins`.
- Lockfiles found: `resources\openclaw\npm-shrinkwrap.json`; plugin `npm-shrinkwrap.json` files for bundled plugins such as `discord`, `qqbot`, and `whatsapp`.
- `packageManager` field: `resources\openclaw\package.json` reports `openclaw` version `2026.6.10` and package manager `pnpm@11.2.2+sha512...`.
- `node_modules` presence: present under `resources\openclaw` and many bundled extension folders.
- OpenClaw config files: bundled OpenClaw source/runtime package under `resources\openclaw`, not user runtime state.
- ClawX config files: installer app files, not user app-data config.
- Scripts: bundled vendor scripts may exist under resources; do not modify.
- Agents: none classified as user-owned source in this root.
- Plugin/skill references: bundled OpenClaw extensions and plugins under `resources`.
- Secrets risk by category only: low for source secrets, but installed app files may contain cached/bundled config and should not be altered manually.
- Should it be source controlled: no.
- Codex may write to it: no.
- Should it be read-only: yes.
- Should it be backed up: only before official repair/reinstall or vendor-guided intervention.
- Recommended final role: installer-managed ClawX application bundle.

### `D:\github\open--claw`

- Classification: intended control-plane repo; legacy workspace material.
- Evidence found: Git repo with `AGENTS.md`, `README.md`, `VENDOR_PIN.md`, `.gitignore`, `.node-version`, `.cursor`, `.serena`, `docs`, `open-claw`, `temp`, and `vendor`.
- Git status if applicable: Git repo on `main`, remote `https://github.com/ynotfins/open--claw.git`, short head `1698004`, pre-existing modified files were `.serena/project.yml` and `open-claw/.serena/project.yml`.
- Package manager files found: no root package.json. Package files exist under historical/embedded material in `open-claw\AI_Employee_knowledgebase`, `open-claw\employees`, `open-claw\services`, `temp`, and the vendored upstream checkout.
- Lockfiles found: mixed `package-lock.json`, `pnpm-lock.yaml`, `pnpm-workspace.yaml`, and `yarn.lock` under subtrees. Vendor lockfiles are under `vendor\openclaw` and should remain scoped to the vendor checkout.
- `packageManager` field: no root field. The vendored upstream `package.json` reports `pnpm@10.23.0`.
- `node_modules` presence: present in historical/embedded subtrees and vendor checkout; should not be treated as clean control-plane source material.
- OpenClaw config files: repo-level `AGENTS.md`, `VENDOR_PIN.md`, OpenClaw-adjacent docs, `open-claw\configs`, `open-claw\scripts`, `open-claw\skills`, and vendor reference.
- ClawX config files: no live ClawX app-data authority; only docs/source references.
- Scripts: scripts exist under `open-claw\scripts` and historical source trees.
- Agents: older agent corpus under `open-claw\AI_Employee_knowledgebase\AI_employees`; fewer and older than `D:\openclaw\agents` and `D:\openclaw\Polished-Agents`.
- Plugin/skill references: docs reference ClawHub and skill management, including `npx clawhub` examples that should be reviewed in the migration plan.
- Secrets risk by category only: historical configs, old generated source trees, embedded `node_modules`, temp material, and vendor baseline files. Do not assume clean until scanned.
- Should it be source controlled: yes, after sanitizing and excluding generated/runtime/vendor/cache material.
- Codex may write to it: yes for the two approved docs in this pass only.
- Should it be read-only: no as a repo, but vendor, runtime-looking, and dirty unrelated files remain read-only for this pass.
- Should it be backed up: yes before overlapping dirty-file edits or broader migrations.
- Recommended final role: future durable OpenClaw/ClawX control-plane target after staged migration and acceptance.

### `D:\github\open--claw\vendor\openclaw`

- Classification: upstream source checkout; vendored dependency.
- Evidence found: independent Git checkout with `package.json`, `pnpm-lock.yaml`, `pnpm-workspace.yaml`, `apps`, `packages`, `extensions`, `skills`, `src`, `dist`, `test`, `test-fixtures`, `scripts`, `.detect-secrets.cfg`, `.secrets.baseline`, and other upstream project files.
- Git status if applicable: nested Git checkout on detached `HEAD`, remote `https://github.com/openclaw/openclaw.git`, short head `3caab92`, 2 short-status entries at verification time.
- Package manager files found: root `package.json`, `pnpm-lock.yaml`, `pnpm-workspace.yaml`; package files under `extensions`, `apps`, `packages`, `skills`, `src`, and `vendor\a2ui`.
- Lockfiles found: root `pnpm-lock.yaml`; `vendor\a2ui` has isolated `package-lock.json` and pnpm lock/workspace files for renderer/specification subprojects.
- `packageManager` field: root `package.json` reports `openclaw` version `2026.3.8` and `pnpm@10.23.0`.
- `node_modules` presence: present at root and under many extension subtrees.
- OpenClaw config files: upstream OpenClaw project files, extension definitions, skills, test configs, and source.
- ClawX config files: none as live app data.
- Scripts: upstream scripts under `scripts` and package scripts.
- Agents: upstream `.agent`, `.agents`, and skill architecture references exist.
- Plugin/skill references: extensive upstream `extensions` and `skills` source; use for understanding internals only.
- Secrets risk by category only: upstream sample env files, security baseline files, test fixtures, and untracked local changes; do not print or commit sensitive matches.
- Should it be source controlled: parent repo should keep this ignored or pinned; the nested checkout may track upstream separately.
- Codex may write to it: no for this pass.
- Should it be read-only: yes unless explicit fork/patch approval is given.
- Should it be backed up: yes before any future fork/patch.
- Recommended final role: read-only upstream OpenClaw source reference.

### `D:\openclaw`

- Classification: current operational authority; intended current migration source; legacy workspace; custom agent/config source; backup-only material.
- Evidence found: root contains `README.md`, `AGENTS.md`, `OPENCLAW_PROJECT_HANDOFF.md`, `.openclawrules`, `agents`, `Polished-Agents`, `scripts`, `docs`, `reports`, `runtime`, `.openclaw-prefix`, `bin`, `backups`, `external`, `favorites`, `generated`, `logs`, `screenshots`, `S_25_Ultra`, and historical setup artifacts.
- Git status if applicable: Git repo on `main`, remote `https://github.com/ynotfins/openclaw.git`, short head `0f9ab87`, 574 short-status entries at verification time.
- Package manager files found: no root `package.json`. Agent packages under `agents\...`; runtime package under `runtime\openclaw\node_modules\openclaw`; pnpm global artifacts under `.openclaw-prefix`; backup/preserved package files under `backups`; historical package files under `favorites` and `external`.
- Lockfiles found: mixed historical `package-lock.json`, `pnpm-lock.yaml`, `pnpm-workspace.yaml`, `yarn.lock`, and `npm-shrinkwrap.json` across agents, runtime, backups, favorites, and external material.
- `packageManager` field: no root field. Runtime OpenClaw package reports `openclaw` version `2026.6.10` and `pnpm@11.2.2+sha512...`.
- `node_modules` presence: present under `.openclaw-prefix`, runtime OpenClaw, backups, and historical/materialized workspaces.
- OpenClaw config files: `.openclawrules`, runtime wrapper scripts, operational handoff docs, old runtime material, and OpenClaw-specific docs/reports.
- ClawX config files: `scripts\Invoke-ClawXOpenClaw.ps1` points the ClawX/OpenClaw launch path at the local runtime package. This is operational evidence, not target-repo authority.
- Scripts: 59 top-level script entries under `scripts`, including `Invoke-ClawXOpenClaw.ps1`, diagnostics, uninstall/preserve tooling, remote install/help scripts, and token-related scripts.
- Agents: 43 current `agents` entries and 41 polished agent entries plus indexes under `Polished-Agents`; newer and broader than the target repo's older employee corpus.
- Plugin/skill references: agent skill folders, `docs\plugin-clawhub-audit.md`, ClawHub references, runtime scripts, plugin audit artifacts, and historical plugin/runtime material.
- Secrets risk by category only: root `.env`, token-handling scripts, remote token capture scripts, backups, reports, logs, QR/screenshots, runtime prefixes, generated artifacts, credentials, config files, and preserved app/runtime state.
- Should it be source controlled: not as-is. Only sanitized docs, runbooks, scripts, audits, manifests, and derived control-plane material should migrate to `D:\github\open--claw`.
- Codex may write to it: no for this pass.
- Should it be read-only: yes during this documentation pass.
- Should it be backed up: yes before any future mutation, extraction automation, or cleanup.
- Recommended final role: authoritative migration source and current operational authority until `D:\github\open--claw` passes staged migration acceptance. After acceptance, preserve as legacy reference or retire only with explicit user approval.

## Cross-Cutting Package-Manager Findings

- Shell Node: `C:\Program Files\nodejs\node.exe`, version `v24.16.0`.
- npm: `11.13.0`, global prefix `C:\Users\ynotf\AppData\Roaming\npm`.
- Corepack: `0.35.0`.
- pnpm: `11.7.0`.
- `PNPM_HOME` process/user: `C:\Users\ynotf\AppData\Local\pnpm`.
- User PATH evidence after migration: Corepack shims are present; `C:\Users\ynotf\AppData\Local\pnpm\bin` is present after the Corepack shims and before the npm global prefix. `D:\openclaw\bin` remains ahead of pnpm so active `openclaw` CLI ownership is unchanged.
- pnpm global evidence after migration: `pnpm root -g` resolves to `C:\Users\ynotf\AppData\Local\pnpm\global\v11`; `pnpm bin -g` resolves to `C:\Users\ynotf\AppData\Local\pnpm\bin`.
- pnpm global packages now include preserved-version installs for `clawhub@0.22.0`, `@brave/brave-search-mcp-server@2.0.85`, `@debugmcp/mcp-debugger@0.21.0`, `@modelcontextprotocol/server-filesystem@2026.1.14`, `@modelcontextprotocol/server-sequential-thinking@2025.12.18`, `@playwright/mcp@0.0.76`, `@zavora-ai/computer-use-mcp@6.2.0`, `agent-browser@0.23.0`, `chrome-devtools-mcp@0.6.1`, `cursor-agent-mcp@1.0.5`, and `mcp-google-maps@0.1.0`.
- npm global packages after duplicate removal no longer include the migrated plugin/MCP tools above. npm global still includes developer CLIs such as `@anthropic-ai/claude-code`, `@bitwarden/cli`, `@expo/ngrok`, `@google/clasp`, `@tobilu/qmd`, `cursor-agent`, `depwire-cli`, `eas-cli`, `firebase-tools`, `mmx-cli`, `pm2`, `wrangler`, and an `openclaw` entry without a version in npm output.
- Command ownership after migration: `clawhub`, `clawdhub`, `brave-search-mcp-server`, `mcp-debugger`, `mcp-server-filesystem`, `mcp-server-sequential-thinking`, `playwright-mcp`, `computer-use-mcp`, `agent-browser`, `chrome-devtools-mcp`, `cursor-agent-mcp`, and `mcp-google-maps` resolve from `C:\Users\ynotf\AppData\Local\pnpm\bin`.
- ClawHub version proof after migration: `clawhub --cli-version` reports `0.22.0`.
- Backup evidence: package-manager and command-resolution state was captured before mutation under `C:\Users\ynotf\openclaw-control-plane-backups\20260728-001233`.
- OpenClaw source workspaces that declare pnpm should use their declared pnpm version. The vendor checkout declares `pnpm@10.23.0`; bundled/runtime OpenClaw packages declare `pnpm@11.2.2+sha512...`.
- OpenClaw-managed plugin islands under live runtime state use npm lockfiles and must not be manually moved.

## Classification Decision

`D:\openclaw` is currently more operationally authoritative than `D:\github\open--claw` because it contains newer custom agents, polished agents, active handoff/runbook material, runtime wrapper scripts, and broader recent operational evidence.

`D:\github\open--claw` remains the intended durable control-plane target, but it must become authoritative through a staged migration that copies or rewrites only sanitized, source-control-appropriate material and leaves live runtime/app/vendor state in place.
