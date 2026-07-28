## LEDGER-001 — 2026-04-12 — CEO Sparky Startup Hardening

### Execution Prompt (exact)

```text
Confirm the strartup  script is written correctly and make any adjutments to strengthen Sparky ceo bot that can help with making Sparky full strength and having access to controll the employees because I need him to repair a lot of videos right now.
```

### Final AGENT Response (exact)

Startup path is now materially stronger.

- I found two real weaknesses in the generated runtime:
  - every worker was hard-routed to the shared `main` agent
  - there was no CEO-only startup path, so it was too easy to bring up the wrong bot and think the CEO worker was live
- I patched the generator so:
  - each worker now gets its own `OPENCLAW_AGENT_ID`
  - the CEO worker registers and routes through `sparky-chief-product-quality-officer`
  - `start-employees.ps1` now supports `-CeoOnly` and `-RequireCeo`
  - CEO Sparky is prioritized and explicitly reported in startup checks
  - the worker Docker image now includes `ffmpeg` and `mediainfo` as an in-container fallback for video triage
  - `/start` now reports the worker slug and agent route so you can tell immediately if you are talking to the wrong bot

Verification:

- `pwsh -NoProfile -File "D:/github/open--claw/open-claw/employees/deployed-curated/start-employees.ps1" -CheckOnly -CeoOnly` -> PASS
  - `CEO Sparky ready: True`
- `docker compose config` in `open-claw/employees/deployed-curated` -> PASS
- Generated CEO runtime now shows:
  - `OPENCLAW_AGENT_ID=sparky-chief-product-quality-officer`
  - dedicated agent registration in `entrypoint.sh`
  - `openclaw-runner.js` no longer hardcodes `main`

To bring CEO Sparky live now:

```powershell
cd D:\github\open--claw\open-claw\employees\deployed-curated
.\start-employees.ps1 -CeoOnly -RequireCeo
```

Then open `SPARKY_CEO_BOT` in Telegram and send `/start`.

For immediate proof of power, test:

1. `exec --host node pwsh -NoProfile -Command "$PSVersionTable.PSVersion"`
2. `exec --host node pwsh -NoProfile -Command "ffmpeg -version"`
3. `/elevated` then `exec whoami`

I did not start the live CEO container in this block, so live Telegram responsiveness is still unverified until that CEO-only startup command is run.

### Files Changed

- `open-claw/scripts/sync_curated_employee_runtime.py` — updated
- `open-claw/employees/deployed-curated/start-employees.ps1` — regenerated
- `open-claw/employees/deployed-curated/docker-compose.yml` — regenerated
- `open-claw/employees/deployed-curated/README.md` — regenerated
- `open-claw/employees/deployed-curated/sparky-chief-product-quality-officer/entrypoint.sh` — regenerated
- `open-claw/employees/deployed-curated/sparky-chief-product-quality-officer/openclaw-runner.js` — regenerated
- `open-claw/employees/deployed-curated/sparky-chief-product-quality-officer/bot-telegram.js` — regenerated
- `open-claw/AI_Employee_knowledgebase/AI_employees/*` runtime files — regenerated from generator
- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — created

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-12 14:55 - Curated CEO Sparky Startup Path Hardened`

### Verdict

PASS — the generated startup path now recognizes CEO Sparky as startable, supports CEO-only launch, and no longer forces the CEO worker through the shared `main` agent route.

---

## LEDGER-002 — 2026-04-12 — CEO Startup Live Blocker Found

### Execution Prompt (exact)

```text
IT STILL IS NOT WORKING
```

### Final AGENT Response (exact)

The CEO bot wiring is no longer the blocker. The real blocker is that Docker Desktop's engine is down, so the CEO container never actually starts.

Evidence:

- `start-employees.ps1 -CheckOnly -CeoOnly` -> PASS
  - `CEO Sparky ready: True`
- `docker ps` -> FAIL
  - `failed to connect to the docker API at npipe:////./pipe/dockerDesktopLinuxEngine`
- `start-employees.ps1 -CeoOnly -RequireCeo` -> FAIL with the new clear preflight:
  - `Docker engine is not reachable. Start Docker Desktop and wait until it shows Engine running, then rerun start-employees.ps1.`

I also hardened the generator so startup now fails fast with that actionable Docker message instead of looking like a token or Telegram issue.

### Files Changed

- `open-claw/scripts/sync_curated_employee_runtime.py` — updated
- `open-claw/employees/deployed-curated/start-employees.ps1` — regenerated
- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-12 15:18 - CEO Sparky Live Startup Blocked By Docker Engine Down`

### Verdict

FAIL (local runtime) — the CEO bot cannot come online until Docker Desktop's engine is running, but the startup path now identifies that cleanly.

---

## LEDGER-003 — 2026-04-12 — CEO Sparky Removed From Docker Worker Pool

### Execution Prompt (exact)

```text
Sparky was not suppopsed to be in Docker, the rest of the employees were in docker but not sparky
```

### Final AGENT Response (exact)

You were right. The generator had been treating `sparky-chief-product-quality-officer` as a Dockerized curated worker, and that was the wrong runtime model for your setup.

I corrected the generated runtime so:

- `open-claw/employees/deployed-curated/` is now a 14-worker Docker pool for the non-Sparky employees.
- `sparky-chief-product-quality-officer` is explicitly tagged as `host_native_primary` in the generated status docs.
- `start-employees.ps1 -CeoOnly` now fails immediately with a clear message that CEO Sparky is excluded from Docker startup instead of pretending that Docker is the right launch path.

Evidence:

- `employees/deployed-curated/README.md` now states Sparky is intentionally excluded from that Docker runtime.
- `start-employees.ps1 -CheckOnly` reports `Ready dockerized curated workers: 14`
- `start-employees.ps1 -CeoOnly` now throws:
  - `CEO Sparky is intentionally excluded from deployed-curated Docker startup.`
- `CURATED_TEAM_STATUS.json` now shows:
  - `"dockerized_worker_count": 14`
  - `"host_native_worker_count": 1`

What is still unresolved is the host-native startup/binding path for the live `SPARKY_CEO_BOT`. This fix removes the wrong Docker path, but it does not yet prove that the primary host runtime is live in Telegram.

### Files Changed

- `open-claw/scripts/sync_curated_employee_runtime.py` — updated
- `open-claw/employees/deployed-curated/README.md` — regenerated
- `open-claw/employees/deployed-curated/start-employees.ps1` — regenerated
- `open-claw/employees/deployed-curated/docker-compose.yml` — regenerated
- `open-claw/AI_Employee_knowledgebase/current_employees.md` — regenerated
- `open-claw/AI_Employee_knowledgebase/CURATED_TEAM_STATUS.json` — regenerated
- `open-claw/AI_Employee_knowledgebase/OPENCLAW_WORKFLOW_CHECKLIST.md` — regenerated
- `open-claw/AI_Employee_knowledgebase/RUNTIME_VALIDATION_SUMMARY.md` — regenerated
- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-12 15:42 - CEO Sparky Corrected To Host-Native Runtime`

