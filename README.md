# domain-experts

A Claude Code plugin for building, evaluating, and evolving **domain expert agents**.

## What it is

Three skills + one reference agent + a Python eval runner companion.

### Skills

| Skill | Status | What it does |
|---|---|---|
| `domain-creator` | ✅ Complete | Build a new agent OR uplevel an existing one. Two modes: **create** (interview from scratch) and **refit** (audit an existing agent, walk through changes one-by-one, overwrite). |
| `domain-eval` | ✅ Complete | Run an agent against its own declared schema/vocabulary/rules. Structural checks per category + report PASS / WEAK / FAIL per prompt. Detects regressions before shipping. |
| `domain-capture` | ✅ Complete | Capture new evidence-backed knowledge into an existing agent. Validates against the agent's current view, requires evidence, refuses live-source claims, writes with citation + timestamp to KB / memory / frontmatter. |

### Reference agent

| Agent | Domain | Validation |
|---|---|---|
| `nala` | Venture building / startup studio (MENA/KSA focus) | **11 / 11 PASS** across 8 categories — see [Validation](#validation) |

### Companion script

`scripts/eval_runner.py` — Python automation harness for `domain-eval`. Uses the Claude Agent SDK with your Claude Code authentication (no API key). Same logic as the in-session skill; useful for batch runs, CI, and scheduled evals.

## The 7 categories of work

`domain-creator` structures agents around these:

```
1. decision_support      — structured verdict with reasoning
2. reference_lookup      — cited answers to domain questions
3. structured_review     — audit an artifact, return categorized findings
4. competitive_intel     — profile competitors, comparables
5. regulatory_compliance — apply named regulations
6. handoff_partner       — structured briefs for other agents/humans
7. educational_explainer — teach domain concepts
```

Most schema questions in `domain-creator` have a tested default. Users accept with one keystroke.

## Install

```bash
# Register the plugin's marketplace (local clone)
/plugin marketplace add /path/to/domain-experts

# Or from GitHub
/plugin marketplace add onestudio-exp/domain-experts

# Install the plugin
/plugin install domain-experts@domain-experts

# Reload skills
/reload-plugins
```

After install, three skills appear:

- `domain-experts:domain-creator`
- `domain-experts:domain-eval`
- `domain-experts:domain-capture`

## Use

### Create a new agent

```
/domain-experts:domain-creator
> new
```

Answer ~10 short questions (most have defaults). The skill produces 3 files: agent definition + KB scaffold + starter prompts. Save when ready.

### Refit an existing agent

```
/domain-experts:domain-creator
> refit
> <slug or full path>
```

The skill audits the agent against the framework, walks you through each recommended change one-by-one, and produces an upleveled version (overwrites the agent file; creates KB scaffold and starter prompts if missing).

### Capture new knowledge into an agent

```
/domain-experts:domain-capture
> <slug or path>
> <your claim — fact, correction, decision, or lesson>
```

The skill classifies the claim (rule / decision / lesson / live-source), surfaces the agent's current view to detect contradictions, requires a source, and writes to the right destination (KB topic file or memory, with citation and a dated entry). Refuses to capture content that should be live-read from source.

### Evaluate an agent

In a Claude Code session:

```
/domain-experts:domain-eval
> <slug or path>
```

The skill loads the agent's declared schema/vocab/rules, runs each starter prompt through the agent, applies structural checks, and reports PASS / WEAK / FAIL per prompt with a category breakdown.

For batch / scheduled runs, use the Python companion:

```bash
uv sync
uv run python scripts/eval_runner.py --slug <agent-slug>          # full set
uv run python scripts/eval_runner.py --slug nala --category refusal_test
uv run python scripts/eval_runner.py --slug nala --id refusal-001 --id refusal-003
uv run python scripts/eval_runner.py --slug nala --limit 3        # first 3
```

The runner writes a YAML report to `agents/<slug>-eval-runs/<timestamp>.yaml`. Use this as a baseline; future runs can diff against it to detect regressions.

## Validation

Nala (the reference agent) was tested across all 8 categories she claims:

```
decision_support       3/3 PASS   verdict vocab + adaptive schema
reference_lookup       1/1 PASS   confidence tags + cited sources
structured_review      1/1 PASS   severity markers (🔴 🟡 🟢 ❓ 🚏)
competitive_intel      1/1 PASS   Direct / Indirect / Substitute tiers
regulatory_compliance  1/1 PASS   article-level citation + applicability
handoff_partner        1/1 PASS   6-part brief sections all present
refusal_test           3/3 PASS   refused term-sheet & cap-table requests
                                  answered org-structure (boundary case)

Total:                 11 / 11 PASS
```

The eval was run via `scripts/eval_runner.py` with Nala's declared tools (`Read, Glob, Grep, WebSearch, WebFetch`) — same configuration she'd run in production.

## Repository layout

```
domain-experts/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── skills/
│   ├── domain-creator/                # complete (create + refit modes)
│   │   ├── SKILL.md
│   │   └── references/agent-template.md
│   ├── domain-eval/                   # complete
│   │   └── SKILL.md
│   └── domain-capture/                # complete
│       └── SKILL.md
├── agents/
│   ├── nala.md                        # reference agent
│   ├── nala-knowledge/                # KB scaffold (5 subdirs)
│   └── nala-eval-runs/                # eval reports per run
├── examples/
│   └── nala-starter-prompts.yaml      # 11 starter prompts (8 + 3 refusal tests)
├── scripts/
│   └── eval_runner.py                 # Python eval automation
└── pyproject.toml                     # claude-agent-sdk + pyyaml
```

## Why "domain-" prefix?

These skills are scoped to **domain expert agents** — agents whose value is depth in a single domain (a market, a regulation, a product practice, a craft). Future plugins will target other agent classes (coding, ops, integration). The prefix keeps each plugin's scope clear.

## Status

All three skills complete. Reference agent (Nala) validated 11/11. Internal to OneStudio for now; open-sourcing TBD after broader internal use.
