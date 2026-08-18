# Verification

Multi-layer verification orchestrator. Runs after BUILD phase completes.

## 4 Verification Layers

Run these in parallel when multi-agent is available. Sequential otherwise.

### Layer 1: Type Safety
- Run the project's type checker: `tsc`, `mypy`, `cargo check`, etc.
- Zero type errors required.
- If no type checker configured: skip this layer, note in report.

### Layer 2: Tests
- Run the existing test suite: `npm test`, `pytest`, `go test`, etc.
- All existing tests must pass.
- New code should have tests. If it doesn't: flag as gap in report.
- If test command fails to run (not installed, misconfigured): note in report, don't block.

### Layer 3: Lint
- Run the project's linter: `eslint`, `ruff`, `golangci-lint`, etc.
- Auto-fix what's auto-fixable.
- Report remaining lint errors.
- If no linter configured: skip, note in report.

### Layer 4: Spec Conformance
- Trace each requirement identified in the THINK phase to at least one test or verifiable check.
- Requirements with no corresponding test = **red flag**. List them explicitly.
- This is the most judgment-heavy layer — if multi-model is available, route to STRONG tier.

## Aggregation

Combine results into a verification summary:

```
Layer 1 (Types): [PASS/FAIL/SKIPPED — reason]
Layer 2 (Tests): [PASS/FAIL/SKIPPED — reason] [N/M passed]
Layer 3 (Lint):  [PASS/FAIL/SKIPPED — reason] [N issues, M auto-fixed]
Layer 4 (Spec):  [PASS/FAIL/SKIPPED — reason] [N/M requirements traced]
```

## Self-Fix on Failure

If any layer fails:
1. Attempt to fix (max 2 attempts).
2. If fixed: re-run that layer to confirm.
3. If still failing after 2 attempts: escalate. Do NOT loop.

## Mode Behavior

| Mode | Layers |
|------|--------|
| prototype | Quick smoke test only (does it run?) |
| vibe | Layers 1-3 silently. Only surface failures. |
| standard | All 4 layers |
| strict | All 4 layers + pause for manual review before proceeding |
| emergency | Quick smoke test (does the fix work?) |

## Graceful Degradation

If the agent environment can't run certain checks (no internet for dependency check, sandbox limitations):
- Skip the check.
- Flag exactly what was skipped and why.
- Recommend manual verification for skipped items.
