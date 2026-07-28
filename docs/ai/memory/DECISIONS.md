# Decisions Log — Open Claw

Record key decisions with rationale. One entry per decision.

## Entries

<!-- Format:

## <Date> — <Decision Title>

**Context:** What prompted this decision
**Decision:** What was chosen
**Alternatives considered:** What else was evaluated
**Rationale:** Why this was selected
-->

---

## 2026-03-29 — OpenClaw Worker Agent Identity

**Context:** Bot workers were failing because they called `--agent <worker-name>` but the gateway only has `main` registered.
**Decision:** All CrewClaw/curated bot workers must call `--agent main`, not `--agent <worker-name>`.
**Alternatives considered:** Registering named agents on the gateway.
**Rationale:** The gateway only has `main` registered. Per-worker persona differentiation happens via prompt/session, not via a separately named gateway agent. This is the only working runtime configuration as of 2026-03-29.

---

## 2026-03-29 — Named Docker Volumes for OpenClaw Device Identity

**Context:** Container restarts were causing device identity loss (new pairing required each restart), which would block autonomous startup.
**Decision:** Named Docker volumes (`crewclaw-openclaw-<name>:/root/.openclaw`) are the canonical mechanism to preserve device identity across container restarts.
**Alternatives considered:** Bind mounts, stateless containers with re-pairing each run.
**Rationale:** Named volumes survive `docker compose down/up` and preserve the pairing approval. Without this, every restart requires manual gateway pairing (`openclaw devices approve`), which breaks autonomous startup.

---

## 2026-03-29 — OpenClaw Install Recipe for Docker Workers

**Context:** Legacy workers used `node:20-slim` + plain `npm install -g openclaw` which failed (Node version mismatch, `openclaw` binary not found, Baileys/libsignal native build errors).
**Decision:** Proven install recipe: `FROM node:22-slim` + `apt-get install git ca-certificates` + `npm install -g openclaw@2026.3.13 --ignore-scripts`.
**Alternatives considered:** node:20-slim (fails Node version check), standard `npm install -g openclaw` without `--ignore-scripts` (fails on native dep build).
**Rationale:** OpenClaw requires Node 22+. `--ignore-scripts` skips Baileys/libsignal native build which is not needed for Telegram-only bots. Pinned `2026.3.13` over `latest` for reproducibility.

---

## 2026-03-31 — Sparky as Exclusive ACCEPT/REFACTOR/REJECT Authority

**Context:** Delegation chain was ambiguous: multiple roles (code-reviewer, qa-evidence-collector, reality-checker) all had language implying they could make final quality decisions, creating competing authority.
**Decision:** Sparky (`sparky-chief-product-quality-officer`) is the exclusive final ACCEPT/REFACTOR/REJECT authority for all file changes and release decisions. No other employee may issue these decisions.
**Alternatives considered:** Peer review model (multiple roles with veto power), reality-checker as a parallel final authority.
**Rationale:** Aligns with `FINAL_OUTPUT_PRODUCT.md` which designates Sparky as the lead AI and final internal quality authority. A single authority prevents ambiguous handoffs and competing verdicts.

---

## 2026-03-31 — Deterministic Handoff Chain

**Context:** Handoff sequencing was informal and prone to role conflicts.
**Decision:** The canonical handoff chain is: **brief → routing → implement → evidence collection (parallel) → Sparky gate → release → post-release verification**.
**Alternatives considered:** Informal role-to-role agreements; peer review gates at multiple stages.
**Rationale:** A single deterministic chain eliminates ambiguity about who hands to whom. Evidence collection (code review, QA, reality check) runs in parallel and feeds Sparky. Only Sparky's gate advances the work to release.

---

## 2026-03-31 — Reality Checker Is a Recommender, Not a Parallel Authority

**Context:** Reality Checker `AGENTS.md` previously implied it could route release decisions to Delivery Director directly, bypassing Sparky.
**Decision:** Reality Checker is a go/no-go **recommender** to Sparky only. It does not issue an independent final go/no-go decision and does not route to Delivery Director.
**Alternatives considered:** Reality Checker as a co-equal final authority alongside Sparky.
**Rationale:** Single ACCEPT/REFACTOR/REJECT authority model requires all recommendations to flow through Sparky.

---

## 2026-03-31 — Forbidden Platform Targets for the Tri-Workspace

