# Reins — Agent Control Framework

**THINK. BUILD. PROVE.**

A multi-agent framework that gives humans control over AI coding agents. Works with Claude Code, Codex, OpenCode, Cursor, and any agent that reads Markdown.

## The Problem

AI coding agents are powerful but have blind spots:

| Problem | What happens |
|---------|-------------|
| Specification ambiguity | User says "build X", agent guesses what X means |
| Overengineering | Simple CRUD gets microservices + Redis + message queue |
| No context alignment | Agent ignores project conventions |
| Verification theater | "All tests pass" but only happy path tested |
| Blast radius blindness | Agent changes 20 files, user expected 3 |
| Expertise erosion | Developer ships code they can't explain |
| No plan visibility | User doesn't know what agent is about to do |
| No documentation | No design docs, no test plans, no decision trail |
| Decisions lock in during casual chat | Architecture choice made in conversation, never challenged before it becomes the plan |
| Decision logs turn into noise | Every trivial choice logged, nobody reads the log anymore |

Reins addresses all of these through three phases of control.

## How It Works

```
THINK                  BUILD                  PROVE
├ Elicitation          ├ Ticket Decomposition ├ Verification
├ Context Loading      ├ Doc Generator        ├ Adversarial Testing
├ Scope Guard          ├ Constraints          ├ Security Check
├ Complexity Analysis  ├ Anti-Patterns        ├ Performance Check
├ SDLC Detection       ├ Change Plan          └ Actionable Report
├ Architecture         ├ Execution Guard
│ Analysis             └ Model Router
└ Reins Grill
```

**THINK** — Before coding: clarify what to build, understand the project, define scope, detect hidden complexity, detect SDLC methodology, analyze architecture, and — before anything locks in — grill consequential decisions through a frontier/round interview backed by Reins's own judgment engines.

**BUILD** — During coding: decompose large tasks into vertical-slice tickets, generate adaptive documents (FSD/SDD/PRD/ERD/DoD), enforce constraints, prevent anti-patterns, declare and track changes, detect loops.

**PROVE** — After coding: multi-layer verification, adversarial testing, security and performance checks, honest report with blind spots.

## 5 Modes

| Mode | For | Overhead |
|------|-----|----------|
| **prototype** | MVPs, hackathons | Near-zero. Just critical security. |
| **vibe** | Casual coding, personal projects | Invisible. Guardrails run silently. |
| **standard** | Daily development (default) | Balanced. Visible checkpoints. |
| **strict** | Production, fintech, compliance | Maximum. Every decision approved. |
| **emergency** | Production outages, urgent bugs | Fix-first. Process later. |

## Slash Commands

Most of the time Reins works invisibly — the orchestrator auto-detects mode/size/domain and runs the right pipeline depth. But sometimes you want direct access to one phase without going through full auto-detection. Seven commands, one per classic SDLC phase:

| Command | Phase | What it does |
|---------|-------|---------------|
| `/reins:discover` | Requirements | Interrogates a decision (architecture, scope, direction) before it locks in — frontier/round interview backed by Reins's own judgment engines |
| `/reins:decompose` | Planning | Splits a large task into independently workable vertical slices with computed blocking edges |
| `/reins:design` | Design | Adaptively runs architecture analysis and/or spec generation — whichever the task needs |
| `/reins:implement` | Implementation | Executes an existing plan/spec/ticket with build-time guardrails active |
| `/reins:verify` | Testing/QA | Full verification — types, tests, lint, spec conformance, adversarial tests, security, performance |
| `/reins:audit` | Maintenance | Retroactive codebase health scan — anti-patterns, security gaps, convention drift, dependency health |
| `/reins:measure` | *(cross-cutting)* | Surfaces Reins's accumulated impact — what's actually been caught over time |

Each command is a thin, manual-only entry point (`disable-model-invocation: true`) into the underlying skill(s) — the orchestrator still auto-triggers the same skills as part of the normal pipeline. Use the commands when you want to invoke a specific phase directly; let the orchestrator run when you just want to work normally.

### Usage Order

```
/reins:discover  →  /reins:design  →  /reins:decompose  →  /reins:implement  →  /reins:verify
   (optional)         (optional)       (optional, large        (usually auto-           (after
                                        tasks only)             triggered)              implement)

/reins:audit and /reins:measure stand alone — call anytime, unrelated to the sequence above.
```

Most tasks don't need the whole chain. In practice:

- **Small/medium task** — skip straight to `/reins:implement`, or don't call any command at all and let the orchestrator handle it.
- **Task needing an architecture or spec decision** — `/reins:design` → `/reins:implement` → `/reins:verify`. Skip `discover` if the direction is already clear; skip `decompose` if it's not large enough to need splitting.
- **Large or ambiguous task** — the full chain: `/reins:discover` (settle direction) → `/reins:design` (spec + architecture) → `/reins:decompose` (split into tickets) → `/reins:implement` per ticket → `/reins:verify` per ticket.
- **`/reins:audit`** — anytime, independent of what you're currently working on. Codebase health check.
- **`/reins:measure`** — anytime. See what Reins has actually caught.

`design` and `decompose` answer different questions and are usually invoked separately rather than together: `design` decides *what the solution looks like* (architecture, spec) and is used for almost any non-trivial task; `decompose` decides *how to cut the work into pieces* and is only relevant once a task is genuinely too large for one pass.

## Features

### Core Pipeline
- **Adaptive pipeline** — Task size detection adjusts depth automatically
- **Plan file** — Written before execution, approval flow per mode
- **Domain-aware constraints** — Web, CLI, mobile, library, API constraint sets

### v0.2.0
- **SDLC awareness** — Auto-detect Scrum/Kanban/Waterfall/solo, adapt behavior per methodology
- **Architecture analysis** — Detect existing patterns, propose for new projects, flag inconsistencies
- **Adaptive doc generation** — FSD, SDD, PRD, ERD, DoD, test plans generated based on task type
- **Skill composition** — Detect when external skills needed, auto-install with confirmation
- **Pre-commit hooks** — Comprehensive gates (secrets, scope, security, anti-patterns, tests, decisions)
- **CI integration** — GitHub Actions workflow for PR quality checks
- **Stats tracking** — Per-task metrics, monthly summaries, vibe mode footer
- **Modular install** — Install only the phases you need
- **Update/uninstall** — Clean install lifecycle management
- **Validation script** — Verify Reins skill file integrity
- **Walkthrough examples** — Step-by-step scenarios for learning Reins

### v0.3.0 — New
- **Reins Grill** — Frontier/round interview (design tree, batched questions with recommendations) that runs *before* a decision locks in — recommendations come from Reins's own judgment engines (arch-analyzer, scope-guard, complexity-analyzer), not generic reasoning. Manual invoke or auto-suggested before a casual decision becomes irreversible.
- **Rule-of-three decision gate** — Decisions are only logged if hard-to-reverse + surprising + a real trade-off. Replaces log-everything with a curated log people actually read.
- **Domain glossary** — `docs/reins/glossary.md` pins down canonical terminology (what a term IS, not how it's implemented), catches conflicting usage live, and lists rejected synonyms so words don't drift.
- **Durable spec format** — FSD/SDD generation dropped file-path/line-number references in favor of behavior and interface descriptions — specs that don't go stale the moment code moves.
- **Architecture judgment heuristics** — Deletion test (does complexity vanish or reappear when a module is removed?) and the 1-adapter-hypothetical/2-adapter-real rule for catching premature abstraction.
- **Git-history-weighted scoping** — When no direction is given, architecture analysis prioritizes recently-churned files over a uniform full-repo scan.
- **Visual architecture reports** — Multi-candidate findings render as a self-contained HTML report (Mermaid diagrams, confidence badges: Strong/Worth exploring/Speculative) instead of a markdown wall of text.
- **Vertical-slice ticket decomposition** — Large tasks split into independently demoable, end-to-end slices with computed blocking edges, worked frontier-first — not sliced by technical layer. Wide/mechanical refactors get the expand→migrate→contract treatment instead.
- **AI output judgment gate** — Research-grounded (AI code carries ~1.7x more defects and a documented "false sense of security" effect): every judged report names its weakest point and hallucination-risk zones, security-sensitive AI output is escalated for human eyes even when checks pass, and generation is throttled to review capacity so comprehension debt doesn't pile up.
- **Council / devil's advocate** — Consequential decisions get a final pass from fixed adversarial seats (devil's advocate, maintainer-a-year-later, security, cost, end-user) before closing — objections either reshape the decision or get an explicit logged acceptance.
- **Session persistence** — Once Reins activates in a session it stays active for every subsequent coding task; detected context and answered questions carry forward instead of being re-asked.
- **Numbered design docs** — FSD/SDD/PRD/ERD/DoD files carry sequence prefixes (`003-payment-refund-fsd.md`), one doc per feature — no more single ever-growing file per doc type. Every FSD/SDD includes a compact Mermaid diagram.