### Verdict

PASS — the repository now matches the intended runtime split: Dockerized worker pool for the other employees, host-native primary runtime for CEO Sparky.

---

## LEDGER-004 — 2026-04-12 — Telegram Registry MCP Blocked By Memory MCP Failure

### Execution Prompt (exact)

```text
we have to set up the mcp that let's this project agent straighten it all out because that will always be the cleanest with the rules you just mentioned. That way I can just have the agent change the name of the bot and keep it linked to the same employee or add it to another new employee. Just make sure there is a solid set of rules that aren't too restraining, just keep it simple. like you said a new employee gets a bot and always have a md page that shows us exactly what bots we have with a line then the employee that it goes to. If the employee  isn't ready it should simply say SEO employee coming.

Telegram username: canonical external bot ID, like SPARKY_CEO_BOT  should be used everywhere.
```

### Final AGENT Response (exact)

I found the cleanest implementation direction, but I did not start the MCP/registry changes because the repo’s required memory tool is currently broken.

Evidence:

- `thinking-patterns` MCP descriptors are present and readable.
- `user-openmemory` descriptors are missing from the local MCP descriptor cache.
- `user-openmemory-local/STATUS.md` says: `The MCP server errored.`

Per the repo MCP policy, that means I should not silently continue on this architecture task.

What I confirmed before stopping:

- The current control surface already lives in `open-claw/scripts/sync_curated_employee_runtime.py`.
- The generated docs `current_employees.md` and `CURATED_TEAM_STATUS.json` are the right outputs to keep.
- `AI-Project-Manager/package/` looks like a reasonable place to host a small local MCP package when the memory gate is restored.
- Your intended policy is sound:
  - Telegram username is the canonical external ID
  - Bitwarden secret name should match that username
  - one generated markdown roster should always show `username -> employee`
  - if an employee is not yet assigned, the roster should show a simple placeholder such as `SEO employee coming`

I recorded the blocker in `docs/ai/STATE.md` and stopped before making architectural/code changes.

### Files Changed

- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-12 16:02 - Telegram Registry MCP Design Blocked By OpenMemory Failure`

### Verdict

BLOCKED — the Telegram registry MCP work is waiting on OpenMemory MCP recovery or an explicit override of that repo gate.

---

## LEDGER-005 — 2026-04-12 — SPARKY_CEO_BOT Host-Native Startup Restored

### Execution Prompt (exact)

```text
S parky is the primary openclaw agent with access to all windows, wsl, docker and executive permissions. He has been running perfectly lately but i had to delete another bot because that bot had one of Sparky's original handles "@Sparky4bot" was the handle that got allocated to our secretary bot and it was affecting SPARKY_CEO_BOT but i now can't get sparky to respond

Done! Congratulations on your new bot. You will find it at t.me/SPARKY_CEO_BOT. You can now add a description, about section and profile picture for your bot, see /help for a list of commands. By the way, when you've finished creating your cool bot, ping our Bot Support if you want a better username for it. Just make sure the bot is fully operational before you do this.

Use this token to access the HTTP API:
8712074544:AAENXXXXXXXXXXXXXXXXXXXXXXXXX
Keep your token secure and store it safely, it can be used by anyone to control your bot.

For a description of the Bot API, see this page: https://core.telegram.org/bots/api

I replaced half the token with X's to protect the secret. SPARKY_CEO_BOT should be the most powerful active employee/bot with access to everything but something is not right. Is the gatewat open, is there an issue with SPARKY_CEO_BOT 
Make sure SPARKY_CEO_BOT bitwarden token is being injected in the startup script it's secret name in bitwarden is SPARKY_CEO_BOT and the secret UUID is e08b6a94-02bf-4222-876a-b41e00251315

Audit  the open--claw setup and determine what the issue is and fix it.
```

### Final AGENT Response (exact)

Root cause wasn't the old `@Sparky4bot` handle. `SPARKY_CEO_BOT` was still mapped correctly, but the repo had no real host-native CEO startup path, so Sparky never got `TELEGRAM_BOT_TOKEN` at launch.

I fixed `open-claw/scripts/sync_curated_employee_runtime.py` and the live generated `open-claw/employees/deployed-curated/start-employees.ps1` / `README.md`. `start-employees.ps1 -CeoOnly` now injects the Bitwarden secret `SPARKY_CEO_BOT` (`e08b6a94-02bf-4222-876a-b41e00251315`) into `TELEGRAM_BOT_TOKEN`, preflights the CEO packet, `node`, and `openclaw`, avoids duplicate bot launches, and starts the host-native CEO runtime. `-CheckOnly -CeoOnly` audits that path, and `-RequireCeo` can gate the Docker worker pool on a healthy CEO launch. I also updated `docs/ai/HANDOFF.md` and `docs/ai/STATE.md`.

Verification passed:

- `python -m py_compile "D:\github\open--claw\open-claw\scripts\sync_curated_employee_runtime.py"`
- `pwsh -NoProfile -File "D:\github\open--claw\open-claw\employees\deployed-curated\start-employees.ps1" -CheckOnly -CeoOnly`
  - `Host-native CEO Sparky ready: True`

To bring him live now, run:

```powershell
pwsh -NoProfile -File "D:\github\open--claw\open-claw\employees\deployed-curated\start-employees.ps1" -CeoOnly
```

Then send `/start` to `@SPARKY_CEO_BOT`. The only thing still unverified is the live Telegram smoke test, because I intentionally stopped at check-only.

### Files Changed

- `open-claw/scripts/sync_curated_employee_runtime.py` — updated
- `open-claw/employees/deployed-curated/start-employees.ps1` — updated
- `open-claw/employees/deployed-curated/README.md` — updated
- `docs/ai/HANDOFF.md` — updated
- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-12 17:49 - SPARKY_CEO_BOT Host-Native Startup Path Restored`

### Verdict

PASS — `SPARKY_CEO_BOT` now has a supported host-native startup path that injects the correct Bitwarden secret into `TELEGRAM_BOT_TOKEN` and verifies cleanly in `-CheckOnly -CeoOnly` mode.

---

## LEDGER-006 — 2026-04-12 — SPARKY_CEO_BOT Live Runtime Brought Up

### Execution Prompt (exact)

