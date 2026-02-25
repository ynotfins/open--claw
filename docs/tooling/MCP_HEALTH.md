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

## Proof Reads (to be updated after Cursor reload)

| Test | Path | Status |
|------|------|--------|
| Windows read 1 | `D:\github\open--claw\README.md` | PENDING |
| Windows read 2 | `D:\github\AI-Project-Manager\AGENTS.md` | PENDING |
| WSL read | `\\wsl.localhost\Ubuntu\mnt\d\github\open--claw\README.md` | BLOCKED (UNC denied) |
