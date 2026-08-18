---
name: measure
description: Surface the value Reins has actually provided over time — anti-patterns caught, security issues found, scope deviations prevented.
disable-model-invocation: true
---

# /reins:measure

Manual entry point to `skills/meta/stats/SKILL.md`. Use to answer "is Reins actually doing anything useful?" — the question the vibe-mode footer only partially answers in the moment.

## What Happens When Called

Reads `docs/reins/stats/` (monthly files) and `docs/reins/index.md`, and summarizes accumulated impact: anti-patterns caught (and which kinds most often), security issues found, scope deviations prevented, constraints enforced, documents generated, and average verification confidence.

## Output

A summary report — the same shape as the monthly summary block already maintained in each `docs/reins/stats/{YYYY-MM}.md` file, but pulled on demand rather than waited for.

## Full Behavior

See `skills/meta/stats/SKILL.md` for what's tracked and the monthly summary format.