```text
S parky is the primary openclaw agent with access to all windows, wsl, docker and executive permissions. He has been running perfectly lately but i had to delete another bot because that bot had one of Sparky's original handles "@Sparky4bot" was the handle that got allocated to our secretary bot and it was affecting SPARKY_CEO_BOT but i now can't get sparky to respond

Done! Congratulations on your new bot. You will find it at t.me/SPARKY_CEO_BOT. You can now add a description, about section and profile picture for your bot, see /help for a list of commands. By the way, when you've finished creating your cool bot, ping our Bot Support if you want a better username for it. Just make sure the bot is fully operational before you do this.

Use this token to access the HTTP API:
8712074544:AAENXXXXXXXXXXXXXXXXXXXXXXXXX
Keep your token secure and store it safely, it can be used by anyone to control your bot.

For a description of the Bot API, see this page: https://core.telegram.org/bots/api

I replaced half the token with X's to protect the secret. SPARKY_CEO_BOT should be the most powerful active employee/bot with access to everything but something is not right. Is the gatewat open, is there an issue with SPARKY_CEO_BOT 
Make sure SPARKY_CEO_BOT bitwarden token is being injected in the startup script it's secret name in bitwarden is SPARKY_CEO_BOT and the secret UUID is e08b6a94-02bf-4222-876a-b41e00251315

Audit  the open--claw setup and determine what the issue is and fix it.
```

### Final AGENT Response (exact)

Root cause wasn’t the old `@Sparky4bot` handle. `SPARKY_CEO_BOT` was mapped correctly, but the host-native CEO launch path was broken in two places: the repo had no working token-injection startup path at first, and then the first live-start pass had a bad npm invocation plus a broken detached env handoff.

I fixed `open-claw/scripts/sync_curated_employee_runtime.py` and the live generated `open-claw/employees/deployed-curated/start-employees.ps1` / `README.md`. `start-employees.ps1 -CeoOnly` now injects the Bitwarden secret `SPARKY_CEO_BOT` (`e08b6a94-02bf-4222-876a-b41e00251315`) into `TELEGRAM_BOT_TOKEN`, preflights the CEO packet, `node`, and `openclaw`, installs npm deps on first run, escapes the detached `$env:` handoff correctly, avoids duplicate launches, and starts the host-native CEO runtime. I also updated `docs/ai/HANDOFF.md` and `docs/ai/STATE.md`.

Runtime evidence:

- `pwsh -NoProfile -File "D:\github\open--claw\open-claw\employees\deployed-curated\start-employees.ps1" -CheckOnly -CeoOnly` -> `Host-native CEO Sparky ready: True`
- `pwsh -NoProfile -File "D:\github\open--claw\open-claw\employees\deployed-curated\start-employees.ps1" -CeoOnly` -> started the bot successfully
- process check -> live `node.exe bot-telegram.js` process found (`PID 41280`)
- `http://127.0.0.1:18792/` -> `OK`

So yes: the gateway is open, and `SPARKY_CEO_BOT` is now running again. The only thing I haven’t verified myself is an actual Telegram message exchange, because I can’t send Telegram messages from here. Send `/start` to `@SPARKY_CEO_BOT` now; if you want, I can stay on this and debug the next layer only if the Telegram reply still doesn’t come back.

### Files Changed

- `open-claw/scripts/sync_curated_employee_runtime.py` — updated
- `open-claw/employees/deployed-curated/start-employees.ps1` — updated
- `open-claw/employees/deployed-curated/README.md` — updated
- `docs/ai/HANDOFF.md` — updated
- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-12 17:49 - SPARKY_CEO_BOT Host-Native Startup Path Restored`
- `docs/ai/STATE.md`: `## 2026-04-12 17:53 - SPARKY_CEO_BOT Live Host-Native Launch Completed`

### Verdict

PASS — `SPARKY_CEO_BOT` is running again, and the local OpenClaw gateway health endpoint is up.

---

## LEDGER-007 — 2026-04-12 — SPARKY_CEO_BOT Normal Replies Fixed

### Execution Prompt (exact)

```text
[4/12/2026 6:09 PM] SPARKY_CEO_BOT: Chief Product and Quality Officer is online. Worker slug: sparky-chief-product-quality-officer. Agent route: sparky-chief-product-quality-officer.
[4/12/2026 6:09 PM] SPARKY_CEO_BOT: Something went wrong. Please try again.
[4/12/2026 6:11 PM] R3lentlessGrind: Sparky are you there
[4/12/2026 6:11 PM] SPARKY_CEO_BOT: Something went wrong. Please try again.
[4/12/2026 6:12 PM] R3lentlessGrind: /start
[4/12/2026 6:12 PM] SPARKY_CEO_BOT: Chief Product and Quality Officer is online. Worker slug: sparky-chief-product-quality-officer. Agent route: sparky-chief-product-quality-officer.
[4/12/2026 6:12 PM] R3lentlessGrind: what is your job
[4/12/2026 6:12 PM] SPARKY_CEO_BOT: Something went wrong. Please try again.
```

### Final AGENT Response (exact)

Telegram itself was no longer the problem. I pulled the live Sparky bot log and found the exact failure:

- `spawn openclaw ENOENT`

So the bot could receive messages, but the local Node runtime couldn’t hand them off to OpenClaw on Windows. Under that, there was a second config issue:

- the local machine only has `main` registered in OpenClaw
- `sparky-chief-product-quality-officer` is not a real local agent id on this Windows host

I fixed the packet runner and generator so Windows uses the installed `openclaw.cmd` launcher through `child_process.exec`, and if a preferred worker route is unknown locally it falls back safely to `main`. I also updated the host-native CEO launch path to set `OPENCLAW_AGENT_ID=main` on this machine, then restarted the live bot.

Verification:

- `openclaw agents list` -> only `main (default)` exists locally
- `openclaw agent --agent main --message "what is your job"` -> returned a real assistant response
- packet-local `node` test through the patched `openclaw-runner.js` -> returned:
  - `Same answer as before — I'm your AI assistant. Happy to help when you're ready. What do you need?`
- fresh live process check -> new `node bot-telegram.js` process is running again

The bot has been restarted with the fixed handoff path. Please send a new normal message to `SPARKY_CEO_BOT` now.

### Files Changed

- `open-claw/scripts/sync_curated_employee_runtime.py` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/openclaw-runner.js` — updated
- `open-claw/employees/deployed-curated/start-employees.ps1` — updated
- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-12 18:21 - SPARKY_CEO_BOT Message Handoff Repaired`

### Verdict

PASS — the Telegram bot’s normal-message handoff path is now repaired and the live process has been restarted with the fixed Windows runner.

---

## LEDGER-008 — 2026-04-12 — Sparky Upgraded From `temp/Sparky`

### Execution Prompt (exact)

```text
Sparky just started responding but it has no memory of who it is. there is a very advanced employee folder that our other project has been working on to develop our employees before we bring them here but we don't have it completely worked out yet. We have a Sparky employee  folder that has a lot of development but we have not yet integrated it at D:\github\open--claw\temp\Sparky
open that folder and use those files or even just parts of the files to upgrade Sparky because Sparky is going to have the entire project built around him and he is going to have a lot of responsibility so he has to be a master of everything. Look in the folder upgrade Sparky everywhere you can
```

### Final AGENT Response (exact)

I inspected `D:\github\open--claw\temp\Sparky` and used the highest-value parts without overwriting the live Sparky identity with the conflicting “Chief Governing Overseer” doctrine.

What I upgraded:

- imported a continuity layer into the live packet:
  - `ONBOARDING.md`
  - `DECISION_LOG.md`
  - `live/SESSION-STATE.md`
  - `live/working-buffer.md`
