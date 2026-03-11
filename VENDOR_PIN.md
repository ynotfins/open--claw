# Vendor Pin: openclaw/openclaw

## Current Pin

| Property | Value |
|----------|-------|
| Upstream repo | `openclaw/openclaw` |
| Tag | `v2026.3.8` |
| Commit SHA | `3caab9260cb0a0064e6a37b2de3bedc8a547e599` |
| Clone type | Shallow (`--depth=1`) |
| Local path (Windows) | `vendor/openclaw/` |
| Local path (WSL runtime) | `~/openclaw-build/` |
| Pinned on | 2026-03-10 |

## Clone Command

```bash
git clone --depth=1 --branch v2026.3.8 https://github.com/openclaw/openclaw.git vendor/openclaw
```

## Properties

- **Shallow**: Yes (`--depth=1`). No commit history beyond the tagged release.
- **Sparse checkout**: No. Full tree is checked out.
- **Submodules**: None.
- **Git LFS**: Configured in upstream `.gitattributes` but no LFS objects in active use.
- **Gitignored**: `vendor/` is listed in the parent repo's `.gitignore`. The vendor clone is not tracked by `open--claw`.

## Upgrade Procedure

1. Identify the target tag (check [openclaw/openclaw releases](https://github.com/openclaw/openclaw/releases)).
2. **Windows NTFS copy**:
   ```powershell
   # Remove old (or rename to .bak for rollback)
   Remove-Item -Recurse -Force vendor\openclaw
   git clone --depth=1 --branch <NEW_TAG> https://github.com/openclaw/openclaw.git vendor\openclaw
   ```
3. **WSL runtime copy**:
   ```bash
   cd ~/openclaw-build && pnpm openclaw gateway stop
   mv ~/openclaw-build ~/openclaw-build.bak
   git clone --depth=1 --branch <NEW_TAG> https://github.com/openclaw/openclaw.git ~/openclaw-build
   cd ~/openclaw-build && pnpm install && pnpm build && pnpm ui:build
   systemctl --user restart openclaw-gateway.service
   ```
4. Verify: `pnpm openclaw health` and `curl -s http://localhost:18792/` → `OK`.
5. Update this file with the new tag, SHA, and date.
6. Commit this file.

## Rollback

If the new version fails health checks:

```bash
# WSL
rm -rf ~/openclaw-build && mv ~/openclaw-build.bak ~/openclaw-build
systemctl --user restart openclaw-gateway.service

# Windows
Remove-Item -Recurse -Force vendor\openclaw
Rename-Item vendor\openclaw.bak vendor\openclaw
```
