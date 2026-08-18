# Multi-Agent Orchestration

How to split Reins work across multiple agents for speed and quality.

## Parallelization Rules

```
THINK (parallel)          BUILD (depends on THINK)      PROVE (depends on BUILD)
├─ elicitation    ─┐      ├─ constraint check           ├─ verification    ─┐
├─ context-loader  ├─→    ├─ change-plan                ├─ adversarial      ├─→ REPORT
├─ scope-guard    ─┘      ├─ implementation              ├─ security-check  ─┘
├─ complexity     ─┘      │   ├─ component A (parallel)  ├─ performance    ─┘
                          │   ├─ component B (parallel)
                          │   └─ component C (parallel)
                          └─ anti-pattern check
```

**Sequential dependencies**:
- BUILD waits for THINK to complete (needs context + scope + requirements).
- PROVE waits for BUILD to complete (needs code to verify).

**Parallel within phases**:
- All THINK skills are independent — run simultaneously.
- BUILD implementation can be split by file/component if they're independent.
- All PROVE layers are independent — run simultaneously.

## Multi-Agent Dispatch Pattern

```
Main Agent (orchestrator):
  1. Assess task → determine mode, size, domain
  2. Spawn THINK agents in parallel
  3. Merge THINK results
  4. Create change plan from merged results
  5. Spawn BUILD agents (one per independent component)
  6. Merge BUILD results
  7. Spawn PROVE agents in parallel (one per verification layer)
  8. Merge PROVE results
  9. Generate: report + comprehension + decision log
```

## Context Sharing Between Agents

Each sub-agent receives ONLY what it needs:

| Agent Type | Receives |
|------------|----------|
| THINK agent | Task description + project file listing |
| BUILD agent | Task + THINK output + scope assignment + constraint rules |
| PROVE agent | Task + THINK spec + BUILD code output |

Keep context minimal. Don't pass entire codebase to every agent.

## Conflict Resolution

If two BUILD agents need the same file:
1. Change plan detects overlap.
2. Assign one agent as owner of the shared file.
3. Other agent works on its files, passes requirements for the shared file to the owner.

## Agent Tool Usage

**Claude Code**: use the `Agent` tool with scoped prompts for each sub-agent.
**Codex**: use built-in multi-agent capabilities.
**OpenCode**: see `subagent-patterns/SKILL.md` for sequential simulation.
**Cursor**: single-agent only. Run phases sequentially.
