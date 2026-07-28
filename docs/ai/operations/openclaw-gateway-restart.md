# OpenClaw Gateway — Windows Canonical Restart

Current machine authority is the Windows scheduled task installed from `D:\openclaw`. The older WSL/systemd restart note is not the authority for this runtime.

## Restart

```powershell
openclaw gateway restart --safe --wait 30s
openclaw gateway status
openclaw gateway health --json
```

Use `--force` only when the safe restart cannot drain active work.

## Required Owner

```text
OpenClaw Gateway scheduled task
  -> C:\Users\ynotf\.openclaw\gateway.cmd
  -> C:\Program Files\nodejs\node.exe
  -> D:\openclaw\runtime\openclaw\node_modules\openclaw\dist\index.js
```

Confirm the port owner with `netstat.exe -ano -p tcp`, then inspect the listener PID through `Get-CimInstance Win32_Process`.

Full recovery, backup, and rollback instructions:

`docs/runbooks/OPENCLAW_CLAWX_RECOVERY.md`
