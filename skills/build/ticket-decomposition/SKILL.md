# Ticket Decomposition

Break a large task into independently workable pieces, sized to fit one agent session, ordered by real dependency — not by technical layer.

## When This Runs

Triggered for `large` task size (see orchestrator task-size detection), or when the user explicitly asks to break something down ("split this into tickets", "this is too big for one session").

Skipped for micro/small/medium tasks — those fit in one BUILD pass and don't need decomposition overhead.

## Vertical Slices, Not Layers

The default mistake is splitting by technical layer: "ticket 1: database schema, ticket 2: API endpoints, ticket 3: frontend." This produces tickets that can't be demoed or verified independently — the schema ticket is "done" but proves nothing works end-to-end.

Instead, split into **vertical slices**: each ticket is a narrow but complete path through every layer it touches, demoable and verifiable on its own.

```
❌ Layered split:
  1. Database schema for orders
  2. Order API endpoints
  3. Order UI

✅ Vertical slice split:
  1. Create order (schema + endpoint + minimal UI) — end to end, one order type, no discounts
  2. Apply discount code to order — extends slice 1
  3. Partial refund on order — extends slice 1
```

Each vertical slice should be sized to fit in one agent context window — if a slice feels like it needs multiple sessions, split it further.

## The Exception: Wide/Mechanical Refactors

Blast-radius-fanning changes — renames, retyping, framework migrations — don't fit vertical slicing (there's no "layer" to slice; the same trivial change repeats across many files). For these, use **expand → migrate → contract**:

1. **Expand**: add the new thing alongside the old (new field, new function signature with a default) — non-breaking
2. **Migrate**: batch-convert call sites to the new thing, in small CI-green batches
3. **Contract**: remove the old thing once nothing references it

Sequence tickets by batch, not by feature — keep the build green at every batch boundary.

## Computing Blocking Edges

After drafting slices, determine which tickets block which:

```
Ticket 2 (discount code) blocked by: Ticket 1 (create order)
Ticket 3 (partial refund) blocked by: Ticket 1 (create order)
Ticket 2 and Ticket 3: no edge between them — can proceed in parallel
```

Work the **frontier**: at any point, the workable set is every ticket whose blockers are all resolved. This is the same frontier concept as Reins Grill — compute what's unblocked, work it, recompute.

## Presenting the Breakdown

Show the full decomposition as a numbered list before publishing, and confirm with the user:

```
## Proposed Tickets: [Feature Name]

1. Create order (end-to-end, single item, no discounts) — no blockers
2. Apply discount code to order — blocked by #1
3. Partial refund on order — blocked by #1
4. Order history view — blocked by #1

Granularity look right? Any tickets to merge or split further?
```

Wait for confirmation before writing ticket files. This is a judgment call (how to slice) — always worth a quick check before committing to file.

## Ticket Format

**Location**: `docs/reins/tickets/{feature-slug}/{NN}-{ticket-slug}.md`

**Durability rule**: same as FSD/SDD — no file paths or line numbers. Describe end-to-end behavior, not layer-by-layer implementation steps.

```markdown
# Ticket #[N]: [Title]

**Feature**: [parent feature/epic, if any]
**Blocked by**: [Ticket #M, or "none"]

## What to Build
[End-to-end behavior this ticket delivers. Not layer-by-layer — describe the
complete slice: what the user/caller can do once this ticket is done.]

## Acceptance Criteria
- [ ] [Testable criterion]
- [ ] [Testable criterion]

## Out of Scope
- [Explicitly excluded from this ticket — usually deferred to a later ticket]
```

## Working the Tickets

1. Claim the next frontier ticket (all blockers resolved).
2. Run it through the normal Reins pipeline (THINK/BUILD/PROVE) as its own task.
3. On completion, mark it done, recompute the frontier — newly-unblocked tickets become available.
4. Never work more than one ticket at a time per agent session, unless tickets are explicitly parallel-safe (no shared files, no blocking edge) and multi-agent dispatch is available.

## Mode Behavior

| Mode | Ticket Decomposition |
|------|----------------------|
| **prototype** | Skip — build the whole thing in one pass, speed first |
| **vibe** | Decompose silently if task is genuinely large; work tickets in sequence without showing the breakdown unless asked |
| **standard** | Show the breakdown, confirm granularity, then work tickets one at a time with progress updates |
| **strict** | Show the breakdown, require explicit approval per ticket before starting, full DoD per ticket |
| **emergency** | Skip — fix first, decompose the follow-up work later if needed |

## Rules

1. Vertical-slice by default. Layer-splitting is the exception, reserved for mechanical/wide refactors.
2. Every ticket must be independently demoable when done — if it isn't, it's not a real slice.
3. Compute and show blocking edges explicitly — don't leave dependency order implicit.
4. Confirm granularity with the user before writing ticket files — this is a judgment call, not a mechanical process.
5. No file paths or line numbers in ticket bodies — same durability rule as other generated docs.
