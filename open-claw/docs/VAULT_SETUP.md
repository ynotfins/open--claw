# OpenClaw — Vault Setup & Secret Management

## Secret Storage Policy

- **Source of truth**: `~/.openclaw/.env` (inside WSL home directory)
- **Never in repo**: no `.env`, API keys, tokens, or credentials in git
- **Never in config**: `openclaw.json` references env vars by name, not value
- **Rotation**: secrets should be rotated on a regular schedule

## Option 1: 1Password CLI

### Setup
```bash
# Install 1Password CLI in WSL
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main" | \
  sudo tee /etc/apt/sources.list.d/1password-cli.list
sudo apt update && sudo apt install -y 1password-cli
```

### Startup Script
```bash
#!/bin/bash
# ~/.openclaw/load-secrets.sh
# Run before starting the gateway: source ~/.openclaw/load-secrets.sh

export OPENCLAW_GATEWAY_TOKEN=$(op read "op://OpenClaw/Gateway/token")
export ANTHROPIC_API_KEY=$(op read "op://OpenClaw/Anthropic/api-key")
export OPENAI_API_KEY=$(op read "op://OpenClaw/OpenAI/api-key")
export TELEGRAM_BOT_TOKEN=$(op read "op://OpenClaw/Telegram/bot-token")
# Add more as needed
```

### Usage
```bash
eval $(op signin)
source ~/.openclaw/load-secrets.sh
openclaw start
```

## Option 2: Bitwarden CLI

### Setup
```bash
# Install Bitwarden CLI
npm install -g @bitwarden/cli
```

### Startup Script
```bash
#!/bin/bash
# ~/.openclaw/load-secrets-bw.sh

export BW_SESSION=$(bw unlock --raw)
export OPENCLAW_GATEWAY_TOKEN=$(bw get password "OpenClaw Gateway Token")
export ANTHROPIC_API_KEY=$(bw get password "Anthropic API Key")
export OPENAI_API_KEY=$(bw get password "OpenAI API Key")
```

## Option 3: Plain `.env` File (Simplest)

```bash
# ~/.openclaw/.env
OPENCLAW_GATEWAY_TOKEN=<generated-token>
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
# GEMINI_API_KEY=...
# TELEGRAM_BOT_TOKEN=...
# DISCORD_BOT_TOKEN=...
```

Protect the file:
```bash
chmod 600 ~/.openclaw/.env
```

## Secret Rotation Checklist

| Secret | Rotation Frequency | How to Rotate |
|--------|--------------------|---------------|
| Gateway token | Every 90 days | `openclaw doctor --generate-gateway-token` |
| Anthropic API key | On compromise | Regenerate at https://console.anthropic.com |
| OpenAI API key | On compromise | Regenerate at https://platform.openai.com |
| Google OAuth refresh token | On revocation | Re-run OAuth flow |
| Telegram bot token | On compromise | `/revoke` via @BotFather |
| Twilio auth token | Every 90 days | Rotate in Twilio console |

## Pre-Deploy Verification

Before starting the Gateway, verify:
```bash
# Check no secrets in repo
cd /mnt/d/github/open--claw
grep -rn "sk-\|ghp_\|AIza\|AKIA\|token=\|password=" --include="*.md" --include="*.json*" \
  --exclude-dir=vendor --exclude-dir=.git --exclude-dir=node_modules

# Check .env permissions
ls -la ~/.openclaw/.env
# Should show: -rw------- (600)

# Check env vars loaded
env | grep -E "OPENCLAW_|ANTHROPIC_|OPENAI_" | sed 's/=.*/=<set>/'
```
