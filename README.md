# domain-experts — A PM's guide

A Claude Code plugin for **building, evaluating, and evolving** domain expert agents.

Three skills, one reference agent (**Nala** — MENA/KSA Venture Builder expert).

---

## The 3-step lifecycle

Every agent in this system goes through the same three steps. We walked Nala through all three — here's the recap, and how you do the same for your own agent.

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  1. CREATE   │ ──> │  2. EVALUATE │ ──> │  3. CAPTURE  │
│              │     │              │     │              │
│ /domain-     │     │ /domain-     │     │ /domain-     │
│  creator     │     │  eval        │     │  capture     │
└──────────────┘     └──────────────┘     └──────────────┘
   build it           prove it works        feed it new evidence
```

---

## 1. Create

```
/domain-experts:domain-creator
> new
```

Builds a brand-new agent from ~10 short questions. Most have one-keystroke defaults — accept them and move on.

**What we did for Nala:** ran `new`. The skill asked who she serves, what her domain is, what kinds of work she does (decision support? structured reviews? competitor profiling?), what verdicts she's allowed to give, and how she should refuse to invent facts. About 10 minutes start to finish.

It produced three things:

- **The agent itself** — Nala's role, rules, and refusals
- **A knowledge base scaffold** — empty folders organized by topic (regulations, frameworks, market data, cultural context, comparable studios) ready to be filled in over time
- **A set of starter prompts** — 11 example questions the agent should be able to answer well, used later for testing

> **Already have an agent?** Skip `new` and use the **refit** path further down.

---

## 2. Evaluate

```
/domain-experts:domain-eval
> <agent-name>
```

Runs the agent against its **own declared rules** and reports PASS / WEAK / FAIL on each starter prompt. Catches drift and regressions before you ship anything that depends on the agent.

**What we did for Nala:** ran the full set of 11 prompts. Result: **11 / 11 PASS** across 8 categories.

```
decision_support       3/3 PASS    Used the right verdicts (Invest / Hold / Pivot / Kill)
reference_lookup       1/1 PASS    Tagged each fact's confidence + cited sources
structured_review      1/1 PASS    Used the right severity markers (🔴 🟡 🟢 ❓ 🚏)
competitive_intel      1/1 PASS    Classified competitors as Direct / Indirect / Substitute
regulatory_compliance  1/1 PASS    Cited regulations at article level + checked applicability
handoff_partner        1/1 PASS    Produced a clean brief when scope crossed into legal
refusal_test           3/3 PASS    Refused term-sheet & cap-table requests
                                   Answered org-structure (correctly inside scope)

