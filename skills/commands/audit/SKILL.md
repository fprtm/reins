---
name: audit
description: Retroactively scan an existing codebase for anti-patterns, security gaps, convention inconsistencies, missing tests, and dependency health issues.
disable-model-invocation: true
---

# /reins:audit

Manual entry point to `skills/meta/health-check/SKILL.md`. Use to inspect a codebase's general health — not tied to a specific task, and not the same question as `/reins:verify` (which asks "does this implementation satisfy its requirements?"). Audit asks "what problems exist here, regardless of what anyone was just working on?"

## What Happens When Called

Scans the codebase (or a specified area) for:
- Known anti-patterns (see `skills/build/anti-patterns/`)
- Security gaps relevant to the detected domain
- Convention inconsistencies
- Missing test coverage
- Dependency health (outdated, vulnerable, unused)

Read-only — reports findings, does not auto-fix.

## Output

A findings report categorized critical/warning/info, each with location, so issues can be triaged and addressed deliberately rather than silently patched.

## Full Behavior

See `skills/meta/health-check/SKILL.md` for the full scan process and report format.