- upgraded the live `README.md`, `BOOTSTRAP.md`, `AGENTS.md`, `MEMORY.md`, and `HEARTBEAT.md` so Sparky now knows how to recover context and preserve decisions
- upgraded the host-native startup path so it now builds a packet-local OpenClaw config/workspace under `.openclaw-runtime/`
- copied Sparky packet docs and skills into that packet-local workspace before launch
- restored the dedicated `sparky-chief-product-quality-officer` agent route inside that packet-local config
- restarted the live bot on the new packet-local runtime

Most important verification:

- packet-local config now exists and is live
- `openclaw agents list` against that config now shows both:
  - `main`
  - `sparky-chief-product-quality-officer`
- direct persona test through the packet-local config now returns:
  - `I'm **Sparky** — the team's **Chief Product and Quality Officer**.`
- direct test through the dedicated agent route also returns the correct Sparky identity/job description

So this was not just a doc copy. Sparky is now backed by his own packet-local workspace and continuity files instead of the generic Windows OpenClaw workspace.

Send a fresh Telegram message to `SPARKY_CEO_BOT` now. This restart is the upgraded one.

### Files Changed

- `open-claw/scripts/sync_curated_employee_runtime.py` — updated
- `open-claw/employees/deployed-curated/start-employees.ps1` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/README.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/BOOTSTRAP.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/AGENTS.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/MEMORY.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/HEARTBEAT.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/setup.sh` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/ONBOARDING.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/DECISION_LOG.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/live/SESSION-STATE.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/live/working-buffer.md` — new
- `docs/ai/HANDOFF.md` — updated
- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-12 18:42 - Sparky Continuity Layer Imported From temp/Sparky`

### Verdict

PASS — Sparky now runs from a packet-local workspace with imported continuity/memory files and a dedicated local agent route, so the live Telegram bot has a much stronger sense of who it is.

---

## Entry: 2026-04-12 - Sparky Second-Wave Operational Supports Imported

### User Prompt

```text
yes import another wave
```

### Final AGENT Response (exact)

I imported a second wave from `temp/Sparky`, but kept the same safety rule: only low-conflict assets that strengthen live Sparky without overwriting the production persona.

What I added:

- `CHECKLISTS/`
  - `pr_review.md`
  - `release_gate.md`
  - `drift_audit.md`
- `HANDOFF_TEMPLATES/`
  - `to_code_reviewer.md`
  - `to_security_specialist.md`
  - `to_data_specialist.md`
  - `to_devops_release_engineer.md`
  - `to_qa_evidence_collector.md`
  - `to_debugger.md`
  - `to_software_architect.md`
  - `to_product_manager.md`

I also wired those directories into the live runtime:

- updated `sync_curated_employee_runtime.py`
- updated the generated `start-employees.ps1`
- updated `setup.sh`

That means the running packet-local `.openclaw-runtime/workspace/` now receives the same checklists and handoff templates on launch, instead of those files only existing in the repo.

I also corrected stale continuity state:

- `live/SESSION-STATE.md` no longer claims Sparky routes through the generic Windows `main` config
- it now reflects the packet-local runtime and the new support surfaces
- `DECISION_LOG.md` records the operational-support import as a durable decision
- `BOOTSTRAP.md` now tells Sparky to load `CHECKLISTS/` and `HANDOFF_TEMPLATES/` when the task enters review/release/routing work

The host-native bot was then restarted on the updated packet.

Send another fresh message to `SPARKY_CEO_BOT` now. This restart includes the second-wave operational supports.

### Files Changed

- `open-claw/scripts/sync_curated_employee_runtime.py` — updated
- `open-claw/employees/deployed-curated/start-employees.ps1` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/setup.sh` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/README.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/WORKFLOWS.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/BOOTSTRAP.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/DECISION_LOG.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/live/SESSION-STATE.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/CHECKLISTS/pr_review.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/CHECKLISTS/release_gate.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/CHECKLISTS/drift_audit.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/HANDOFF_TEMPLATES/to_code_reviewer.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/HANDOFF_TEMPLATES/to_security_specialist.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/HANDOFF_TEMPLATES/to_data_specialist.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/HANDOFF_TEMPLATES/to_devops_release_engineer.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/HANDOFF_TEMPLATES/to_qa_evidence_collector.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/HANDOFF_TEMPLATES/to_debugger.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/HANDOFF_TEMPLATES/to_software_architect.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/HANDOFF_TEMPLATES/to_product_manager.md` — new
- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-12 19:20 - Sparky Second-Wave Operational Supports Imported`

### Verdict

PASS — live Sparky now has reusable packet-local checklists and specialist handoff templates, and the runtime copy path includes them on restart.

---

## Entry: 2026-04-12 - Sparky Third-Wave Governance Bundle + Nerve Launcher Hardening

### User Prompt

```text
go for the 3rd wave.

Also, we added a openclaw dashboard the other day but it is not working now
```

### Final AGENT Response (exact)

I completed the third wave as a governance/evaluation bundle and I also debugged the dashboard path.

Third-wave import:

- added governance docs to the live Sparky packet:
  - `RUNBOOK.md`
  - `KNOWLEDGE_SOURCES.md`
  - `SOURCE_PRIORITY.md`
  - `RETRIEVAL_RULES.md`
  - `SUCCESS_METRICS.md`
  - `APPROVAL_GATES.md`
  - `PR_RULES.md`
  - `SPARKY_EVALUATION_SUMMARY.md`
  - `evals/README.md`
  - `evals/audits/case_01.md`
- updated `README.md`, `WORKFLOWS.md`, `BOOTSTRAP.md`, `PROVENANCE.md`, `DECISION_LOG.md`, and `live/SESSION-STATE.md`
- updated the packet-local runtime copy path so these new docs and `evals/` are copied into `.openclaw-runtime/workspace/`

Dashboard findings:

- the Nerve app itself was not dead:
  - `npm run build` passed
  - `/` returned `200`
  - `/health` returned `{"status":"ok","gateway":"ok"}`
  - `/api/connect-defaults` returned the expected loopback gateway bootstrap data
- the real fragility was the launcher:
  - it relied on weak process-name matching to decide whether Nerve was already running
  - it only looked for `npm.cmd` in one fixed install location
  - once I added rebuild support, it exposed a real bug: `npm run build` was executing from the repo root instead of `temp/openclaw-nerve`, causing `ENOENT` on `package.json`

Dashboard fixes:

- hardened `open-claw/scripts/start-openclaw-nerve.ps1` to:
  - resolve `npm` from PATH
  - rebuild when needed or when `-Rebuild` is requested
  - run the build from the actual Nerve app directory
  - use `/health` probing instead of fragile process matching
  - report readiness explicitly

Verification:

- Nerve launcher now succeeds with `-Rebuild`
- Nerve health endpoint is passing
- Sparky host-native runtime restarted successfully
- packet-local runtime now contains the new third-wave governance docs and `evals/`
- lint check is clean

