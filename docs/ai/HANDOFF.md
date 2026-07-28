# Agent Handoff — Open Claw

**Date**: 2026-07-28
**Status**: Windows gateway ownership stabilized; this file remains an optional operator snapshot only.
**Recovery note**: Follow `D:/github/AI-Project-Manager/docs/ai/operations/NO_LOSS_RECOVERY_LOOP.md` for the canonical no-loss order. `HANDOFF.md` is optional and never required for recovery.

Previous handoff snapshot archived at `docs/ai/archive/handoff-2026-03-08.md`.

---

## 2026-07-28 Control-Plane Update

- OpenClaw is runtime/control authority; ClawX is optional desktop UI/fallback.
- `D:\github\open--claw` now carries the durable blueprint, recovery/package-manager runbooks, CrewClaw discovery plan, verification/backup/cleanup scripts, and a non-invasive launcher prototype.
- Active `openclaw` ownership remains `D:\openclaw\bin`; no PATH cutover occurred.
- System Node owns Node/npm/npx/Corepack; Corepack owns pnpm; pnpm-global owns ClawHub `0.22.0` and migrated MCP shims.
- Lossless Claw `0.13.1` remains loaded and activated.
- The `OpenClaw Gateway` task now uses system Node plus `D:\openclaw\runtime\openclaw\node_modules\openclaw\dist\index.js`.
- Gateway stop, start, forced restart, listener ownership, and health passed.
- ClawX remains available, with `gatewayAutoStart=false` so its embedded gateway does not compete for port `18789`.
- The four stale npm-global OpenClaw artifacts were removed after the dependency gate passed.
- Final control-plane verifier: `38 PASS`, `0 WARN`, `0 FAIL`.
- Next safe phase: keep `D:\openclaw` as operational authority and evaluate source-controlled launcher/PATH cutover independently.

Current operating references:

- `docs/blueprints/OPENCLAW_CLAWX_CONTROL_PLANE_BLUEPRINT.md`
- `docs/runbooks/OPENCLAW_CLAWX_RECOVERY.md`
- `docs/audits/2026-07-28-npm-global-openclaw-cleanup-gate.md`
- `docs/audits/2026-07-28-openclaw-gateway-ownership-migration.md`

---

## 1. Project Role

`open--claw` is the **strict enforcement center** of the tri-workspace. The supreme product charter — `open-claw/AI_Employee_knowledgebase/FINAL_OUTPUT_PRODUCT.md` — lives here. No agent, prompt, rule, or doc in any repo may override it.

**Workspace layer model (durable operating truth):**

- `AI-Project-Manager` — workflow/process layer: tab contracts, state tracking, execution discipline, tool policy. Does not issue product law.
- `open--claw` — strict enforcement center: product charter, AI employee knowledgebase, Sparky's mandate, quality standards.
- `droidrun` — actuator layer: phone automation, MCP phone tools, Portal/APK runtime bridge.

`docs/ai/STATE.md` and `docs/ai/HANDOFF.md` (this file) are **operational evidence only**. They record what happened and what is blocked. They are not product law and cannot override the charter.

---

## 2. Current Runtime Truth (2026-03-29; last verified)

- OpenClaw runtime: **v2026.3.13** via `~/openclaw-build` (CLI `pnpm openclaw` + systemd `dist/index.js`)
- Gateway: healthy on `0.0.0.0:18789` (bind=lan), API health on `127.0.0.1:18792`
- Channels:
- **Telegram**: healthy, running, `@SECRETARY_STACY_BOT`, polling mode (renamed from `@Sparky4bot`)
  - **WhatsApp**: linked/stopped — **401 Unauthorized** — needs QR re-scan (`pnpm openclaw channels login --channel whatsapp`)
- Windows node: **Windows Desktop — connected** (verified 2026-03-29 preflight)
- Execution mode: direct host path active (sandbox mode off by design)
- Context engine: lossless-claw active for long-session resilience
- Canonical gateway restart: see `AI-Project-Manager/docs/ai/operations/openclaw-gateway-restart.md`

