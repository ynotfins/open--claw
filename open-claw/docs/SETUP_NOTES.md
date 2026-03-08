# OpenClaw — Setup Notes

> Official docs: https://docs.openclaw.ai/ | Upstream repo: https://github.com/openclaw/openclaw

## Purpose

This is a local wrapper note for running OpenClaw in this environment.

For runtime behavior, command support, onboarding, and environment loading, the upstream source of truth is:

- `vendor/openclaw/README.md`
- `vendor/openclaw/docs/start/getting-started.md`
- `vendor/openclaw/docs/cli/index.md`
- `vendor/openclaw/docs/cli/gateway.md`
- `vendor/openclaw/docs/help/environment.md`

## Prerequisites

| Requirement | Version | Notes |
| --- | --- | --- |
| OS | Windows 10/11 with WSL2 | Ubuntu 24.04 recommended |
| Node.js | `>=22.12.0` | Matches upstream runtime guard and `package.json` |
| pnpm | `10.23.0` | Pinned by upstream `packageManager` |
| Git | 2.x | Used for repo + vendor sync |

## WSL2 Setup

```powershell
# Install WSL2 (PowerShell, admin)
wsl --install -d Ubuntu-24.04
```

```bash
# Inside WSL - install Node 22 via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc
nvm install 22
nvm use 22

# Pin pnpm to the version expected by upstream
corepack enable
corepack prepare pnpm@10.23.0 --activate
```

## Path Mapping

| Context | Path |
| --- | --- |
| Windows repo | `D:\github\open--claw\` |
| WSL repo mirror | `/mnt/d/github/open--claw/` |
| Vendor repo checkout | `/mnt/d/github/open--claw/vendor/openclaw/` |
| Working build | `~/openclaw-build/` |
| OpenClaw state | `~/.openclaw/` |
| OpenClaw config | `~/.openclaw/openclaw.json` |

## Runtime Entrypoints

Use these command paths in this order of preference:

1. Installed/runtime CLI: `openclaw ...`
2. Source-repo helper script: `pnpm openclaw ...`
3. Direct bootstrap: `node openclaw.mjs ...`

Notes:

- `pnpm openclaw ...` is the supported source checkout helper because upstream wires it to `node scripts/run-node.mjs`.
- `node openclaw.mjs ...` is the direct CLI bootstrap when you want to bypass the package script layer.
- Do not rely on legacy `start` aliases as the canonical boot path. Upstream documents `openclaw gateway`, `openclaw gateway status`, `openclaw health`, and `openclaw dashboard` instead.
- Do not treat `pnpm exec` wrappers as the primary or canonical entrypoint for this repo.

## Recommended Local Development Loop

```bash
cd ~/openclaw-build

# Install dependencies in the Linux build copy, not on /mnt/d
pnpm install

# Build runtime + UI assets
pnpm build
pnpm ui:build

# Run the upstream onboarding wizard
pnpm openclaw onboard --install-daemon

# Verify the managed gateway service
pnpm openclaw gateway status
pnpm openclaw health

# Open the Control UI
pnpm openclaw dashboard

# Print a tokenized Control UI URL without opening a browser
pnpm openclaw dashboard --no-open
```

For foreground debugging instead of the managed service:

```bash
cd ~/openclaw-build
pnpm openclaw gateway
```

## Key Commands

| Command | Purpose |
| --- | --- |
| `pnpm openclaw onboard --install-daemon` | Run upstream onboarding and install the gateway service |
| `pnpm openclaw gateway status` | Check the managed gateway service and probe reachability |
| `pnpm openclaw health` | Query gateway health through the CLI |
| `pnpm openclaw dashboard` | Open the Control UI |
| `pnpm openclaw dashboard --no-open` | Print a tokenized Control UI URL for manual/browser launch |
| `pnpm openclaw gateway` | Run the gateway in the foreground for debugging |
| `pnpm openclaw config get gateway.auth.token` | Print the configured gateway auth token |
| `pnpm openclaw config set <key> <value>` | Update config |
| `pnpm openclaw doctor` | Diagnostics and repair helpers |
| `pnpm openclaw doctor --generate-gateway-token` | Generate a gateway token if config does not already have one |
| `pnpm test` | Run test suite |
| `pnpm build` | TypeScript build |

## Environment And Secrets

Upstream environment precedence is:

1. Process environment
2. `.env` in the current working directory
3. `~/.openclaw/.env`
4. Config `env` block in `~/.openclaw/openclaw.json`
5. Optional shell import

Wrapper guidance:

- Never commit `.env` files, tokens, or API keys.
- `~/.openclaw/.env` is the simplest shared local store, but it is not the only supported source.
- Some provider credentials may be written to auth profiles under the agent directory instead of shared `.env`.
- See `vendor/openclaw/docs/help/environment.md` for upstream details.

Common variables you may still use locally:

- `OPENCLAW_GATEWAY_TOKEN`
- `OPENCLAW_GATEWAY_PASSWORD`
- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `GEMINI_API_KEY`
- `TELEGRAM_BOT_TOKEN`
- `DISCORD_BOT_TOKEN`
- `SLACK_BOT_TOKEN`

## What Not To Do

- Do not build on `/mnt/d/...` when `pnpm` needs to mutate or rename many files. Use `~/openclaw-build/`.
- Do not describe `~/.openclaw/.env` as the only valid config source.
- Do not reintroduce legacy `start`-style startup instructions into local docs.
- Do not commit secrets, `.env` files, or provider credentials.
- Do not use `vendor/openclaw/.git/` for wrapper-repo commits.