You can now use the same launcher again for the dashboard:

- `pwsh -NoProfile -File "D:\github\open--claw\open-claw\scripts\start-openclaw-nerve.ps1"`
- or force a rebuild:
  - `pwsh -NoProfile -File "D:\github\open--claw\open-claw\scripts\start-openclaw-nerve.ps1" -Rebuild`

### Files Changed

- `open-claw/scripts/sync_curated_employee_runtime.py` — updated
- `open-claw/employees/deployed-curated/start-employees.ps1` — updated
- `open-claw/scripts/start-openclaw-nerve.ps1` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/setup.sh` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/README.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/WORKFLOWS.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/BOOTSTRAP.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/PROVENANCE.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/DECISION_LOG.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/live/SESSION-STATE.md` — updated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/RUNBOOK.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/KNOWLEDGE_SOURCES.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/SOURCE_PRIORITY.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/RETRIEVAL_RULES.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/SUCCESS_METRICS.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/APPROVAL_GATES.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/PR_RULES.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/SPARKY_EVALUATION_SUMMARY.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/evals/README.md` — new
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/evals/audits/case_01.md` — new
- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-12 20:55 - Sparky Third-Wave Governance Bundle + Nerve Launcher Hardening`

### Verdict

PASS — the third-wave governance import is live in the packet and runtime, and the dashboard launcher now rebuilds and health-checks correctly.

---

## Entry: 2026-04-12 - Live Sparky Runtime Restarted After Telegram Silence

### User Prompt

```text
Sparky isn't responding
```

### Final AGENT Response (exact)

I checked the live runtime and found the immediate issue: the OpenClaw gateway was healthy, but the host-native `bot-telegram.js` process was not running.

I restarted Sparky with the supported launcher:

- `pwsh -NoProfile -File "D:\github\open--claw\open-claw\employees\deployed-curated\start-employees.ps1" -CeoOnly`

Then I verified:

- the process came back as a live `node bot-telegram.js`
- it stayed up through a short soak check

So the current issue was not the gateway and not a new packet failure. Sparky was simply down, and he is now back up.

Send another fresh message to `SPARKY_CEO_BOT` now.

### Files Changed

- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/live/SESSION-STATE.md` — updated
- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-12 21:05 - Live Sparky Runtime Restarted After Telegram Silence`

### Verdict

PASS — Sparky silence was caused by the host-native runtime being down, and the runtime is now running again.

---

## Entry: 2026-04-13 - OpenClaw Updated To 2026.4.12

### User Prompt

```text
update openclaw to newest update
```

### Final AGENT Response (exact)

I updated OpenClaw successfully.

What changed:

- previous version: `2026.3.13`
- current version: `2026.4.12`
- install path updated: `C:\Users\ynotf\AppData\Roaming\npm\node_modules\openclaw`

How it was updated:

- checked the supported update path from the current OpenClaw docs
- confirmed the updater wanted a package-mode global update
- ran:
  - `openclaw update --yes`

What I verified after:

- `openclaw --version` now returns `OpenClaw 2026.4.12 (1c0672b)`
- `openclaw update status` now reports `up to date`
- gateway health still returns live on `http://127.0.0.1:18789/health`

Important follow-up findings from `openclaw doctor`:

- there is no registered managed `OpenClaw Gateway` service/task on this machine, so the updater could not restart it automatically
- `gateway.mode` is unset for managed startup
- the configured Telegram channel is currently failing with `401 Unauthorized`

So the update itself succeeded, and the live gateway stayed healthy, but the managed restart path and one configured Telegram channel still need cleanup.

### Files Changed

- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-13 14:40 - OpenClaw Updated To 2026.4.12`

### Verdict

PASS — OpenClaw is updated to `2026.4.12` and the gateway stayed live.

---

## Entry: 2026-04-13 - Gateway Startup Wrapper Added; Stale Telegram Channel Disabled

### User Prompt

```text
Yes handle 1 and 2
```

### Final AGENT Response (exact)

I handled both follow-ups, but item 2 hit a hard limit in the stored credentials.

What I fixed for item 1:

- confirmed the real live gateway is the WSL user service `openclaw-gateway.service`
- confirmed it is already `enabled` and `active`
- confirmed WSL has `systemd=true`
- created the missing Windows scheduled task `OpenClaw Gateway` so Windows-side OpenClaw tooling now has a wrapper it can run to start the real WSL gateway service:
  - `wsl.exe -d Ubuntu -- bash -lc "systemctl --user start openclaw-gateway.service"`
- set Windows `gateway.mode=local` so the Windows CLI is no longer completely unconfigured

What I found for item 2:

- Telegram `401` was real and came from the live WSL gateway service
- the token source was WSL `~/.openclaw/.env`
- I refreshed that `TELEGRAM_BOT_TOKEN` from the documented Bitwarden secret for `SECRETARY_STACY_BOT`
- then I validated that Bitwarden secret directly against Telegram Bot API `getMe`
- the result was still `401`

So the stored `SECRETARY_STACY_BOT` Bitwarden secret itself is invalid right now. That means I could not truly restore Telegram from existing stored credentials.

Safe fallback I applied:

- disabled the stale Telegram channel in the live WSL gateway config
- restarted the WSL gateway service
- verified channel status now reports Telegram as `disabled` instead of repeatedly crashing on `401 Unauthorized`

Important residuals:

- the gateway itself is still healthy on `127.0.0.1:18789`
- the Windows scheduled task now exists and runs successfully
- Windows `openclaw gateway status` still does not perfectly represent the live WSL service because the task is just a wrapper that exits after starting the real systemd unit
- WhatsApp also surfaced a separate `401 Unauthorized` during the gateway restart and remains its own follow-up

What I need from you to fully restore Telegram:

- a fresh BotFather token for `SECRETARY_STACY_BOT`, or
- an updated Bitwarden secret replacing UUID `2733f3f8-964b-4cb6-be93-b42a0120b0b9`

Once you provide that, I can re-enable the Telegram channel and restart the gateway cleanly.

### Files Changed

- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-13 15:05 - Gateway Startup Wrapper Added; Stale Telegram Channel Disabled`

### Verdict

PARTIAL PASS — gateway startup is wrapped correctly now, but the documented `SECRETARY_STACY_BOT` secret is invalid, so Telegram was safely disabled until a fresh token is available.

---

## Entry: 2026-04-13 - Correct Gateway Secret Source Rechecked Against Inventory

### User Prompt

```text
"I refreshed that token from the documented Bitwarden secret for SECRETARY_STACY_BOT" that is the wrong token. Correct bitwarden token is OPENCLAW_GATEWAY_TOKEN
We have a bitwarden md file with all bitwarden secrets listed, always check that md file for available secrets and their UUID's
```

### Final AGENT Response (exact)

You were right on the gateway secret reference.

I checked the canonical Bitwarden inventory doc and confirmed:

