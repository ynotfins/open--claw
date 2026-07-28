# Patterns Log — Open Claw

Record reusable patterns discovered during development.

## Entries

<!-- Format:

## <Pattern Name>

**Context:** When to use this pattern
**Pattern:** Description or code reference
**Example:** File path or snippet reference
**Caveats:** Known limitations or edge cases
-->

---

## OpenClaw Docker Worker Install Pattern

**Context:** Building a Docker container that runs an OpenClaw bot worker (e.g., a Telegram bot connecting to the gateway).
**Pattern:**
```dockerfile
FROM node:22-slim
RUN apt-get update && apt-get install -y git ca-certificates && \
    git config --global url.'https://github.com/'.insteadOf 'ssh://git@github.com/' && \
    npm install -g openclaw@2026.3.13 --ignore-scripts
```
Then in `entrypoint.sh`, write `~/.openclaw/openclaw.json` from env vars before launching the bot:
```bash
mkdir -p ~/.openclaw
cat > ~/.openclaw/openclaw.json << EOF
{ "gateway": { "mode": "remote", "remote": { "url": "$OPENCLAW_GATEWAY_URL", "token": "$OPENCLAW_GATEWAY_TOKEN" } } }
EOF
```
**Example:** `open-claw/employees/deployed-curated/` — 15-service generated runtime using this pattern.
**Caveats:** `--ignore-scripts` skips Baileys/libsignal native build (not needed for Telegram-only bots). Pinned to `2026.3.13` — retest against `latest` before upgrading. Node 22+ required; node:20-slim fails version check.

---

## Named Docker Volume for OpenClaw Device Identity

**Context:** Preserving an OpenClaw bot's device identity (gateway pairing) across container restarts.
**Pattern:** In `docker-compose.yml`:
```yaml
services:
  my-worker:
    volumes:
      - openclaw-my-worker:/root/.openclaw
volumes:
  openclaw-my-worker:
```
First run requires gateway pairing approval:
```bash
openclaw devices list
openclaw devices approve <id>
```
Subsequent restarts are automatic (no re-pairing needed).
**Example:** `open-claw/employees/deployed-curated/docker-compose.yml`
**Caveats:** Named volumes survive `docker compose down/up` but NOT `docker volume rm`. If the volume is deleted, re-pairing is required on the next start.

---

## Curated Employee Packet Structure

**Context:** Creating a self-contained AI employee packet that includes identity docs, runtime shell files, and assigned skills.
**Pattern:** Each employee folder under `AI_Employee_knowledgebase/AI_employees/<role>/` contains:
- Required docs: `AGENTS.md`, `SOUL.md`, `IDENTITY.md`, `TOOLS.md`, `USER.md`, `BOOTSTRAP.md`, `MEMORY.md`, `HEARTBEAT.md`, `SKILLS.md`, `WORKFLOWS.md`, `README.md`, `PROVENANCE.md`, `AUDIT.md`, `CHECKLIST.md`
- Required runtime files: `.env.example`, `Dockerfile`, `docker-compose.yml`, `entrypoint.sh`, `setup.sh`, `package.json`, `openclaw-runner.js`, channel bot entrypoints, `heartbeat.sh`
- Copied assigned skill files: `skills/<skill>/SKILL.md`

Generated/validated by `open-claw/scripts/sync_curated_employee_runtime.py` and `open-claw/scripts/validate_openclaw_workflow.py`.
**Example:** `open-claw/AI_Employee_knowledgebase/AI_employees/frontend-developer/`
**Caveats:** Runtime shell files are structurally validated (`docker compose config`, `node --check`) but require real bot tokens and gateway pairing for live operation.

---

## Quarantine Banner Pattern

**Context:** Marking files as non-routable without deleting them (e.g., out-of-scope candidate employees, iOS files in an Android-only actuator repo).
**Pattern:**
- Markdown files: Prepend `<!-- NON-ROUTABLE — OUT OF SCOPE -->\n` to the first line
- Python files: Prepend `# NON-ROUTABLE — OUT OF SCOPE\n` to the first line

Bulk prepend for markdown:
```powershell
Get-ChildItem -Path "candidate_employees" -Recurse -Filter "*.md" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    Set-Content $_.FullName -Value "<!-- NON-ROUTABLE — OUT OF SCOPE -->`n$content"
}
```
**Example:** `open-claw/AI_Employee_knowledgebase/candidate_employees/**` (2,608 files); `droidrun/src/droidrun/tools/ios/`
**Caveats:** Banner must appear on the very first line for embeddings/routing to detect it reliably. The promotion gate in `NON_ROUTABLE_QUARANTINE.md` must be followed before removing banners and activating any previously quarantined file.

---

## Windows OpenClaw Gateway Cutover Pattern

**Context:** Moving a Windows gateway scheduled task between OpenClaw runtime owners without losing rollback or accepting the wrong listener.

**Pattern:**

1. Export the scheduled-task XML and back up `gateway.cmd`, `openclaw.json`, and the runtime contract outside Git.
2. Generate a dry-run-default restore script and prove its hashes/preflight before mutation.
3. Reinstall through the approved active CLI with `gateway install --force --runtime node`.
4. Verify `openclaw.json` did not change unexpectedly.
5. Prove the generated command uses system Node plus the approved runtime's `dist\index.js`.
6. Resolve any port competitor before lifecycle testing; for ClawX, back up settings and keep `gatewayAutoStart=false`.
7. Prove stop, start, restart, listener PID/command line, and gateway health.
8. Relaunch optional UI surfaces and prove they do not retake the port.
9. Run the stale-runtime cleanup gate in dry-run mode, take a fresh exact-artifact backup, then delete only enumerated artifacts.
10. Run the complete verifier with stale-runtime absence required.

**Example:** `scripts/openclaw/backup-openclaw-gateway-service.ps1`, `migrate-openclaw-gateway-service.ps1`, and `disable-clawx-embedded-gateway-autostart.ps1`.

**Caveats:** The CLI entrypoint (`openclaw.mjs`) and service entrypoint (`dist\index.js`) are intentionally different. Endpoint health without listener-process ownership is insufficient.
