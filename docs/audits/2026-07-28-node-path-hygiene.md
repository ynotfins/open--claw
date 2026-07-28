# Node PATH hygiene audit

Date: 2026-07-28

Scope: document the completed User PATH hygiene correction that restores stable system Node command ownership while preserving Corepack, pnpm-global ClawHub, migrated MCP tools, and the active OpenClaw owner.

## Evidence source

Backup and verification evidence was captured under:

```text
C:\Users\ynotf\openclaw-control-plane-backups\path-hygiene\20260728-021430
```

Relevant files:

- `before-user-path.txt`
- `before-machine-path.txt`
- `before-process-path.txt`
- `before-command-resolution.txt`
- `before-package-manager-health.txt`
- `after-user-path.txt`
- `after-fresh-child-powershell-verification.ps1`
- `after-verification-output.txt`
- `final-user-path.txt`

## User PATH order

Before correction, the relevant persisted User PATH order was:

```text
002: D:\openclaw\bin
003: C:\Users\ynotf\AppData\Local\Corepack\shims
004: C:\Users\ynotf\AppData\Local\pnpm\bin
025: C:\Program Files\nodejs
048: C:\Users\ynotf\AppData\Roaming\npm
057: C:\Program Files\ClawX\resources\cli
```

After correction, the relevant persisted User PATH order is:

```text
002: D:\openclaw\bin
003: C:\Program Files\nodejs
004: C:\Users\ynotf\AppData\Local\Corepack\shims
005: C:\Users\ynotf\AppData\Local\pnpm\bin
006: C:\Users\ynotf\AppData\Roaming\npm
007: C:\Program Files\ClawX\resources\cli
```

The unrelated early entry `C:\Users\ynotf\.minimax\bin` remained before the approved block.

## Exact User PATH mutation

Only the persisted User PATH was changed. Machine PATH was not modified.

The mutation was a reorder of existing relevant entries:

- `D:\openclaw\bin` remained the first relevant User PATH owner.
- `C:\Program Files\nodejs` moved from User PATH position 25 to position 3.
- `C:\Users\ynotf\AppData\Local\Corepack\shims` moved from position 3 to position 4.
- `C:\Users\ynotf\AppData\Local\pnpm\bin` moved from position 4 to position 5.
- `C:\Users\ynotf\AppData\Roaming\npm` moved from position 48 to position 6.
- `C:\Program Files\ClawX\resources\cli` moved from position 57 to position 7.

No package install, uninstall, upgrade, or move was performed.

## Command ownership after correction

Verification was run in a child PowerShell with PATH reconstructed from persisted Machine PATH plus persisted User PATH. The resulting command ownership was:

| Command | First owner after correction |
| --- | --- |
| `node` | `C:\Program Files\nodejs\node.exe` |
| `npm` | `C:\Program Files\nodejs\npm` |
| `npx` | `C:\Program Files\nodejs\npx` |
| `corepack` | `C:\Program Files\nodejs\corepack` |
| `pnpm` | `C:\Users\ynotf\AppData\Local\Corepack\shims\pnpm` |
| `pnpx` | `C:\Users\ynotf\AppData\Local\Corepack\shims\pnpx` |
| `clawhub` | `C:\Users\ynotf\AppData\Local\pnpm\bin\clawhub` |
| `mcp-server-filesystem` | `C:\Users\ynotf\AppData\Local\pnpm\bin\mcp-server-filesystem` |
| `mcp-server-sequential-thinking` | `C:\Users\ynotf\AppData\Local\pnpm\bin\mcp-server-sequential-thinking` |
| `mcp-debugger` | `C:\Users\ynotf\AppData\Local\pnpm\bin\mcp-debugger` |
| `playwright-mcp` | `C:\Users\ynotf\AppData\Local\pnpm\bin\playwright-mcp` |
| `cursor-agent-mcp` | `C:\Users\ynotf\AppData\Local\pnpm\bin\cursor-agent-mcp` |
| `openclaw` | `D:\openclaw\bin\openclaw.cmd` |

Confirmed ownership conclusions:

- Node owner is now `C:\Program Files\nodejs\node.exe`.
- npm, npx, and corepack are owned by `C:\Program Files\nodejs`.
- pnpm and pnpx are owned by Corepack shims at `C:\Users\ynotf\AppData\Local\Corepack\shims`.
- ClawHub is owned by pnpm global at `C:\Users\ynotf\AppData\Local\pnpm\bin`.
- Migrated MCP tools are owned by pnpm global at `C:\Users\ynotf\AppData\Local\pnpm\bin`.
- Active OpenClaw ownership is unchanged at `D:\openclaw\bin\openclaw.cmd`.
- npm-global OpenClaw remains present below the active owner and was not modified.

## Health check outputs

Post-correction health checks from the persisted-PATH child PowerShell:

```text
node --version
v24.16.0
EXIT_CODE::0

npm --version
11.13.0
EXIT_CODE::0

npx --version
11.13.0
EXIT_CODE::0

corepack --version
0.35.0
EXIT_CODE::0

pnpm --version
11.7.0
EXIT_CODE::0

pnpm root -g
C:\Users\ynotf\AppData\Local\pnpm\global\v11
EXIT_CODE::0

pnpm bin -g
C:\Users\ynotf\AppData\Local\pnpm\bin
EXIT_CODE::0

clawhub --cli-version
0.22.0
EXIT_CODE::0

clawhub search code --no-input
returned package search results
EXIT_CODE::0

openclaw --version
OpenClaw 2026.6.10 (aa69b12)
EXIT_CODE::0
```

## Machine PATH note

Machine PATH was intentionally left unchanged. The pre-change Machine PATH evidence shows duplicate Node.js entries:

```text
016: C:\Program Files\nodejs
030: C:\Program Files\nodejs\
```

This duplicate is not part of this correction. It is a separate hygiene item and should only be changed in a future Machine PATH-specific pass with its own backup and verification.

## Rollback location

Rollback source:

```text
C:\Users\ynotf\openclaw-control-plane-backups\path-hygiene\20260728-021430\before-user-path.txt
```

To roll back this pass, restore the User PATH from `before-user-path.txt`. Do not use Machine PATH evidence as rollback input for this correction because Machine PATH was not mutated.

## Next safe phase

Proceed with a read-only npm-global OpenClaw investigation.

Constraints for the next phase:

- Do not remove npm-global OpenClaw until its ownership, consumers, and rollback path are documented.
- Do not alter active OpenClaw ownership away from `D:\openclaw\bin`.
- Do not modify live runtime state, ClawX app data, `D:\openclaw`, or `vendor\openclaw`.