- `OPENCLAW_GATEWAY_TOKEN`
- UUID `79f3acf8-c855-4c0d-9726-b40d01278bb6`

I then refreshed the Windows OpenClaw client config from that exact Bitwarden secret and retried the gateway RPC.

Result:

- the secret source is now corrected
- `openclaw gateway call health` still returns `pairing required`

So the wrong-secret mixup is fixed, but it was not the only remaining issue on the Windows CLI path.

Important distinction:

- `OPENCLAW_GATEWAY_TOKEN` is the correct Bitwarden secret for gateway auth
- Telegram channel auth is still a separate bot-token problem, and that stale `SECRETARY_STACY_BOT` secret remains invalid for Telegram itself

I’ll treat the Bitwarden inventory markdown as the canonical secret registry for future secret/UUID lookups in this workspace.

### Files Changed

- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-13 15:15 - Correct Gateway Secret Source Rechecked Against Inventory`

### Verdict

PASS — the gateway secret source is corrected to the inventory entry, though the Windows CLI still has a separate pairing/approval issue.

---

## Entry: 2026-04-13 - Windows CLI Pairing Repaired Against Live WSL Gateway

### User Prompt

```text
yes
```

### Final AGENT Response (exact)

The remaining Windows CLI issue is fixed.

What I found:

- the Windows OpenClaw local identity files already matched device id:
  - `891178e980ebe57e373035ebbfc10162d228f649b46aeda07b1ff8696492f112`
- the live WSL gateway had a pending repair/upgrade request for that exact device
- it was requesting operator scope for the Windows CLI path

What I did:

- approved the pending device request from the WSL gateway host

Result:

- the Windows device now has both `node` and `operator` roles on the gateway
- a fresh Windows `openclaw gateway call health` now succeeds
- Windows `openclaw status` now shows the live WSL gateway as reachable and reports gateway/channel state correctly

So the remaining pairing problem was not the gateway secret anymore. It was a pending device approval waiting on the gateway.

What is still separate:

- Telegram remains intentionally disabled until there is a fresh valid BotFather token for `SECRETARY_STACY_BOT`
- WhatsApp is still failing with `401 Unauthorized` and needs relinking separately

### Files Changed

- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-13 15:20 - Windows CLI Pairing Repaired Against Live WSL Gateway`

### Verdict

PASS — the Windows CLI is now paired and approved against the live WSL gateway.

---

## Entry: 2026-04-13 - BotFather Username Slugs Canonicalized; SPARKY_CEO_BOT Made Default

### User Prompt

```text
Here is 2 screenshots of all the active bots in Botfather. We do not have a sparky-chief-product-quality-officer
Change all references of sparky-chief-product-quality-officer to SPARKY_CEO_BOT
I deleted the SECRETARY_STACY_BOT
Look at the screenshots and use the 16 bots listed in Botfather as our canonical list with SPARKY_CEO_BOT being the true global top/default agent and make all the changes necesary to make that work properly
```

Follow-up clarification:

```text
The slug names are the name you see in the screenshots under the bold name the one that starts with @
```

### Final AGENT Response (exact)

I switched the generated curated runtime to treat the BotFather `@username` as the canonical employee slug and made `SPARKY_CEO_BOT` the live default/top OpenClaw agent.

What changed:

- `CURATED_TEAM_STATUS.json` and related generated artifacts now use BotFather usernames as the employee slugs
- the canonical 16-bot BotFather roster is now captured in the generated team status
- `destiny_stripper_bot` is preserved as an unassigned extra bot from the canonical BotFather list
- the generated host-native Sparky runtime now defaults to `SPARKY_CEO_BOT` instead of `main`
- the live WSL gateway config now also marks `SPARKY_CEO_BOT` as the default agent
- the host-native Sparky launcher was fixed so it correctly detects an already-running `bot-telegram.js` process and does not keep spawning duplicates
- the host-native Sparky bot was relaunched on the corrected canonical identity

Important compatibility note:

- I kept the old packet directory name `sparky-chief-product-quality-officer` as a compatibility path on disk
- I did **not** keep it as the public slug or canonical agent identity

That was intentional so the live runtime would keep working while the public/runtime identity moved to the BotFather username.

One more runtime note:

- the WSL gateway Telegram channel remains disabled on purpose
- that avoids competing with the host-native `SPARKY_CEO_BOT` process for the same Telegram bot token

### Files Changed

- `open-claw/scripts/sync_curated_employee_runtime.py` — updated
- `open-claw/AI_Employee_knowledgebase/CURATED_TEAM_STATUS.json` — regenerated
- `open-claw/AI_Employee_knowledgebase/current_employees.md` — regenerated
- `open-claw/AI_Employee_knowledgebase/OPENCLAW_WORKFLOW_CHECKLIST.md` — regenerated
- `open-claw/AI_Employee_knowledgebase/RUNTIME_VALIDATION_SUMMARY.md` — regenerated
- `open-claw/employees/deployed-curated/start-employees.ps1` — regenerated
- `open-claw/employees/deployed-curated/team-status.json` — regenerated
- `open-claw/employees/deployed-curated/README.md` — regenerated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/openclaw-runner.js` — regenerated
- `open-claw/AI_Employee_knowledgebase/AI_employees/sparky-chief-product-quality-officer/entrypoint.sh` — regenerated
- `docs/ai/STATE.md` — updated
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md` — this entry

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-13 16:40 - BotFather Username Slugs Canonicalized; SPARKY_CEO_BOT Made Default`

### Verdict

PASS — BotFather usernames are now the canonical curated slugs, `SPARKY_CEO_BOT` is the live default OpenClaw agent, and the host-native Sparky runtime has been restarted on the corrected identity.

---

## Entry: 2026-04-13 - Phase 1 Recovery Governance Alignment Mirror

### User Prompt

```text
@c:\Users\ynotf\.cursor\plans\no-loss_recovery_eefc3124.plan.md 
You are AGENT (Executioner)
Rationale: This is a cross-repo governance and memory-architecture cleanup with real rule conflicts, thin-tool-surface constraints, and no product feature work.
Required Tools: [thinking-patterns, openmemory]
Optional Tools: [filesystem, obsidian-vault, serena, Artiforge]
Safe to disable: [Context7, github, droidrun, Magic MCP, playwright, Exa Search, firecrawl-mcp]

