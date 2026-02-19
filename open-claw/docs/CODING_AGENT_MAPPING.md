# OpenClaw Coding Agent → Open Claw Dev Module Mapping

## OpenClaw's Built-in Coding Agent

OpenClaw ships with a `coding-agent` skill in `vendor/openclaw/skills/coding-agent/`
that provides code generation, editing, and repository operation capabilities.

## Mapping to Open Claw Modules

| OpenClaw Capability | Open Claw Module | Notes |
|---------------------|------------------|-------|
| Code generation | `dev` | Via agent tool calls (exec, edit, write, read) |
| File system ops | `dev` | Sandboxed by default in non-main sessions |
| Browser automation | `web` | Via browser tool, sandboxable |
| Repository ops | `dev` | Git operations via exec tool |
| Symbol navigation | `dev` | Via Cursor MCP tools (serena, Context7) |

## Cursor IDE Integration

The Cursor IDE provides additional capabilities that complement OpenClaw's coding agent:

| Cursor Tool | Purpose | Maps to Module |
|-------------|---------|----------------|
| serena | Code navigation, symbol lookup, refactoring | dev |
| Context7 | Library docs, API reference | dev |
| playwright | Browser testing, UI verification | web |
| Memory Tool | Cross-session recall | memory |
| sequential-thinking | Reasoning, planning | orchestrator |

## Dev Loop

```
User request
     │
     ▼
Cursor PLAN tab → designs approach
     │
     ▼
Cursor AGENT tab → executes via:
  ├─ serena (code navigation)
  ├─ Context7 (docs lookup)
  ├─ Shell/WSL (commands)
  └─ File edits (direct)
     │
     ▼
OpenClaw coding-agent → extends with:
  ├─ Natural language code requests via chat
  ├─ Multi-file refactoring
  └─ Autonomous task execution (sandboxed)
```

## When to Use Which

- **Cursor AGENT**: structured, plan-driven development with evidence tracking
- **OpenClaw coding-agent**: conversational, ad-hoc coding via messaging channels
- **Both**: different interfaces to the same codebase, same security policies
