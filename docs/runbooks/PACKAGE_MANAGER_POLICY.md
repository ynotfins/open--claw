# Package Manager Policy

Baseline date: 2026-07-28  
Scope: OpenClaw / ClawX control plane on CHAOSCENTRAL

## Ownership Contract

| Command or surface | Required owner |
| --- | --- |
| `node` | `C:\Program Files\nodejs\node.exe` |
| `npm`, `npx`, `corepack` | `C:\Program Files\nodejs` |
| `pnpm`, `pnpx` | `C:\Users\ynotf\AppData\Local\Corepack\shims` |
| pnpm-global shims | `C:\Users\ynotf\AppData\Local\pnpm\bin` |
| npm-global shims intentionally retained | `C:\Users\ynotf\AppData\Roaming\npm` |
| OpenClaw active CLI | `D:\openclaw\bin` until cutover acceptance |
| ClawX fallback CLI | `C:\Program Files\ClawX\resources\cli` |

Corepack owns pnpm provisioning. Do not install a second machine pnpm through npm.

## Required PATH Order

```text
D:\openclaw\bin
C:\Program Files\nodejs
C:\Users\ynotf\AppData\Local\Corepack\shims
C:\Users\ynotf\AppData\Local\pnpm\bin
C:\Users\ynotf\AppData\Roaming\npm
C:\Program Files\ClawX\resources\cli
```

This order keeps stable system Node ownership, Corepack pnpm ownership, pnpm-global MCP/ClawHub ownership, intentional npm-global tools, and ClawX fallback behavior.

## Workspace Rules

1. Read `package.json` before running a package manager.
2. Follow the declared `packageManager` field.
3. Use the repository lockfile already selected by the workspace.
4. Do not generate npm and pnpm lockfiles in the same workspace.
5. Do not use a machine-global pnpm version to rewrite a vendored workspace pin.
6. Do not run install commands in `vendor\openclaw` unless an explicit source-work phase authorizes it.
7. Do not install dependencies in a live plugin island manually.

## OpenClaw Source Pins

- `D:\github\open--claw\vendor\openclaw` retains its own declared pnpm version and lockfile.
- `C:\Program Files\ClawX\resources\openclaw` retains the vendor bundle's pnpm pin and is installer-managed.
- `D:\openclaw\runtime\openclaw\node_modules\openclaw` retains the runtime package metadata that matches the approved operational launcher.
- Machine-global Corepack/pnpm does not override those package pins.

## Global Tool Policy

pnpm global owns:

- ClawHub;
- migrated MCP server command shims;
- other explicitly migrated global CLIs recorded by the package-manager audit.

npm global is allowed only for tools intentionally left there. Presence in npm global is not proof that a tool should remain there. Before migrating or removing a tool:

1. capture `npm list -g --depth=0`;
2. capture `pnpm list -g --depth=0`;
3. capture command resolution;
4. preserve the installed version first;
5. install and verify the replacement;
6. remove only the duplicate package;
7. verify dependent IDE/MCP clients.

Do not bulk-clean npm global.

## ClawHub Policy

- Required version for this baseline: `0.22.0`.
- Required owner: pnpm global.
- Invoke `clawhub` directly.
- Do not use `npx clawhub`; that bypasses the explicit global ownership model and may fetch a different version.
- Upgrade only in a separate compatibility phase with rollback and live search verification.

## OpenClaw Plugin Islands

OpenClaw-managed plugin projects under `C:\Users\ynotf\.openclaw\npm\projects` are isolated runtime package islands. Their npm lockfiles and `node_modules` are OpenClaw-managed runtime state.

Never:

- move them to pnpm global;
- run a bulk package-manager conversion;
- copy them into the control-plane repo;
- remove them as duplicate global packages;
- rewrite their lockfiles manually.

Use OpenClaw plugin commands for lifecycle operations and back up live state first.

## Verification

```powershell
where.exe node
where.exe npm
where.exe npx
where.exe corepack
where.exe pnpm
where.exe pnpx
where.exe clawhub

node --version
npm --version
npx --version
corepack --version
pnpm --version
pnpm root -g
pnpm bin -g
clawhub --cli-version
```

Repository verifier:

```powershell
& 'D:\github\open--claw\scripts\openclaw\verify-openclaw-control-plane.ps1'
```

## Change Gate

Before changing Corepack, pnpm, npm-global packages, pnpm-global packages, or PATH:

- create a timestamped external backup;
- identify exact command owners and alternate owners;
- record package versions;
- define rollback;
- change one ownership layer at a time;
- validate a fresh child shell;
- confirm OpenClaw, ClawHub, and migrated MCP commands.