### Multi-Agent
- **Multi-agent orchestration** — Parallelize THINK/BUILD/PROVE phases
- **Multi-model routing** — Cheap models for lint, strong models for architecture (theoretical 40-60% token savings — unverified, see `skills/agents/model-strategy/`)
- **Subagent patterns** — Sequential sub-agent spawning for single-agent environments

### Project Intelligence
- **Decision log** — Curated by the rule-of-three gate, per-file, not monolithic
- **Project memory** — Saves repeated decisions so Reins doesn't ask the same questions
- **Comprehension aid** — Explains what was built so developers stay informed
- **Health check** — Retroactive codebase scan for quality issues
- **Conflict resolution** — Reins yields on aesthetics, wins on safety

### Project File Structure

```
docs/reins/
├── index.md              # Lightweight relationship graph — AI navigation
├── config.md             # Project settings, mode, SDLC, constraints
├── memory.md             # Saved decisions (max 50, pruned)
├── glossary.md           # Domain terms — canonical meaning + rejected synonyms
├── decisions/            # 1 file per decision, gated by rule-of-three
├── plans/
│   ├── current.md        # Active plan (overwritten each task)
│   └── archive/          # Completed plans
├── tickets/               # Vertical-slice breakdowns for large tasks
├── reports/              # Verification reports
├── design/               # FSD, SDD, PRD per feature
├── test-plans/           # Test plans per feature
├── dod/                  # Definition of Done checklists
├── stats/                # Monthly stats (2026-08.md)
└── erd/                  # ERD diagrams (Mermaid)
```

## Install

Fastest path, inside Claude Code:

```
/plugin marketplace add fprtm/reins
/plugin install reins
```

For Codex/OpenCode/Cursor, project-scoped installs, partial installs (`--only`), enforcement hooks, CI, updating, or uninstalling — see **[docs/INSTALL.md](docs/INSTALL.md)** for the full guide, including a troubleshooting section.

## Project Configuration

```bash
# Quick setup
./install/install.sh --agent claude --with-templates

# Or manual
mkdir -p docs/reins
cp templates/reins.config.md docs/reins/config.md
```

Edit `docs/reins/config.md` to:
- Set default mode
- Declare SDLC methodology
- Declare architecture pattern
- Override specific constraints
- Configure external skill preferences
- Add project-specific rules

## Validation

Verify Reins installation integrity:

```bash
./scripts/validate-skills.sh
```

## Examples

See `docs/examples/` for step-by-step walkthroughs:
- [Building a Feature](docs/examples/build-feature.md) — Standard mode, medium task
- [Fixing a Bug](docs/examples/fix-bug.md) — Lightweight pipeline for bug fixes
- [Starting a New Project](docs/examples/new-project.md) — Architecture proposal + full doc suite
- [Strict Mode](docs/examples/strict-mode.md) — Production payment code with checkpoints

## Skill Composition

Reins detects when a task needs capabilities beyond engineering guardrails and recommends external skills:

| Gap Detected | Recommended Skill |
|-------------|-------------------|
| UI styling/aesthetics | Taste, design system skills |
| Test-driven development | mattpocock-skills:tdd |
| Code review | mattpocock-skills:code-review |
| Deep security audit | security-guidance |
| Live library docs | context7 |
| Browser testing | playwright |

Reins yields to external skills on aesthetics and workflow. Reins wins on safety and engineering correctness.

## What Reins Does NOT Do

Reins is engineering guardrails, not a complete toolkit:

- **No aesthetic judgment** — Compose with Taste or UI/UX Pro Max (Reins will recommend if needed)
- **No communication style** — Compose with Caveman (terse) or other persona skills
- **No deployment** — Reins is for code quality, not DevOps
- **No team enforcement** — Shared config via committed `docs/reins/config.md`, but no role-based access

## Philosophy

> Human at the beginning (direction). Agent in the middle (execution). Human at the end (judgment). Framework ensures the agent stays on track — and writes the plan BEFORE it starts.

Reins treats AI as an amplifier: good workflow + Reins = great output. Bad workflow + Reins = the problems are caught, not hidden.

## Acknowledgments

Reins's v0.3.0 interaction patterns — the frontier/round interview mechanic (Reins Grill), the rule-of-three decision gate, durable spec formatting, and architecture judgment heuristics (deletion test, adapter-count rule) — were adapted from design patterns in [mattpocock-skills](https://github.com/mattpocock) (grilling, domain-modeling, codebase-design, to-spec). Reimplemented natively in Reins with Reins's own judgment engines behind the recommendations, not forked.

## License

MIT