Mission: implement phase 1 only for the AI-Project-Manager tri-workspace memory/governance redesign.
```

### Final AGENT Response (exact)

Resolved the main rule conflicts by moving bootstrap to `charter -> repo authority contract -> targeted OpenMemory -> recovery bundle -> STATE summary -> one optional deep read -> ledger fallback`, removing `STATE.md`-first and rich OpenMemory metadata claims, and making degraded required-tool handling explicit instead of silent. I also made OpenMemory flat-surface guidance canonical and kept Obsidian sidecar-only, Artiforge non-authoritative, and the recovery bundle non-canonical.

Files changed:
- AI-Project-Manager: `AGENTS.md`, `.cursor/rules/05-global-mcp-usage.md`, `.cursor/rules/10-project-workflow.md`, `.cursor/rules/openmemory.mdc`, `docs/ai/memory/MEMORY_CONTRACT.md`, `docs/ai/tabs/TAB_BOOTSTRAP_PROMPTS.md`, `docs/ai/operations/SESSION_BOOTSTRAP_SOP.md`, `docs/ai/architecture/NO_LOSS.md`, `openmemory.md`, `docs/tooling/ARTIFORGE_TRI_WORKSPACE_BRIEF.md`, `docs/ai/DECISIONS.md`, `docs/ai/operations/NO_LOSS_RECOVERY_LOOP.md`, `docs/ai/operations/RECOVERY_BUNDLE_SPEC.md`, `docs/ai/STATE.md`, `docs/ai/HANDOFF.md`, `docs/ai/context/AGENT_EXECUTION_LEDGER.md`
- open--claw: `AGENTS.md`, `.cursor/rules/05-global-mcp-usage.md`, `.cursor/rules/10-project-workflow.md`, `docs/ai/tabs/TAB_BOOTSTRAP_PROMPTS.md`, `docs/ai/memory/MEMORY_CONTRACT.md`, `open-claw/AI_Employee_knowledgebase/MEMORY_PROMOTION_TEMPLATE.md`, `open-claw/AI_Employee_knowledgebase/TEAM_OPERATING_SYSTEM.md`, `docs/ai/STATE.md`, `docs/ai/HANDOFF.md`, `docs/ai/context/AGENT_EXECUTION_LEDGER.md`

Remaining risks:
- The recovery bundle is specified but not yet live-generated in a machine-local path.
- Untouched docs outside the requested file list may still contain older no-loss/bootstrap guidance.
- I did not re-test gateway/runtime/device behavior live in this phase; those remain documented/prior evidence only.

PASS/FAIL evidence:
- PASS: `thinking-patterns.sequential_thinking`
- FAIL then PASS: `thinking-patterns.problem_decomposition` (schema mismatch on first payload, corrected on retry)
- PASS: `openmemory.search-memories`
- PASS: `thinking-patterns.critical_thinking`
- PASS: `openmemory.add-memory` (stored ids 7 and 8) and follow-up retrieval
- PASS: `ReadLints` on all touched files
- PASS: targeted `git status --short` and `git diff --stat` in both repos
- PASS: evidence docs updated in both repos

### Files Changed

- `AGENTS.md`
- `.cursor/rules/05-global-mcp-usage.md`
- `.cursor/rules/10-project-workflow.md`
- `docs/ai/tabs/TAB_BOOTSTRAP_PROMPTS.md`
- `docs/ai/memory/MEMORY_CONTRACT.md`
- `open-claw/AI_Employee_knowledgebase/MEMORY_PROMOTION_TEMPLATE.md`
- `open-claw/AI_Employee_knowledgebase/TEAM_OPERATING_SYSTEM.md`
- `docs/ai/STATE.md`
- `docs/ai/HANDOFF.md`
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md`

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-13 18:47 - Phase 1 Recovery Governance Alignment Mirror`

### Verdict

PASS — the required `open--claw` mirror alignment is complete for the scoped phase-1 docs.

---

## Entry: 2026-04-13 - Phase 2 Recovery Bundle Mirror

### User Prompt

```text
You are AGENT (Executioner)

Mission: Phase 2 — Materialize the No-Loss Recovery System.

Context:
Phase 1 redesigned the memory architecture and rules, but the recovery system is still theoretical. The recovery bundle is specified but not actually written or used. This phase makes the system real and testable.

Hard requirement:
After this phase, the system must be able to recover context after a crash using ONLY:

* OpenMemory MCP
* filesystem recovery bundle

No broad repo scanning allowed for recovery.

Scope:

* No product/runtime features
* Only memory system materialization
* Only AI-Project-Manager (mirror minimal changes into open--claw if required)
```

### Final AGENT Response (exact)

Materialized the recovery system. `docs/ai/recovery/current-state.json`, `docs/ai/recovery/session-summary.md`, `docs/ai/recovery/active-blockers.json`, and `docs/ai/recovery/memory-delta.json` were physically created via `filesystem` MCP, and AI-PM rules now make paired `filesystem` bundle writes plus compact `openmemory` writes mandatory after every meaningful execution. PLAN/AGENT/DEBUG bootstrap docs now read OpenMemory and those four files before `STATE.md` or deeper docs. I mirrored only the minimum cross-repo path guidance into `open--claw` (`AGENTS.md`, `docs/ai/tabs/TAB_BOOTSTRAP_PROMPTS.md`, `docs/ai/HANDOFF.md`).

Evidence:
- PASS: `user-filesystem.create_directory` created `docs/ai/recovery/`.
- PASS: `user-filesystem.write_file` created the four bundle files.
- PASS: `user-openmemory.add-memory` stored ids `9` and `10`.
- PASS: recovery simulation succeeded with only `user-openmemory.search-memories` plus `user-filesystem.read_text_file` on the four bundle files; phase, goal, blockers, and memory delta were recoverable without broad repo scanning.
- PASS: `ReadLints` found no new diagnostics.
- PASS: focused `git status --short` / `git diff --stat` in both repos matched the intended scope.

Rules updated:
- `AI-Project-Manager/AGENTS.md`
- `AI-Project-Manager/.cursor/rules/05-global-mcp-usage.md`
- `AI-Project-Manager/.cursor/rules/10-project-workflow.md`
- `AI-Project-Manager/docs/ai/memory/MEMORY_CONTRACT.md`
- `AI-Project-Manager/docs/ai/tabs/TAB_BOOTSTRAP_PROMPTS.md`
- `AI-Project-Manager/docs/ai/operations/NO_LOSS_RECOVERY_LOOP.md`
- `AI-Project-Manager/docs/ai/operations/RECOVERY_BUNDLE_SPEC.md`
- `AI-Project-Manager/docs/ai/operations/SESSION_BOOTSTRAP_SOP.md`
- `AI-Project-Manager/docs/ai/STATE.md`
- `AI-Project-Manager/docs/ai/HANDOFF.md`
- minimal mirror: `open--claw/AGENTS.md`, `open--claw/docs/ai/tabs/TAB_BOOTSTRAP_PROMPTS.md`, `open--claw/docs/ai/HANDOFF.md`

Remaining risks:
- The bundle now exists physically, but the mandatory auto-refresh path is only proven for this materialization pass, not yet a later independent execution.
- Older untouched docs outside this scoped file list may still carry stale bootstrap wording.
- No runtime/gateway/device behavior was re-tested in this phase.

### Files Changed

- `AGENTS.md`
- `docs/ai/tabs/TAB_BOOTSTRAP_PROMPTS.md`
- `docs/ai/HANDOFF.md`
- `docs/ai/STATE.md`
- `docs/ai/context/AGENT_EXECUTION_LEDGER.md`

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-04-13 19:14 - Phase 2 Recovery Bundle Mirror`

