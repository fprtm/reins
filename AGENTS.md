# Agent Control Framework (Reins) v0.3.0

You are operating under Reins. Read `skills/orchestrator/SKILL.md` for full instructions.

## Quick Reference

Reins controls AI coding agents through three phases:

**THINK** (before coding): Clarify requirements, load context, define scope, detect complexity, detect SDLC methodology, analyze architecture, offer Reins Grill for casual decisions before they lock in.
**BUILD** (during coding): Decompose large tasks into vertical-slice tickets, generate docs (FSD/SDD/PRD/ERD/DoD), apply constraints, enforce change plan, detect anti-patterns, guard execution.
**PROVE** (after coding): Verify correctness, test adversarially, check security and performance, report with blind spots, then run the judgment gate — weakest point named, hallucination-risk zones flagged, comprehension confirmed before the task closes.

## Modes

- **prototype**: Speed-first. Minimal guardrails. No plan file, no grill.
- **vibe**: Invisible guardrails. Plan written silently, auto-approved. Stats footer shown.
- **standard**: Balanced. Default. Plan shown, user approves before build. Grill auto-suggested for architecture decisions.
- **strict**: Maximum control. Plan MUST be approved. Checkpoints at every decision. Ungrilled architecture decisions flagged at approval.
- **emergency**: Fix-first. For outages and urgent bugs. No grill, no plan.

## Pipeline Flow

```
1. Detect mode, task size, domain, SDLC, architecture
2. Run THINK phase (parallel: elicitation + context + scope + complexity + SDLC + architecture)
3. Check skill composition (recommend external skills if needed)
4. Offer Reins Grill if a consequential decision is about to lock in casually
5. Write plan to docs/reins/plans/current.md → approval per mode
   (large tasks: decompose into vertical-slice tickets first, work the frontier)
6. Run BUILD phase (doc generator + constraints + anti-patterns + change plan + execution)
7. Run PROVE phase (parallel: verification + adversarial + security + performance)
8. Generate report, log decisions (rule-of-three gated), update glossary, record stats, update index
```

## Slash Commands

Direct access to one phase without full auto-detection: `/reins:discover` (requirements interview), `/reins:decompose` (planning/tickets), `/reins:design` (architecture/spec), `/reins:implement` (coding with guardrails), `/reins:verify` (QA), `/reins:audit` (codebase health scan), `/reins:measure` (impact dashboard). Each is manual-only (`disable-model-invocation: true`) — the orchestrator still auto-triggers the same underlying skills as part of the normal pipeline.

## Reins Grill vs Plain Discussion

Not every conversation triggers Reins. Pure brainstorming with no execution intent is normal chat — skip the pipeline entirely. **Reins Grill** is different: it's the THINK-phase tool for when a decision is about to be made (explicit request, or auto-suggested before an execution signal locks in an architecture/scope choice). See `skills/think/grill/SKILL.md`.

## Priority Rules

1. Project CLAUDE.md/AGENTS.md rules override Reins defaults.
2. User overrides override constraints.
3. Emergency overrides everything.
4. Non-coding tasks and pure discussion: skip Reins entirely.

## Project Files

All Reins project artifacts live in `docs/reins/`:
- `index.md` — relationship graph for navigation
- `config.md` — project settings
- `glossary.md` — domain terms, canonical meaning + rejected synonyms
- `decisions/` — one file per decision, gated by rule-of-three (hard to reverse + surprising + real trade-off)
- `plans/` — current plan + archive
- `tickets/` — vertical-slice breakdowns for large tasks
- `design/` — FSD, SDD, PRD documents (behavior-focused, no file paths/line numbers)
- `erd/` — entity relationship diagrams
- `reports/` — verification reports
- `stats/` — monthly metrics

## Skills Location

All Reins skills are in the `skills/` directory, organized by phase:
- `skills/orchestrator/` — main entry point
- `skills/think/` — elicitation, context-loader, scope-guard, complexity-analyzer, sdlc-detector, arch-analyzer, grill
- `skills/build/` — constraints, anti-patterns, change-plan, execution-guard, model-router, doc-generator, ticket-decomposition
- `skills/prove/` — verification, adversarial, security-check, performance-check, report, judgment
- `skills/meta/` — decision-log, comprehension, insight, health-check, memory, stats, glossary
- `skills/modes/` — prototype, vibe, standard, strict, emergency
- `skills/constraints/` — universal, web, cli, mobile, library, api
- `skills/agents/` — orchestration, model-strategy, subagent-patterns
- `skills/commands/` — the 7 standalone slash-command entry points (discover, decompose, design, implement, verify, audit, measure)
