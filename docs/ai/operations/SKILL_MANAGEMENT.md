# Skill Management

How to discover, install, verify, and manage skills for the open--claw runtime.

## Skill Types

### Bundled Skills (openclaw-bundled)
- 50 skills ship with the build in `~/openclaw-build/skills/`
- Each has a `SKILL.md` defining its purpose, requirements, and tools
- Readiness depends on external CLIs, config values, or environment variables
- They are NOT separate packages with `package.json` files

### ClawHub Skills (community)
- Published at [clawhub.com](https://clawhub.com)
- Installed via the `clawhub` CLI into `~/.openclaw/workspace/skills/<slug>/`
- Each has its own `SKILL.md` and may have a `package.json`

## Commands

### Check skill status

```bash
pnpm openclaw skills list            # Table of all skills with ready/missing status
pnpm openclaw skills check           # Detailed requirements check per skill
pnpm openclaw skills info <name>     # Detailed info for one skill
```

### ClawHub CLI

```bash
npx clawhub search <query>           # Vector search for skills
npx clawhub inspect <slug>           # Fetch metadata without installing
npx clawhub install <slug>           # Install into skills/<slug>/
npx clawhub install <slug> --force   # Overwrite existing
npx clawhub update [slug]            # Update installed skills
npx clawhub uninstall <slug>         # Remove a skill
npx clawhub list                     # List installed skills (from lockfile)
npx clawhub explore                  # Browse latest updated skills
npx clawhub whoami                   # Check auth status
npx clawhub login                    # Authenticate (opens browser)
```

### After installing or removing skills

Gateway must be restarted to pick up changes:

```bash
pnpm openclaw gateway --force
# or
systemctl --user restart openclaw-gateway
```

Then verify:

```bash
pnpm openclaw skills list | grep <skill-name>
```

## Currently Ready Skills (as of 2026-03-09)

| Skill | Source | Description |
|-------|--------|-------------|
| clawhub | bundled | ClawHub CLI for skill management |
| coding-agent | bundled | Delegate coding tasks to Codex/Claude Code/Pi |
| gh-issues | bundled | Fetch GitHub issues, spawn sub-agents for fixes |
| github | bundled | GitHub operations via `gh` CLI |
| healthcheck | bundled | Host security hardening and risk-tolerance config |
| openai-image-gen | bundled | Batch-generate images via OpenAI Images API |
| openai-whisper-api | bundled | Transcribe audio via OpenAI Whisper API |
| skill-creator | bundled | Create or update AgentSkills |
| tmux | bundled | Remote-control tmux sessions |
| weather | bundled | Weather via wttr.in or Open-Meteo |

## Credential Requirements by Skill

Skills that need external credentials to function:

| Skill | Requirement | How to Provide |
|-------|-------------|---------------|
| gmail | Google OAuth or App Password | `pnpm openclaw config set` or env var |
| imap-smtp-email | IMAP/SMTP server + credentials | Skill config or env var |
| whatsapp-business | WhatsApp Business API token + phone | Skill config |
| web-search-exa | `EXA_API_KEY` | env var (available via `bws run`) |
| playwright-mcp | Chromium browser | `npx playwright install chromium` |
| openai-whisper | `whisper` CLI | `pip install openai-whisper` |
| discord | Discord bot token | `channels.discord.token` in config |
| slack | Slack app config | `channels.slack` in config |
| notion | `NOTION_API_KEY` | env var |
| goplaces | `GOOGLE_PLACES_API_KEY` | env var |
| nano-banana-pro | `GEMINI_API_KEY` + `uv` | env var + CLI |

## Security Notes

- ClawHub skills are community-contributed; inspect before installing (`npx clawhub inspect`)
- Skills run within the gateway process with the same permissions
- Review `SKILL.md` for each installed skill to understand what tools it exposes
- Uninstall any skill that requests unexpected permissions: `npx clawhub uninstall <slug>`

### BLOCKED: Credential-proxying skills (gateway.maton.ai)

**Do NOT install skills that route API traffic through `gateway.maton.ai` or require a `MATON_API_KEY`.**

These skills require you to hand your OAuth tokens to a third-party proxy (Maton) that acts as a man-in-the-middle for all API calls. This pattern is indistinguishable from credential-harvesting malware.

Known affected skills (removed 2026-03-10):
- `gmail` (author: byungkyu) — routes all Gmail API calls through Maton
- `whatsapp-business` (author: byungkyu) — routes all WhatsApp API calls through Maton

**Use instead:**
- WhatsApp: OpenClaw's built-in channel via Baileys (direct connection, `pnpm openclaw configure --section channels`)
- Gmail: Bundled `gog` skill (Google Workspace CLI, direct API) or `imap-smtp-email` (direct IMAP/SMTP)

**General rule:** Any ClawHub skill whose `SKILL.md` references `gateway.maton.ai`, `ctrl.maton.ai`, or requires a `MATON_API_KEY` should be rejected.
