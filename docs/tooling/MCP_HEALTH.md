# MCP Health Log

## 2026-02-24 — Filesystem MCP Setup Attempts

### Environment
| Tool | Version |
|------|---------|
| node | v22.18.0 |
| npm | 11.7.0 |
| pnpm | 10.24.0 |
| corepack | 0.33.0 |
| WSL distro | Ubuntu |

### Attempt 1 — FAIL (bhushangitfull remote)
- **Config**: `"Filesystem": { "type": "http", "url": "https://file-mcp-smith--bhushangitfull.run.tools" }`
- **Error**: Wrong server entirely — bhushangitfull/file-mcp-smith (Python/Smithery), not the official Node.js server

### Attempt 2 — FAIL (wrong Desktop/Documents paths)
- **Config**: `filesystem` with `C:\Users\ynotf\Desktop`, `C:\Users\ynotf\Documents`
- **Error log**:
  ```
  [error] Error accessing directory C:\Users\ynotf\Desktop: ENOENT: no such file or directory
  ```
- **Root cause**: OneDrive redirects Desktop/Documents to `C:\Users\ynotf\OneDrive\Desktop`

### Attempt 3 — FAIL (forward slashes, %3A encoding)
- **Config**: `filesystem` with `D:/github`, `C:/Users/ynotf/OneDrive/Desktop`, `C:/Users/ynotf/OneDrive/Documents`
- **Error log**:
  ```
  [error] Skipping invalid path or inaccessible: file:///d%3A/github/open--claw
  [error] No valid root directories provided by client
  ```
- **Root cause**: Cursor sends workspace root as `file:///d%3A/...` (URL-encodes `:`). Server rejects it.
  The server connected successfully but then failed the ListRootsRequest step.
  Also: `[warning] No serverName provided for adapter, falling back to stripIdentifierPrefix`

### Attempt 4 — PENDING VERIFICATION (current)
- **Config name**: `filesystem-windows`
- **Command**: `npx -y @modelcontextprotocol/server-filesystem`
- **Args**: `D:\github`, `C:\Users\ynotf\OneDrive\Desktop`, `C:\Users\ynotf\OneDrive\Documents`
- **WSL root**: `\\wsl.localhost\Ubuntu\mnt\d\github` — ACCESS DENIED (WSL_ROOT_MISSING)
- **Smoke test**: PASS — "Secure MCP Filesystem Server running on stdio" (no errors)
- **Cursor registration**: PENDING — requires Reload Window

### WSL Cross-Platform Status
- `Test-Path "D:\github"` → **True**
- `Test-Path "\\wsl.localhost\Ubuntu\mnt\d\github"` → **Access denied** (BLOCKED)
- WSL proof: **BLOCKED** — UNC path access denied from PowerShell

### Fix steps for WSL root (future):
```powershell
# Enable WSL localhost forwarding
# In WSL Ubuntu:
wsl -d Ubuntu -e bash -c 'ls /mnt/d/github'
# If that works, the issue is UNC path permissions on Windows side
# Try: net use \\wsl.localhost\Ubuntu /persistent:no
```

---

### Attempt 5 — PASS (current working config)
- **Config location**: project-level `D:\github\open--claw\.cursor\mcp.json` (gitignored)
- **Server identifier in agent context**: `project-0-open--claw-filesystem-windows`
- **Global `~/.cursor/mcp.json`**: duplicate entry removed (was causing two instances)
- **Key finding**: Global MCP servers show green in UI but are NOT injected into agent `CallMcpTool` context. Only project-level `.cursor/mcp.json` servers are callable by the agent.

## Proof Reads — FINAL RESULTS