### Legacy CrewClaw Workers

10 legacy purchased workers still in Docker (unchanged):

- `api-integration-specialist`
- `code-reviewer`
- `financial-analyst`
- `frontend-developer`
- `overnight-coder`
- `personal-crm`
- `script-builder`
- `seo-specialist`
- `software-engineer`
- `ux-designer`

### Curated Generated Runtime

The curated 15-employee squad has a generated runtime at `open-claw/employees/deployed-curated/`.

- 15 employee packets are runtime-synced under `open-claw/AI_Employee_knowledgebase/AI_employees/`
- each packet includes required docs, required runtime files, and copied assigned skills
- generated runtime passes: `docker compose config`, `node --check`, PowerShell parse on `start-employees.ps1`
- `start-employees.ps1 -CheckOnly` now proves which curated workers are immediately startable without launching containers
- Sparky now carries an expanded super-coder skill bundle spanning product, engineering, QA, communication, and phone/voice integration
- Bitwarden now has direct secret IDs wired for all 15 curated workers and the generated docs record all Telegram usernames
- `sparky-chief-product-quality-officer` is the sole `host_native_primary` runtime; the other 14 curated workers remain in the Docker worker pool
- `start-employees.ps1 -CheckOnly -CeoOnly` now audits the CEO host-native path and `start-employees.ps1 -CeoOnly` now injects `SPARKY_CEO_BOT` into `TELEGRAM_BOT_TOKEN` before launching the CEO packet
- The host-native Sparky launcher now creates a packet-local OpenClaw config/workspace under `.openclaw-runtime/`, so live replies read Sparky's own packet docs instead of the generic Windows `~/.openclaw/workspace`
- The live Sparky packet now includes a continuity layer adapted from `temp/Sparky`: `ONBOARDING.md`, `DECISION_LOG.md`, `live/SESSION-STATE.md`, and `live/working-buffer.md`
- **Current live-start status**:
- The CEO host-native startup path is now implemented, but live Telegram responsiveness for `SPARKY_CEO_BOT` is still pending a smoke test
- The 14-worker Docker pool remains structurally ready, but it is still not fully live-proven against the real gateway/tokens
- First live start will require gateway pairing approval: `openclaw devices list` → `openclaw devices approve <id>`
- Phone/voice support now has a standalone incubation stack at `open-claw/services/voice-front-desk-agent/` with Twilio Voice webhook handling, websocket intake, and ElevenLabs configuration surface; it is not live until public HTTPS/WSS plus credentials are wired
- Nerve is installed in isolation at `temp/openclaw-nerve` and serves locally on `127.0.0.1:3080`; it sits in front of the existing gateway and does not replace the gateway runtime

---

## 3. Phase Status

| Phase | Status |
|---|---|
| Phase 0 — Project Kickoff | COMPLETE |
| Phase 1 — Gateway Boot + Integration Scaffold | COMPLETE (2026-03-08) |
| Phase 2 — First Live Integration | COMPLETE (2026-03-14) |
| Phase 1A — CrewClaw Worker Stabilization | COMPLETE |
| Phase 1C — Curated runtime sync and workflow validation | COMPLETE |
| Phase 1D — Docs cross-reference alignment | COMPLETE |
| Phase 1E — FINAL_OUTPUT_PRODUCT single-source-of-truth charter | COMPLETE |
| Phase 1F — Curated Telegram bot assignment mapping | COMPLETE |
| Phase 1G — Employee status board | COMPLETE |
| Autonomy model rewrite | COMPLETE (2026-03-31) |
| Sparky enforcement gate + delegation chain | COMPLETE (2026-03-31) |
| Charter enforcement kernel install | COMPLETE (2026-03-31) |
| Governance normalization (Prompt 7) | COMPLETE (2026-03-31) |
| Non-routable quarantine system (Prompt 8) | COMPLETE (2026-04-01) |
| **STATE.md archive/compaction pass** | **COMPLETE (2026-04-01)** |
| Phase 1B — Memory Bridge (OpenClaw ↔ OpenMemory) | NOT STARTED (deferred) |

