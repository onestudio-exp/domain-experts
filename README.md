# domain-experts

A Claude Code plugin for building, evaluating, and evolving **domain expert agents**.

## What it is

Three skills + one reference agent.

### Skills

| Skill | Status | What it does |
|---|---|---|
| `domain-creator` | ✅ Complete | Build a new agent OR uplevel an existing one. Two modes: **create** (interview from scratch) and **refit** (audit existing, walk through changes one-by-one, overwrite). |
| `domain-eval` | 🚧 Stub | Run an agent against its own declared schema + a prompt set. Detect regressions. |
| `domain-capture` | 🚧 Stub | Capture new evidence-backed knowledge into an existing agent. |

### Reference agent

| Agent | Domain | Status |
|---|---|---|
| `nala` | Venture building / startup studio (MENA/KSA focus) | Built via `domain-creator` |

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

Most schema questions in the skill have a tested default. Users accept with one keystroke.

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

## Repository layout

```
domain-experts/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── skills/
│   ├── domain-creator/                # complete
│   │   ├── SKILL.md
│   │   └── references/agent-template.md
│   ├── domain-eval/                   # stub
│   └── domain-capture/                # stub
├── agents/
│   ├── nala.md                        # reference agent
│   └── nala-knowledge/                # KB scaffold (5 subdirs)
└── examples/
    └── nala-starter-prompts.yaml      # 12 starter prompts (9 + 3 refusal tests)
```

## Why "domain-" prefix?

These skills are scoped to **domain expert agents** — agents whose value is depth in a single domain (a market, a regulation, a product practice, a craft). Future plugins will target other agent classes (coding, ops, integration). The prefix keeps each plugin's scope clear.

## Status

Active development. `domain-creator` is complete and ships with both modes. `domain-eval` and `domain-capture` are next. Internal to OneStudio for now.