Total:                 11 / 11 PASS
```

This is the proof that Nala behaves the way her spec says she should. Re-run it any time her spec or KB changes.

---

## 3. Capture KB

```
/domain-experts:domain-capture
> <agent-name>
> <your claim>
```

Adds new knowledge to an existing agent — but **refuses to let the agent invent**. Every claim is checked against what the agent already knows, requires a source, and is stamped with a confidence label and a date.

It also refuses to capture **live data** (e.g., a venture's current ARR). That kind of thing should be live-read from source, not frozen in a static knowledge base where it goes stale within hours.

### The Nala capture story (worked example)

I told Nala: *"KSA just announced an SPV-like model."*

That's a headline, not a usable claim. The skill walked me through turning it into one:

1. **It asked me to be specific.** I refined the claim to: *"KSA has announced an SPV vehicle/framework analogous to the UAE (DIFC/ADGM) regime. Goes live H2 2026. For Venture Builders, this opens a domestic option for structuring startup-level funding instead of routing through a UAE SPV."*

2. **It classified the claim** as a **regulatory rule** (vs. a team decision or a lesson learned) and proposed where to file it: under Nala's `regulations` topic folder.

3. **It checked Nala's existing knowledge** to make sure it wasn't about to silently overwrite or contradict anything. Nala's KB was empty on this topic → safe to add.

4. **It asked for a source.** I didn't have one. The skill *refused* to capture this as `[VERIFIED]` — Nala's anti-fabrication rule requires at least two independent credible sources for regulatory/empirical claims. I overrode the rule and accepted **`[UNVERIFIED]`** instead. The override is logged in the entry itself.

5. **It showed me the final entry** before writing — claim, classification, confidence label, source (or "user-overridden"), date, who captured it, and **5 explicit gaps marked `[NEEDS-RESEARCH]`** (announcing authority, formal vehicle name, exact go-live date, terms, comparison to DIFC/ADGM). I typed `save`.

The entry now lives in Nala's KB. When primary sources land later, I run `/domain-capture` again with citations — it appends a verification entry to the same file and flips the confidence flag.

**The point for PMs:** the skill never let me invent, never let me skip evidence quietly, and the entry is honest about what's known vs. still open. That's what keeps the agent trustworthy as the team feeds it new knowledge over months.

---

## Refit — uplevel an existing agent

If you already have a domain agent (Aref, Rushd, Wafaa, Ziad, Sada, Omar, etc.), **don't start over.** Use the `refit` mode of the same skill:

```
/domain-experts:domain-creator
> refit
> <your-agent-name>
```

**What it does, in plain language:**

1. Reads your existing agent.
2. Compares it against **10 dimensions** every domain agent should meet — clear decision format, verdict vocabulary, confidence labelling, refusal rules, knowledge base, and (new in v0.2) **domain-vs-project framing** — i.e. you reason about a domain, not act as a PM for one product.
3. Walks you through each gap **one at a time**, showing you *what's there now → what it should be → why it matters*.
4. You accept, edit, or skip each suggestion independently.
5. At the end, the agent file is upgraded and any missing scaffolding (knowledge base folders, starter prompts) is created for you.

**When to refit your agent:**

- Your agent's description leads with a product name (e.g. *"…for Member Plus"*) instead of a domain.
- The body references specific code: file paths, class names, commit hashes — that's a project agent, not a domain expert.
- The agent has no `## Comparable peers` section listing 3+ peer products in the category. Without comparables, the agent has nothing to reason against.
- It sometimes makes things up, or invents details that aren't in any source.
- Its outputs feel inconsistent — different verdict words, missing severity tags, no citations.
- You want to be able to **evaluate** it (you can't run `/domain-eval` until it has starter prompts).
- It was written before this framework existed.

**After refit:** run `/domain-experts:domain-eval` on the upleveled agent. The eval now includes a **cross-venture applicability test** — it asks the agent to advise a peer company from your Comparable peers list and checks whether the advice transfers in principle (frameworks portable, specifics differ). If the agent can only answer about one venture, it's still product-coupled.

---

## Quick reference: which skill when?

| You want to... | Use |
|---|---|
| Build a new domain expert from scratch | `/domain-experts:domain-creator` → `new` |
| Bring an existing agent up to spec | `/domain-experts:domain-creator` → `refit` |
| Check that the agent still behaves the way it should | `/domain-experts:domain-eval` |
| Teach the agent something new (a fact, a regulation, a framework) | `/domain-experts:domain-capture` |
| Record a team decision the agent should remember across sessions | `/domain-experts:domain-capture` |

---

## Install

```
/plugin marketplace add /path/to/domain-experts
/plugin install domain-experts@domain-experts
/reload-plugins
```

Once installed, the three skills appear in any Claude Code session:

- `/domain-experts:domain-creator`
- `/domain-experts:domain-eval`
- `/domain-experts:domain-capture`

---

## Status

All three skills complete. Reference agent (Nala) validated 11/11. Internal to OneStudio for now.

## Changelog

**v0.2.0** *(2026-05-08)*
- Added 10th audit dimension: **Domain-vs-Project framing**. Refit now flags agents whose description leads with a product, whose body has code-level coupling (file paths / class names / commit hashes), or that lack a `## Comparable peers` section.
- New CREATE-mode framing gate (`Q2.0 — Domain or project?`). The skill refuses to build a project-bound PM agent and explains why.
- New required template sections: `## Reference implementation` (the venture as one example, not the agent's identity) and `## Comparable peers` (3–7 peers in the category).
- New eval check: `cross_venture_applicability` — synthesizes a prompt that asks the agent to advise a peer company from its own Comparable peers list, and verifies that advice transfers in principle.
- Source: 2026-05-08 audit of OneStudio's 13 agents revealed that 6 of them were project-coupled in ways the v0.1 framework didn't catch. v0.2 closes that gap.
- **Known**: Nala (the reference agent in this repo, `agents/nala.md`) was authored against v0.1 and does not yet have `## Reference implementation` or `## Comparable peers` sections. She'll be refit to v0.2 in a follow-up commit so the canonical example passes its own checks.

**v0.1.0** *(initial release)*
- Three skills: `domain-creator`, `domain-eval`, `domain-capture`. Reference agent: Nala.