---

## 4. Active Blockers

| Blocker | Action Required |
|---|---|
| WhatsApp 401 — session expired | User runs `pnpm openclaw channels login --channel whatsapp` and scans QR |
| `SPARKY_CEO_BOT` upgraded persona/memory still needs user-visible smoke confirmation | Send a fresh normal message to `SPARKY_CEO_BOT` after the latest restart and confirm the reply uses Sparky's product/quality identity instead of a generic assistant voice |
| Curated Docker worker pool not yet live-proven | Run `open-claw/employees/deployed-curated/start-employees.ps1` or `-RequireCeo`, then approve device pairings and perform smoke tests |
| Phone/voice worker not yet live-proven | Add Twilio Voice credentials, ElevenLabs credentials, and a public HTTPS/WSS host for `open-claw/services/voice-front-desk-agent/`, then run a smoke call |
| Nerve is installed but not yet documented as a standard operator surface | Keep it local on `127.0.0.1:3080`, then decide whether it should stay optional or become part of the normal OpenClaw operator workflow |
| Memory bridge not fully operationalized | Phase 1B design exists, but curated worker flows still need a real memory-promotion path through the repaired OpenMemory stack |
| Live gateway pairing / command authority still needs smoke evidence | After `SPARKY_CEO_BOT` launches, verify `/start`, a normal message, and an elevated command path |
| Recovery bundle refresh path is not yet proven beyond initial AI-PM materialization | Use `D:/github/AI-Project-Manager/docs/ai/recovery/*` for crash recovery, but keep validating that later workflow changes continue to refresh it correctly |

---

## 5. Quarantine System (installed 2026-04-01)

The non-routable quarantine system is now active across all three repos at 5 enforcement layers:

1. **File banners**: `<!-- NON-ROUTABLE — OUT OF SCOPE -->` on all 2,608 `candidate_employees/**` files; `# NON-ROUTABLE — OUT OF SCOPE` on 3 droidrun iOS Python files
2. **Enforcement rules**: `02-non-routable-exclusions.md` in all three repos (alwaysApply: true)
3. **Memory exclusions**: `openmemory.mdc` updated in AI-Project-Manager and droidrun
4. **Bootstrap prompt blocks**: PLAN and AGENT tabs in open--claw and droidrun updated
5. **Canonical registry**: `open-claw/AI_Employee_knowledgebase/NON_ROUTABLE_QUARANTINE.md` with promotion gate and audit trail

To promote a quarantined file to active use, follow the promotion gate in `NON_ROUTABLE_QUARANTINE.md`.

---

## 6. How To Use This File

Use this file only when the canonical no-loss order still leaves unresolved operator/runtime questions after the recovery bundle and `docs/ai/STATE.md` summary/current state section.

- `HANDOFF.md` is optional and never required for recovery.
- Prefer `docs/ai/memory/DECISIONS.md` for durable why and `docs/ai/memory/PATTERNS.md` for durable how before consulting this file.
- Use archive docs and this file as historical/operational evidence only, not product law.

### Serena local scope

Use Serena for runtime code only through `D:/github/open--claw/open-claw`. Do not assume the repo-root dashboard entry represents the correct OpenClaw code project. For repo-root governance/docs work, use targeted read/search fallback unless a dedicated Serena project is explicitly activated.

### Team operating model

Run the curated squad as a managed org, not a loose packet library:

- Sparky is the only final accept/reject gate
- delivery-director sequences all work packets
- work flows through brief -> architecture -> implementation -> review -> evidence -> Sparky gate -> release
- readiness is tracked separately as `packet_ready`, `runtime_ready`, `smoke_ready`, and `live_ready`
- use `open-claw/AI_Employee_knowledgebase/TEAM_OPERATING_SYSTEM.md` as the operating reference
