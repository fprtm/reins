---
name: design
description: Adaptively run architecture analysis and/or spec generation — and, when the work is large, automatically decompose it into vertical-slice tickets. All decided internally, nothing for the user to pick.
disable-model-invocation: true
---

# /reins:design

Manual entry point that adaptively runs `skills/think/arch-analyzer/SKILL.md`, `skills/build/doc-generator/SKILL.md`, and — when needed — `skills/build/ticket-decomposition/SKILL.md`, deciding internally which apply rather than making the user pick.

## What Happens When Called

1. Check whether the task involves an architecture decision (new pattern, module boundary, structural change). If yes, run architecture analysis: detect existing patterns, apply the deletion test and 1-adapter-hypothetical/2-adapter-real heuristics, propose or flag inconsistencies.
2. Check whether the task needs a functional spec (what's being built, acceptance criteria). If yes, generate one.
3. **Check the resulting scope size.** If the designed work is `large` (too big for one implementation pass), automatically decompose it into vertical-slice tickets with blocking edges — the breakdown is shown for granularity confirmation, but the user never has to know or invoke a separate "decompose" step. Small/medium scope: no tickets, straight to a single plan.
4. If several apply, run them all — one invocation covers the whole design phase.

## Output

- Architecture findings → `docs/reins/design/` or, for multi-candidate decisions, a self-contained HTML report with confidence badges (Strong/Worth exploring/Speculative)
- Specs → `docs/reins/design/{NNN}-{slug}-fsd.md`, `-sdd.md`, or `-prd.md` as applicable — numbered, behavior-focused, each with a compact Mermaid diagram
- Database-touching work → `docs/reins/erd/{NNN}-{slug}-erd.md`
- Large scope → tickets at `docs/reins/tickets/{feature-slug}/` with a frontier work order, announced as: "Scope is large — split into N tickets, starting with the unblocked ones."

## Full Behavior

See `skills/think/arch-analyzer/SKILL.md`, `skills/build/doc-generator/SKILL.md`, and `skills/build/ticket-decomposition/SKILL.md` for detection signals, heuristics, formats, and slicing rules.
