---
name: design
description: Adaptively run architecture analysis and/or spec generation — whichever the task actually needs, decided automatically.
disable-model-invocation: true
---

# /reins:design

Manual entry point that adaptively runs `skills/think/arch-analyzer/SKILL.md` and/or `skills/build/doc-generator/SKILL.md`, deciding internally which is needed rather than making the user pick.

## What Happens When Called

1. Check whether the task involves an architecture decision (new pattern, module boundary, structural change). If yes, run architecture analysis: detect existing patterns, apply the deletion test and 1-adapter-hypothetical/2-adapter-real heuristics, propose or flag inconsistencies.
2. Check whether the task needs a functional spec (what's being built, acceptance criteria). If yes, generate one.
3. If both apply, run both — no need to invoke this twice.

## Output

- Architecture findings → `docs/reins/design/` or, for multi-candidate decisions, a self-contained HTML report with confidence badges (Strong/Worth exploring/Speculative)
- Specs → `docs/reins/design/{slug}-fsd.md`, `-sdd.md`, or `-prd.md` as applicable — behavior-focused, no file paths or line numbers, so they don't go stale
- For database-touching work → `docs/reins/erd/{slug}-erd.md`

## Full Behavior

See `skills/think/arch-analyzer/SKILL.md` and `skills/build/doc-generator/SKILL.md` for detection signals, heuristics, and document formats.
