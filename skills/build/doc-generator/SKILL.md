# Doc Generator

Generate living project documents adaptively based on task type, domain, and what the task actually needs.

## Trigger Rules

Reins auto-determines which documents to generate. User can always skip or add.

| Task Type | Documents Generated |
|-----------|-------------------|
| **New feature** | FSD (Functional Spec) + DoD |
| **Architecture change** | SDD (Software Design Doc) + DoD |
| **Product-facing feature** | PRD (Product Requirements) + FSD + DoD |
| **Database changes** | ERD (Entity Relationship Diagram) + SDD + DoD |
| **API endpoint** | FSD + API contract |
| **Bug fix** | Report only (no docs) |
| **Refactor** | SDD (if architectural) or Report only |
| **Migration** | SDD + Migration plan + DoD |
| **New project** | PRD + SDD + ERD (if DB) + FSD |

### Detection Signals

How Reins detects task type:

- **Database changes**: Mentions schema, migration, model, table, column, relation, SQL
- **Product-facing**: Mentions user, customer, UX, UI, flow, experience, page, screen
- **Architecture change**: Mentions pattern, layer, module, service, refactor at system level
- **API endpoint**: Mentions endpoint, route, API, REST, GraphQL, request, response

## Document Formats

All documents are short, focused, and actionable. NOT enterprise bloatware. Full per-document templates (FSD, SDD, PRD, ERD, DoD, Test Plan) live in the companion file `skills/build/doc-generator/formats.md` — read it when actually generating a doc.

Two rules that apply to every format, worth knowing before opening the templates:
- **Durability**: never reference file paths or line numbers in FSD/SDD/PRD — describe behavior and interfaces. The one exception is a short snippet that precisely encodes a decision (a type signature, an example payload).
- **Length**: FSD/PRD max 1 page, SDD max 1.5 pages. Longer means over-specified.

## File Locations — Numbered, One Doc Per Feature, Never Append-Forever

All generated docs go to the structured docs/reins/ directory, **with a sequence number prefix**:

| Doc Type | Location |
|----------|----------|
| FSD | `docs/reins/design/{NNN}-{slug}-fsd.md` |
| SDD | `docs/reins/design/{NNN}-{slug}-sdd.md` |
| PRD | `docs/reins/design/{NNN}-{slug}-prd.md` |
| ERD | `docs/reins/erd/{NNN}-{slug}-erd.md` |
| DoD | `docs/reins/dod/{NNN}-{slug}-dod.md` |
| Test Plan | `docs/reins/test-plans/{NNN}-{slug}-tests.md` |

- **NNN**: zero-padded sequence per directory (`001`, `002`, …) — next number = highest existing + 1
- **slug**: kebab-case of the feature name (e.g., `user-auth`, `payment-flow`)
- Example: `docs/reins/design/003-payment-refund-fsd.md`

**Why numbered**: a bare `{slug}-fsd.md` convention means the 100th feature touching "auth" appends to or overwrites the same file, and the file bloats until reading one small section requires reading everything. One numbered file per feature keeps every doc small, scoped, and individually readable — an AI (or human) looking for the refund spec opens exactly one short file, not a 2000-line accretion.

**Update vs. new file — the rule**:
- Same feature, still in flight (spec revised before/during its own implementation) → **update the same numbered file**
- New feature, even in the same area (auth v2, a second payment flow) → **new numbered file**. Mark superseded old docs with a `**Status**: SUPERSEDED by {NNN}` line at top — same convention as the decision log.

After generating, update `docs/reins/index.md` with links and relationships — the index is how anyone finds the right numbered doc without listing the directory.

## Mermaid Diagram — Required in Every FSD and SDD

Every FSD and SDD must include one compact Mermaid diagram giving the user a visual at a glance — most users grasp a 10-node flowchart faster than 10 paragraphs:

- **FSD** → a `flowchart` of the user/data flow (what goes in, what happens, what comes out)
- **SDD** → a component/`flowchart` diagram of module relationships, or a `sequenceDiagram` if the interesting part is the interaction order
- **ERD** → already Mermaid `erDiagram` (existing rule)

Keep it small: if the diagram needs more than ~12 nodes, it's covering too much — split it or simplify. A diagram that needs a paragraph to explain should be redrawn, not explained.

## Mode Behavior

| Mode | Doc Generation |
|------|---------------|
| **prototype** | Skip all docs. Speed first. |
| **vibe** | Generate docs silently. Don't show to user. Available in docs/reins/ for later review. |
| **standard** | Generate relevant docs. Show summary of what was created. |
| **strict** | Generate all applicable docs. Require user review of FSD/SDD before BUILD proceeds. |
| **emergency** | Skip docs. Generate post-fix report only. |

## Rules

1. **Short over complete** — 1-page FSD > 10-page FSD. If it's over 2 pages, you're over-engineering the doc.
2. **Skip irrelevant docs** — Bug fix doesn't need a PRD. Don't generate for the sake of generating.
3. **One numbered doc per feature** — same feature still in flight: update its file. New feature (even same area): new numbered file, mark the old one SUPERSEDED. See "File Locations" above — never let one filename become an ever-growing accretion.
4. **User can always skip** — "skip docs" or "no docs for this" = comply immediately, but say that docs were skipped and why.
5. **Mermaid for diagrams** — Use Mermaid syntax for all diagrams. FSD/SDD must each carry one compact diagram (see "Mermaid Diagram" section).
6. **Elicitation answered = spec written** — if elicitation/grill questions were asked and answered, a spec (at minimum) MUST be generated before BUILD. Questions without a written spec is a broken contract: the user spent effort answering, the answers must land somewhere durable, not evaporate into the conversation.
7. **Always announce what was (not) generated** — "Generated: 003-payment-refund-fsd.md, 002-payment-refund-dod.md" or "No docs — bug fix, report only." Never leave the user guessing why a doc did or didn't appear.
6. **No file paths or line numbers in durable docs** (FSD, SDD, PRD) — they go stale before the doc does. Describe behavior and interfaces instead. Test plans and DoD checklists are exempt since they're inherently tied to the current state of the code.
7. **Use glossary terms** — reference `docs/reins/glossary.md` (see `skills/meta/glossary/`) for canonical terminology. Don't introduce a new synonym for a term that's already defined.