| Test | Path | Status | Evidence |
|------|------|--------|----------|
| Windows read 1 | `D:\github\open--claw\README.md` | **PASS** | Full README content returned |
| Windows list | `D:\github\open--claw` | **PASS** | 9 entries listed (.cursor, .git, docs, etc.) |
| Cross-project read | `D:\github\AI-Project-Manager\AGENTS.md` | **PASS** | Full AGENTS.md content returned |
| Cross-project list | `D:\github\AI-Project-Manager` | **PASS** | Directory info + 6 entries returned |
| WSL UNC read | `\\wsl.localhost\Ubuntu\mnt\d\github\...` | **BLOCKED** | UNC access denied from PowerShell |

## Final Status: PASS (Windows), BLOCKED (WSL cross-platform)

---

## 2026-02-26 — Laptop Parity + MCP/Serena Health Proof

### Timestamp
2026-02-26T00:00:00Z (session date)

---

### A) Repo Parity

| Check | Command | Status | Evidence |
|-------|---------|--------|----------|
| git safe.directory | `git config --global --add safe.directory D:/Github/open--claw` | **PASS** | exit 0 (required on this laptop's FS ownership) |
| Working tree | `git -C D:\github\open--claw status` | **PASS** | "On branch master / nothing to commit, working tree clean" |
| Remote | `git -C D:\github\open--claw remote -v` | **PASS** | `origin https://github.com/ynotfins/open--claw` (fetch + push) |
| Canonical commits | `git -C D:\github\open--claw log --oneline -10` | **PASS** | HEAD = `2a65835` (STATE evidence commit), `02cdaf2` present |
| Branch | | **PASS** | `master`, up to date with `origin/master` |

**Parity verdict: PASS — laptop == GitHub == ChaosCentral**

---

### B) Serena Global Roots

| Check | Status | Evidence |
|-------|--------|----------|
| `$env:USERPROFILE\.serena\serena_config.yml` exists | **FAIL** | File not found; `C:\Users\ynotf\.serena\` directory does not exist |
| Alternate locations searched | | `$env:APPDATA\serena`, `$env:LOCALAPPDATA\serena`, `$env:USERPROFILE\.serena`, `D:\github\open--claw` — all empty |
| `D:\github\open--claw` in projects list | **BLOCKED** | Cannot verify — config file absent |
| `D:\github\AI-Project-Manager` in projects list | **BLOCKED** | Cannot verify — config file absent |
| `D:\github\open-claw` (single dash) NOT in list | **BLOCKED** | Cannot verify — config file absent |
| Serena MCP server in workspace descriptors | **FAIL** | `serena` server not present in `C:\Users\ynotf\.cursor\projects\d-Github-AI-Project-Manager\mcps\` — not registered in this workspace |

**Serena verdict: BLOCKED — `serena_config.yml` absent; Serena MCP not registered in current workspace**

#### Fix steps (do not execute without explicit instruction)
```yaml
# 1. Locate or install serena: pip install serena OR check if it's registered globally
# 2. Initialize config: serena init (creates ~/.serena/serena_config.yml)
# 3. Add projects:
projects:
  - path: D:\github\open--claw
  - path: D:\github\AI-Project-Manager
# 4. Ensure NO entry for D:\github\open-claw (single dash — old name)
# 5. Register MCP in ~/.cursor/mcp.json under "serena" key
# 6. Reload Cursor
```

---

### C) MCP Tool Visibility (this workspace: AI-Project-Manager)

| Server | Descriptor present | Tools callable | Status | Notes |
|--------|-------------------|----------------|--------|-------|
| `plugin-context7-plugin-context7` | YES (no tools/ dir) | YES | **PASS** | `resolve-library-id` returned `/openclaw/openclaw` (4730 snippets, High reputation) |
| `user-GitKraken` | YES (13 tools) | PARTIAL | **WARN** | Server responds but `git_status` fails exit 128 on both repos (safe.directory issue within gkcli) |
| `cursor-ide-browser` | YES (24 tools) | YES | **PASS** | Full browser automation tool set present |
| `plugin-cloudflare-cloudflare-bindings` | YES (1 tool: mcp_auth) | UNKNOWN | **WARN** | Auth gate tool only — requires Cloudflare auth |
| `plugin-cloudflare-cloudflare-builds` | YES (1 tool: mcp_auth) | UNKNOWN | **WARN** | Auth gate tool only |
| `plugin-cloudflare-cloudflare-observability` | YES (1 tool: mcp_auth) | UNKNOWN | **WARN** | Auth gate tool only |
| `serena` | **NO** | **NO** | **FAIL** | Not registered in this workspace |
| `sequential-thinking` | **NO** | **NO** | **FAIL** | Not registered in this workspace |
| `Memory Tool (mem0)` | **NO** | **NO** | **FAIL** | Not registered in this workspace (was registered in open--claw workspace context previously) |
| `filesystem` (RO) | **NO** | **NO** | **FAIL** | Project-level `.cursor/mcp.json` removed (per 2026-02-24 entry); global config only has GitKraken |

**Note**: Prior sessions (2026-02-23/24) used these MCP servers from the `open--claw` project workspace. This run is in the `AI-Project-Manager` workspace where only GitKraken, Context7, browser, and Cloudflare servers are registered.

---

### D) Filesystem Read Proof (agent native Read tool — read-only)

The `@modelcontextprotocol/server-filesystem` MCP server is not active in this session (project-level config removed 2026-02-24; global config only has GitKraken). Reads performed via Cursor agent native file read (read-only capability).

| Test | Path | Status | Evidence |
|------|------|--------|----------|
| Windows system read | `C:\Windows\win.ini` | **PASS** | Content: `; for 16-bit app support`, `[Mail] MAPI=1` |
| Project README read | `D:\github\open--claw\README.md` | **PASS** | Full content returned: "# Open Claw / A modular AI assistant platform..." |
| Write/edit/move/create/delete tools | N/A (native Read tool) | **PASS** | No write operations available via this read path |

**Filesystem verdict: PASS (reads) — no active filesystem MCP RO server; reads via native agent capability**

---

## 2026-02-26 — Global MCP Setup (Laptop → ChaosCentral parity)

### Timestamp
2026-02-26 (session date)

### Machine
`DESKTOP` / `C:\Users\ynotf`

### Config path
`C:\Users\ynotf\.cursor\mcp.json`

---

### A) Preflight

| Check | Status | Evidence |
|-------|--------|----------|
| git version | **PASS** | `git version 2.52.0.windows.1` |
| node (pre-install) | **FAIL → FIXED** | Not in PATH; not installed; installed Node.js LTS 24.14.0 via winget |
| npm | **PASS** | `11.9.0` (after Node install) |
| npx | **PASS** | `11.9.0` |
| winget | **PASS** | `v1.12.460` |
| WSL distros | **PASS** | `docker-desktop`, `Ubuntu` |
| mcp.json dir exists | **PASS** | `C:\Users\ynotf\.cursor\` exists |
| mcp.json exists | **PASS** | Pre-existing (only GitKraken); backed up to `.backup.20260226-171958` |
| Conflict check: open--claw `.cursor\mcp.json` | **PASS** | Not present |
| Conflict check: open--claw `.vscode\mcp.json` | **PASS** | Not present |
| Conflict check: AI-Project-Manager `.cursor\mcp.json` | **PASS** | Not present |
| Conflict check: AI-Project-Manager `.vscode\mcp.json` | **PASS** | Not present |

---

### B) uv/uvx Install

| Check | Status | Evidence |
|-------|--------|----------|
| winget search uv | **PASS** | Package ID: `astral-sh.uv` |
| `winget install astral-sh.uv` | **PASS** | `uv 0.10.6` installed |
| `uv --version` | **PASS** | `uv 0.10.6 (a91bcf268 2026-02-24)` |
| `uvx --version` | **PASS** | `uvx 0.10.6` |

---

### C) shell-mcp-server Install + Patch

| Check | Status | Evidence |
|-------|--------|----------|
| `uv tool install shell-mcp-server` | **PASS** | `shell-mcp-server==0.1.0` + 32 deps installed |
| Executable location | **PASS** | `C:\Users\ynotf\.local\bin\shell-mcp-server.exe` |
| `main()` is sync (not coroutine) | **PASS** | `inspect.iscoroutinefunction(main) = False` — `__init__.py` wraps `asyncio.run(server.main())` |
| Patch required? | **NO** | v0.1.0 already correct — no manual patch needed |

---

### D) Global mcp.json Written

| Server | Transport | Secrets | Status |
|--------|-----------|---------|--------|
| `GitKraken` | stdio | none | **PRESERVED** |
| `Clear Thought 1.5` | http | none | **WRITTEN** |
| `Context7` | http | none | **WRITTEN** |
| `Exa Search` | http | none | **WRITTEN** |
| `Memory Tool` | http | none | **WRITTEN** |
| `Stripe` | http | none | **WRITTEN** |
| `playwright` | stdio (npx) | none | **WRITTEN** |
| `github` | stdio (npx) | `GITHUB_PERSONAL_ACCESS_TOKEN` | **BLOCKED** — placeholder; fill from Bitwarden |
| `sequential-thinking` | stdio (npx) | none | **WRITTEN** |
| `firecrawl-mcp` | stdio (npx) | `FIRECRAWL_API_KEY` | **BLOCKED** — placeholder; fill from Bitwarden |
| `firestore-mcp` | stdio (npx smithery) | none | **WRITTEN** |
| `Magic MCP` | stdio (cmd/npx) | Magic API key | **BLOCKED** — placeholder; fill from Bitwarden |
| `googlesheets-tvi8pq-94` | http (composio) | `customerId` | **BLOCKED** — placeholder; fill from Bitwarden |
| `serena` | stdio (uvx) | none | **WRITTEN** |
| `filesystem_scoped` | stdio (npx) | none | **WRITTEN** |
| `shell-mcp` | stdio (exe) | none | **WRITTEN** — exe: `C:\Users\ynotf\.local\bin\shell-mcp-server.exe` |
| JSON parse | | | **PASS** — `ConvertFrom-Json` succeeded |
| Server count | | | **16 servers** listed |

---

### E) Serena Project Registration

| Check | Status | Evidence |
|-------|--------|----------|
| `~/.serena/` directory | **CREATED** | `C:\Users\ynotf\.serena\` (was absent) |
| `serena_config.yml` | **CREATED** | Written with 2 project paths |
| `D:\github\open--claw` in projects | **PASS** | Present in config |
| `D:\github\AI-Project-Manager` in projects | **PASS** | Present in config |
| `D:\github\open-claw` (single dash) | **PASS** | Not present (old name excluded) |

---

### F) Cursor Restart + Tool Verification

**PENDING USER ACTION** — Cannot be automated. Steps:

1. Fully quit Cursor (`File → Exit`, not just reload)
2. Reopen Cursor
3. Go to **Settings → Tools & MCP** and verify each server shows tools
4. For servers marked **BLOCKED**: fill secrets from Bitwarden before verifying
5. Record PASS/FAIL below and update this entry

| Server | Expected status after restart |
|--------|-------------------------------|
| Clear Thought 1.5 | PASS (no secret) |
| Context7 | PASS (no secret) |
| Exa Search | PASS (no secret) |
| Memory Tool | PASS (no secret) |
| Stripe | PASS (no secret) |
| playwright | PASS (no secret) |
| sequential-thinking | PASS (no secret) |
| serena | PASS (uvx pulls from git on first use) |
| filesystem_scoped | PASS (no secret) |
| shell-mcp | PASS (no secret) |
| GitKraken | PASS (preserved) |
| github | BLOCKED until PAT filled |
| firecrawl-mcp | BLOCKED until API key filled |
| Magic MCP | BLOCKED until Magic key filled |
| googlesheets-tvi8pq-94 | BLOCKED until customerId filled |
| firestore-mcp | PASS (no secret; smithery CLI) |

---

### Reference
Canonical config doc: `AI-Project-Manager/docs/tooling/MCP_CANONICAL_CONFIG.md`