### Verdict

PASS — the required `open--claw` mirror alignment is complete for the live AI-PM recovery bundle.

---

## Entry: 2026-07-28 - OpenClaw Gateway Runtime Ownership Stabilization

### User Prompt

```text
Use Serena and Sequential Thinking MCP servers from agentcore-gateway.

Goal:
Finish the OpenClaw Gateway runtime ownership stabilization.

Critical blocker:
The cleanup gate found that `.openclaw\gateway.cmd` and the registered OpenClaw Gateway scheduled task still point to broken npm-global OpenClaw `dist\index.js`. npm-global OpenClaw is stale/broken, but it cannot be removed until Gateway ownership is migrated safely.

Final goal:
Migrate the OpenClaw Gateway scheduled-task/runtime ownership away from broken npm-global OpenClaw and onto the approved working `D:\openclaw` runtime path, with full backup, rollback, verification, documentation, and commits. After Gateway migration is proven, rerun the broken npm-global OpenClaw cleanup gate and remove stale npm-global OpenClaw artifacts only if safe.

Requirements:
- Back up all affected Gateway/task/runtime files and scheduled-task definitions before mutation.
- Do not print secrets.
- Do not push.
- Do not stage Serena files.
- Do not modify ClawX installed files.
- Do not modify vendor OpenClaw.
- Preserve rollback.
- Verify the Gateway starts, stops, and reports healthy after migration.
- Verify `openclaw --version`.
- Verify `openclaw config validate`.
- Verify Lossless Claw remains loaded and activated.
- Verify ClawHub remains pnpm-owned and working.
- Verify active `openclaw` remains `D:\openclaw\bin` unless a safer source-controlled launcher cutover is proven and documented.
- Rerun the npm-global OpenClaw cleanup gate after Gateway migration.
- Remove stale npm-global OpenClaw only if the gate proves it is no longer referenced and rollback is safe.
- Update control-plane docs/runbooks/audits/scripts as needed.
- Commit in logical commits.
- Do not push.
```

### Final AGENT Response (exact)

Gateway ownership stabilization is complete. The scheduled task is healthy on the approved `D:\openclaw` runtime, ClawX no longer competes for the port, and broken npm-global OpenClaw was safely removed.

| Item | Final evidence |
| --- | --- |
| Gateway owner before | `.openclaw\gateway.cmd` -> broken npm-global `openclaw\dist\index.js` |
| Gateway owner after | `.openclaw\gateway.cmd` -> system Node -> `D:\openclaw\runtime\openclaw\node_modules\openclaw\dist\index.js` |
| Gateway lifecycle | Stop, start, forced restart, listener ownership, and health passed |
| ClawX | Relaunched successfully; `gatewayAutoStart=false`; did not retake port `18789` |
| Active CLI | Unchanged at `D:\openclaw\bin\openclaw.cmd` |
| npm-global OpenClaw | Four gated stale artifacts removed; no residue remains |
| Control-plane verifier | `38 PASS`, `0 WARN`, `0 FAIL` |
| Serena files | Only `.serena/project.yml` and `open-claw/.serena/project.yml` remain uncommitted |

Commits:

- `a14ea94` — `scripts: stabilize OpenClaw Gateway ownership`
- `6b538de` — `docs: record OpenClaw Gateway ownership migration`
- `bb806ac` — `fix: keep ClawX rollback dry run non-invasive`

Primary artifacts:

- `scripts/openclaw/backup-openclaw-gateway-service.ps1`
- `scripts/openclaw/migrate-openclaw-gateway-service.ps1`
- `scripts/openclaw/disable-clawx-embedded-gateway-autostart.ps1`
- `scripts/openclaw/verify-openclaw-control-plane.ps1`
- `docs/audits/2026-07-28-openclaw-gateway-ownership-migration.md`
- `docs/runbooks/OPENCLAW_CLAWX_RECOVERY.md`

Backups and rollback:

- Gateway/task/config: `C:\Users\ynotf\openclaw-control-plane-backups\gateway-service\20260728-190702`
- Gateway rollback: `restore-openclaw-gateway-service.ps1`
- ClawX setting rollback: `clawx-app-data\restore-clawx-gateway-settings.ps1`
- npm-global cleanup: `C:\Users\ynotf\openclaw-control-plane-backups\control-plane\20260728-191721`
- npm-global rollback: `restore-npm-global-openclaw.ps1`
- All three rollback scripts passed fresh dry runs.

No PATH change, package install, ClawX installed-file edit, `D:\openclaw` runtime edit, vendor edit, push, or Serena staging occurred.

Remaining risks:

- AgentCore Serena and Sequential Thinking calls consistently returned MCP tunnel HTTP `404`; installed-source inspection and live evidence provided the documented degraded-mode fallback.
- A future ClawX upgrade could reset `gatewayAutoStart`; the verifier now fails if it becomes `true`.
- The gateway intentionally remains tied to the current `D:\openclaw` operational runtime.

Next phase: independently evaluate the source-controlled launcher/PATH cutover while preserving the accepted gateway rollback. Do not combine that phase with runtime relocation.

::git-commit{cwd="D:\github\open--claw"}

<oai-mem-citation>
<citation_entries>
MEMORY.md:2691-2704|note=[used prior OpenClaw Windows and gateway context]
MEMORY.md:2781-2784|note=[used prior listener ownership verification pattern]
</citation_entries>
<rollout_ids>
019ea8eb-3e5f-7661-9e24-204606b2d71f
</rollout_ids>
</oai-mem-citation>

### Files Changed

- `docs/ai/context/AGENT_EXECUTION_LEDGER.md`
- `docs/ai/STATE.md`
- `docs/ai/HANDOFF.md`
- `docs/ai/memory/DECISIONS.md`
- `docs/ai/memory/PATTERNS.md`
- `docs/ai/operations/openclaw-gateway-restart.md`
- `docs/audits/2026-07-28-openclaw-gateway-ownership-migration.md`
- `docs/audits/2026-07-28-npm-global-openclaw-cleanup-gate.md`
- `docs/blueprints/OPENCLAW_CLAWX_CONTROL_PLANE_BLUEPRINT.md`
- `docs/runbooks/OPENCLAW_CLAWX_RECOVERY.md`
- `scripts/openclaw/audit-openclaw-control-plane.ps1`
- `scripts/openclaw/verify-openclaw-control-plane.ps1`
- `scripts/openclaw/backup-openclaw-gateway-service.ps1`
- `scripts/openclaw/migrate-openclaw-gateway-service.ps1`
- `scripts/openclaw/disable-clawx-embedded-gateway-autostart.ps1`

### STATE.md Entries Updated

- `docs/ai/STATE.md`: `## 2026-07-28 19:30 — OpenClaw Gateway Runtime Ownership Stabilization`

### Verdict

PASS — the scheduled task, live listener, ClawX coexistence, cleanup, rollback, durable control plane, and final verifier all satisfy the acceptance criteria.
