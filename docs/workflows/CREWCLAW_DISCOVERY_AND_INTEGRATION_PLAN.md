# CrewClaw Discovery and Integration Plan

Status: discovery-only  
Baseline date: 2026-07-28  
No CrewClaw install, command, worker start, or configuration mutation is authorized by this plan.

## Purpose

Determine whether CrewClaw has a real, current, locally installed runtime/configuration contract before connecting any CrewClaw-derived worker material to OpenClaw.

## Local Search Performed

The discovery pass searched local files only:

- `D:\github\open--claw`
- `D:\github\open--claw\open-claw`
- `D:\openclaw`

Search categories:

- `CrewClaw` text references;
- purchased employee audits and keep matrices;
- package files;
- Docker/compose files;
- PowerShell, command, shell, JavaScript, and JSON files;
- operational handoff and state records.

Excluded from decision-making:

- `vendor\openclaw`;
- runtime `node_modules`;
- raw backups, logs, generated reports, and screenshots;
- quarantined `candidate_employees`;
- secret-bearing configuration.

## Evidence Found

The repository contains:

- a ten-packet purchased CrewClaw employee audit;
- a keep/discard matrix;
- historical references to ten legacy purchased workers;
- curated employee replacements;
- worker packet runtime shells and heartbeat scripts;
- older Docker-oriented deployment material;
- evidence that purchased packet Dockerfiles used outdated `node:20-slim` and `npm install -g openclaw` assumptions;
- evidence that some packaged deploy artifacts were internally inconsistent.

The current repository's own audits conclude:

- purchased packets are not production-complete;
- `software-engineer.zip` is the strongest raw reference but still incomplete;
- most other named packets are thin role wrappers;
- curated house-standard employee packets are the preferred source.

## What Was Not Found

The local evidence did not establish a current, supported CrewClaw:

- installed executable or CLI owner;
- package name and version;
- installer contract;
- configuration schema;
- credential model;
- runtime database/state root;
- current service or scheduled task;
- supported OpenClaw plugin/extension;
- live worker registration contract;
- health-check command;
- rollback procedure.

Historical Docker workers and purchased packet assets are not proof of a current CrewClaw installation.

## Current Decision

CrewClaw remains discovery-only.

Do not:

- invent CrewClaw commands;
- install a guessed package;
- start legacy containers;
- bulk-copy purchased agents;
- treat purchased packet docs as executable authority;
- make CrewClaw a parallel runtime/control authority;
- attach CrewClaw material to live `.openclaw` state.

## Target Integration Model Once Verified

If a real contract is later proven, integration should preserve a single control authority:

```text
Durable policy and worker definitions
  D:\github\open--claw
          |
          v
OpenClaw orchestration and runtime authority
  D:\openclaw + C:\Users\ynotf\.openclaw
          |
          v
Verified CrewClaw adapter or worker execution surface
  isolated, explicit, replaceable
```

CrewClaw should be an execution adapter or worker source, not a second control plane.

Required boundaries:

- OpenClaw owns agent routing, runtime config, plugin policy, and final tool access.
- The control-plane repo owns sanitized worker definitions and integration contracts.
- CrewClaw runtime state, if any, stays outside Git.
- Credentials remain external and are referenced only by approved secret identifiers.
- Every worker has provenance, readiness state, and a rollback path.
- Legacy purchased packets remain reference material until curated replacements pass live acceptance.

## Lossless Claw Role

Lossless Claw should support the orchestration layer by preserving long-session context and allowing deliberate retrieval through:

- `lcm_grep`;
- `lcm_describe`;
- `lcm_expand`;
- `lcm_expand_query`.

It should not:

- ingest raw CrewClaw secrets or runtime databases;
- become the source of worker definitions;
- replace source-controlled decisions;
- share its live database across unverified worker runtimes.

Future workflow memory should promote sanitized decisions, task summaries, and handoff references. Raw worker sessions remain runtime state.

## Evidence Required Before Implementation

1. Exact local install path or authoritative package identity.
2. Version and publisher/source provenance.
3. Official or installed local documentation.
4. Configuration and credential contract.
5. Runtime-state and log locations.
6. Command or service ownership.
7. Health-check procedure.
8. OpenClaw integration mechanism.
9. Uninstall/rollback procedure.
10. A single-worker isolated smoke test plan.

If any item is missing, remain in discovery mode.

## Later Codex Implementation Phase

After the user approves a verified contract, Codex should:

1. create a timestamped backup of exact CrewClaw config/state targets;
2. add a sanitized integration manifest to the control-plane repo;
3. select one curated worker for an isolated pilot;
4. define input/output, tool, secret, and memory boundaries;
5. implement an adapter without changing OpenClaw authority;
6. run a dry-run and single-worker smoke test;
7. verify Lossless Claw remains healthy;
8. document rollback and evidence;
9. expand only after acceptance.

No implementation begins from this plan alone.
