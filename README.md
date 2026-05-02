# domain-experts

A Claude Code plugin for building, evaluating, and evolving **domain expert agents**.

> **Status:** Scaffold only. Skills and reference agent under construction.

## What it is

Three skills plus one reference agent, distilled from observation of 13 production domain expert agents at OneStudio.

### Skills

| Skill | What it does |
|---|---|
| `domain-creator` | Walk a user through creating a new domain expert agent via dialog. Asks domain, user, output type, schema, confidence vocabulary, refusal rules, knowledge structure, bilingual handling. Produces a complete `.claude/agents/<id>.md` plus a starter knowledge scaffold and a starter prompt set for evaluation. |
| `domain-eval` | Evaluate a domain expert agent against its own declared schema, vocabulary, and rules. Structural checks + light LLM-judge pass. Reports per-prompt pass/weak/fail with diff against last baseline. |
| `domain-capture` | Capture new evidence-backed knowledge into a domain expert agent. Validates new claims against the agent's current understanding, requires source/evidence, debates contradictions, writes captured knowledge to the right location in the agent's structure with citation and timestamp. |

### Reference agent

| Agent | Domain |
|---|---|
| `nala` | Venture building / startup studio — built using `domain-creator`, evolved via `domain-capture`, regression-checked via `domain-eval`. Demonstrates the patterns the toolkit produces. |

## Why "domain-" prefix?

These skills are specifically for **domain expert agents** — agents whose value is depth in a single substantive domain (a market, a regulation, a product practice, a craft). Future plugins will target other agent classes (coding agents, ops agents, integration agents). The `domain-` prefix scopes these skills to their target.

## Status

This plugin is in active construction. Build order:

1. `domain-creator` skill (in progress)
2. User runs `domain-creator` → produces `agents/nala.md` and seeds `examples/`
3. `domain-eval` skill, validated against Nala
4. `domain-capture` skill, validated against Nala
5. Plugin manifest finalized and tested as a fresh install

## Provenance

Empirical source for the patterns embedded in these skills: 135 use-case entries extracted from 13 production domain expert agents at OneStudio (Rushd, Shaheen, Aref, Ziad, Wafaa, Abo Lijan, Adam, Sales-marketing, Fekri, Omar, Sada, Membership, Merchant Advocate). The clustering analysis that informed this plugin lives at `../bench/scripts/workshop_prep/clustering_proposal.md` in the parent workspace.

## Internal-first

This plugin is internal to OneStudio for now. Open-sourcing TBD after Nala has been used in real venture work.
