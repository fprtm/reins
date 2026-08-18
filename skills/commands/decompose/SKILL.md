---
name: decompose
description: Break a large task into independently workable vertical slices, sized to fit one agent session, with computed blocking edges.
disable-model-invocation: true
---

# /reins:decompose

Manual entry point to `skills/build/ticket-decomposition/SKILL.md`. Use when a task is too large for one pass and needs to be split into pieces that can be worked (and demoed) independently.

## What Happens When Called

Splits the task into **vertical slices** — each slice is a narrow but complete path through every layer it touches, demoable on its own — rather than splitting by technical layer (schema/API/UI). Computes blocking edges between slices so it's clear what can start now versus what waits.

For wide/mechanical changes (renames, retyping, framework migrations) that don't fit vertical slicing, uses **expand → migrate → contract** instead, sequenced in CI-green batches.

## Output

Numbered ticket files at `docs/reins/tickets/{feature-slug}/{NN}-{ticket-slug}.md`, each with acceptance criteria and blocking info, plus a work order showing the current frontier (unblocked tickets).

## Full Behavior

See `skills/build/ticket-decomposition/SKILL.md` for the vertical-slice rules, ticket format, and frontier-working process.
