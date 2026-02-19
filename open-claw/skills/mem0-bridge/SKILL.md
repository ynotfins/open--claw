---
name: mem0-bridge
description: Bridges the mem0 MCP server to OpenClaw's memory system, implementing retrieve-before-plan and store-after-phase patterns for persistent cross-session knowledge.
---

# mem0 Bridge Skill

## Status: READY (requires mem0 MCP server running)

## Architecture
This skill bridges the mem0 MCP memory server (used by Cursor IDE) with OpenClaw's
built-in memory system. It implements the memory contract from
`docs/ai/memory/MEMORY_CONTRACT.md`:

- **Retrieve before plan**: at session start, query mem0 for relevant project/user context
- **Store after phase**: after each completed phase, persist key decisions and facts
- **Conflict resolution**: repo docs (`docs/ai/`) always win over stored memories

## mem0 Integration Pattern
```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  OpenClaw    │────▶│  mem0 Bridge │────▶│  mem0 MCP    │
│  Agent       │◀────│  Skill       │◀────│  Server      │
└──────────────┘     └──────────────┘     └──────────────┘
```

## Capabilities
- Search memories by semantic query
- Store new observations (atomic facts, ≤120 chars, present tense)
- Deduplicate before storing (search first, write only missing)
- List entities and their observations
- Bridge OpenClaw session context to mem0 graph

## Memory Rules (from MEMORY_CONTRACT.md)
- One observation per fact, ≤120 chars, present tense
- Never persist: secrets, tokens, API keys, credentials, personal data
- Persist: stacks, frameworks, naming conventions, key decisions
- Repo docs win over stored memories in conflicts

## Configuration
```json5
{
  skills: {
    entries: {
      "mem0-bridge": {
        enabled: true,
        env: {
          MEM0_API_URL: "http://localhost:8080",
        },
      },
    },
  },
}
```

## Unblock Steps
1. Ensure mem0 MCP server is running (check Cursor MCP settings)
2. Configure mem0 API endpoint in skill config
3. Run `openclaw config set skills.entries.mem0-bridge.enabled true`