**Context:** The tri-workspace targets Windows, WSL, Android, Docker, and web. macOS/iOS scope creep would be a charter violation.
**Decision:** Forbidden build targets: macOS applications, iOS applications, Swift source code, Xcode projects/workspaces, CocoaPods dependencies. Detection stops execution immediately.
**Alternatives considered:** Soft warnings only.
**Rationale:** Enforced in `.cursor/rules/01-charter-enforcement.md` as a hard-stop rule. Violations route to Sparky and require Tony authorization to continue.

---

## 2026-03-31 — KB-Based STATE.md Archive Policy Replaces Line-Count Rule

**Context:** Legacy rule said STATE.md must not exceed ~500 lines, which was too restrictive and disconnected from actual token cost.
**Decision:** STATE.md archive is governed by KB thresholds: ≤140 KB target; >140 KB warn; >180 KB archive required. Practical line-count proxies: ~800 lines soft warning, ~1000 lines hard ceiling.
**Alternatives considered:** Keep ~500 line rule; use raw token count.
**Rationale:** KB-based thresholds directly reflect PLAN preload budget. Line-count proxies are a practical fallback. Content relevance overrides raw count — do not archive solely on line count if within the KB target.

---

## 2026-04-01 — Quarantine Enforcement Model for Non-Routable Content

**Context:** `candidate_employees/**` (163 imported role library files) and droidrun iOS files are out of scope for routing, search, memory, and embeddings, but must not be deleted.
**Decision:** Quarantine is path-based and enforced at 5 simultaneous layers: (1) file banners, (2) `.cursor/rules/02-non-routable-exclusions.md` enforcement rules, (3) `openmemory.mdc` memory exclusions, (4) bootstrap prompt quarantine blocks, (5) canonical registry `NON_ROUTABLE_QUARANTINE.md` with promotion gate.
**Alternatives considered:** Deletion of out-of-scope files; single-layer enforcement (rules only).
**Rationale:** Banner-only pass preserves the audit trail and content. Multi-layer enforcement ensures no single failure allows quarantined content into active flows. Promotion gate prevents accidental activation.

---

## 2026-04-01 — Quarantine Source of Truth

**Context:** Multiple enforcement layers need a canonical registry to avoid drift.
**Decision:** `open-claw/AI_Employee_knowledgebase/NON_ROUTABLE_QUARANTINE.md` is the canonical source of truth for all quarantine status decisions and promotions.
**Alternatives considered:** Embedding quarantine status in individual rule files.
**Rationale:** Single canonical registry with a promotion gate prevents conflicting enforcement across the 5 layers and provides an audit trail.

---

## 2026-07-28 — Windows Gateway Ownership Uses the Operational Runtime, Not ClawX or npm-global

**Context:** The registered Windows gateway task still referenced broken npm-global OpenClaw, while ClawX could independently auto-start an embedded gateway on the same port.
**Decision:** The authoritative Windows gateway chain is the `OpenClaw Gateway` scheduled task using system Node plus `D:\openclaw\runtime\openclaw\node_modules\openclaw\dist\index.js`. ClawX remains optional UI/fallback with `gatewayAutoStart=false`. The interactive CLI remains `D:\openclaw\bin` and uses `openclaw.mjs`.
**Alternatives considered:** Keep broken npm-global service ownership; let ClawX own the gateway; point the task at the ClawX bundle; combine the change with a PATH launcher cutover.
**Rationale:** This preserves the locked authority model, removes the stale dependency, keeps installer-managed ClawX read-only, and separates service stabilization from a future launcher/PATH decision.

---

## 2026-07-28 — Listener Ownership Requires Process Proof

**Context:** `Get-NetTCPConnection` returned false negatives while `netstat` showed a live listener, and a successful gateway health probe initially reached ClawX rather than the scheduled-task runtime.
**Decision:** Gateway acceptance requires `netstat.exe -ano -p tcp` plus `Win32_Process` proof that port `18789` belongs to system Node executing the approved `D:\openclaw` service entry.
**Alternatives considered:** Treat task state or `gateway health` alone as sufficient; continue using `Get-NetTCPConnection` alone.
**Rationale:** Task registration and endpoint health do not prove runtime ownership. PID/command-line proof prevents a healthy but unauthorized fallback process from satisfying acceptance.
