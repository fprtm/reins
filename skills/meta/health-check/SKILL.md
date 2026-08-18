# Health Check

Retroactive codebase analysis. Scan existing code for quality issues against Reins constraint sets.

## When to Run

- **Manual trigger**: user asks "run Reins health check" or "check codebase health"
- **Suggested automatically**: after mode transition (e.g., prototype → standard)
- **Onboarding**: when starting work on an unfamiliar codebase

## What It Checks

Scan the codebase against the active constraint and anti-pattern sets:

1. Anti-patterns present in existing code (god functions, deep nesting, N+1 queries, etc.)
2. Security issues (hardcoded secrets, missing input validation, vulnerable dependencies)
3. Performance anti-patterns (O(n²), missing pagination, unbounded caches)
4. Convention inconsistencies (mixed naming styles, conflicting patterns)
5. Missing tests for critical paths
6. Dependency health (outdated, unused, or vulnerable packages)

## Output Format

```markdown
## Reins Health Check — [date]

### Critical (fix now)
- [issue]: `file:line` — [description]

### Warning (fix soon)
- [issue]: `file:line` — [description]

### Info (consider)
- [issue]: `file:line` — [description]

### Summary
- Files scanned: [N]
- Critical: [N] | Warning: [N] | Info: [N]
- Overall: [GOOD / FAIR / NEEDS ATTENTION]
```

## Rules

1. Health check REPORTS only. It does NOT auto-fix.
2. Respect project overrides. If `docs/reins/config.md` says "factory pattern OK", don't flag factories.
3. Prioritize findings by severity. Critical = security/data-loss risk. Warning = quality concern. Info = nice-to-have.
4. Keep output actionable. Each finding should be fixable.
