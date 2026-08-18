---
name: verify
description: Run full verification on code — type safety, tests, lint, spec conformance, adversarial testing, security, and performance — with an honest confidence-rated report.
disable-model-invocation: true
---

# /reins:verify

Manual entry point to the PROVE phase. Use to check whether an implementation actually satisfies its intended requirements — whether just-written or pre-existing.

## What Happens When Called

Runs all PROVE-phase layers:
- `skills/prove/verification/` — 4 layers: type safety, tests, lint, spec conformance
- `skills/prove/adversarial/` — targeted tests across boundary, injection, state, type confusion, permission, scale, environment categories
- `skills/prove/security-check/` — domain-specific checklist (web/CLI/API/library/mobile)
- `skills/prove/performance-check/` — scans for O(n²), N+1 queries, missing pagination, and 7 other performance anti-patterns

This is broader than "run the tests" — it's asking "does this hold up," not just "does it pass."

## Output

`docs/reins/reports/{date}-{task}.md` — a verdict, an explicit confidence level (HIGH/MEDIUM/LOW), a short list of things a human should manually verify, and honestly-stated blind spots (what wasn't or couldn't be tested).

## Full Behavior

See `skills/prove/report/SKILL.md` for report format and confidence-level rules.
