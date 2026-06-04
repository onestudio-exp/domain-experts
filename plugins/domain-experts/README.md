# domain-experts — A PM's guide

A Claude Code plugin for **building, evaluating, evolving, and talking to** domain expert agents.

Five skills, one reference agent (**Nala** — MENA/KSA Venture Builder expert).

---

## The 4-step lifecycle

Every agent goes through the same four steps. Build it, prove it works, feed it evidence as the world changes, and contribute improvements back to the catalog as you discover them in production.

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  1. CREATE   │ ─> │  2. EVALUATE │ ─> │  3. CAPTURE  │ ─> │ 4. CONTRIBUTE│
│              │    │              │    │              │    │              │
│ /domain-     │    │ /domain-     │    │ /domain-     │    │ /domain-     │
│  creator     │    │  eval        │    │  capture     │    │  contribute  │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
   build it          prove it works      feed it evidence    push improvements
                                                             back to catalog
```

**Plus a fifth, side-channel skill:**

```
┌──────────────┐
│  /domain-    │   talk to the agent through a browser chat UI
│   chat       │   (streaming chat, KB browser, memory CRUD, Workshop)
└──────────────┘
```

Any time the user wants to *talk* to one of these agents — not via Claude Code's text turns but through a real chat surface, with the KB and memory visible alongside — run `/domain-chat`. It boots [agent-kit](https://github.com/onestudio-exp/agent-kit) locally (auto-clones into the current project, gitignored) and opens the browser at the right agent. **Zero config** — agent-kit auto-discovers the persona, KB, and memory.

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
- **A knowledge base** — an indexed scaffold (INDEX.md + per-topic folders: regulations, frameworks, market-data, cultural-context, …), seeded and — when a persona is chosen — populated by the knowledge-harvest Workflow with cited frameworks + an official-sources index
- **A set of starter prompts** — example questions the agent should answer well (incl. persona-fidelity + fabricated-quote refusal tests), used later for testing

### It reads your venture and prefills the interview

The skill opens with **context discovery**: it auto-scans the venture for *all* high-signal
docs (PRD, README, CLAUDE.md, specs, plans), reads the top-ranked ones **silently** (no
"which files?" question), and proposes a framing — domain, primary user, work categories,
reference implementation, comparable peers — each tagged with confidence and the source line
it came from. You confirm or edit on one screen; the interview collapses to ~3 turns.

### It can build the agent in homage to a real expert

After the domain is locked, the skill searches (bilingually, as a Workflow) for **3
influential real figures** in that domain and proposes them in a comparison table with a
recommendation. Pick one and the agent is built in **homage** — first-person voice, in that
figure's school, named after them — grounded in their documented work, never fabricating
quotes. Or skip to an abstract expert. Then a second Workflow **harvests knowledge** from the
figure's own work + the domain's official/academic sources into a cited KB.

**Domain-widening is enforced.** A PRD usually describes one specific product. The skill *never* takes the product name as the agent's domain — instead it widens to the *category* the product lives in, and parks the product as the **Reference Implementation**. So a PRD titled "Member Plus" doesn't produce a "Member Plus expert"; it produces a "merchant-funded loyalty in MENA" expert with Member Plus as one example among many (Bilt, Rakuten, Entertainer, Collinson, Sprive). This is the discipline that keeps the catalog reusable — the agent any team building in this space can install, not a project agent painted as a domain expert.

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

## 4. Contribute

```
/domain-experts:domain-contribute
```

Two auto-detected modes — the skill picks based on whether the slug already lives in the catalog.

### PATCH mode — improving an installed agent

You installed an agent from the catalog. While using it on real work, you spot an improvement — better refusal rule, missing comparable, sharpened verdict vocab.

1. Edit `.claude/agents/<slug>.md` in your venture's project (this is a *project override* — Claude Code uses your edited version instead of the canonical). Test live.
2. Run `/domain-experts:domain-contribute`. It detects the override, diffs vs canonical, asks *"what changed and why?"*, and opens a PR against the catalog.
3. After merge, delete the override — your project pulls the new canonical version.

### PUBLISH mode — shipping a new agent

You built an agent locally with `domain-creator new`, evaluated it, and want it added to the catalog as a new plugin.

1. Build it with `/domain-experts:domain-creator → new` (drops files in your project).
2. Test it. Run `/domain-experts:domain-eval`. Get a PASS.
3. Run `/domain-experts:domain-contribute`. It detects the slug isn't in the catalog yet → publish mode.
4. The skill walks the local KB and asks per top-level dir: **ship** (reusable) or **skip** (venture-specific). `my-venture/` and `decisions/` default to skip; `playbooks/`, `reference/`, `glossary.md` default to ship.
5. It auto-generates `plugin.json` from the agent's frontmatter, plans a marketplace.json delta, asks *"what's this agent for?"*, and opens a PR adding the new plugin.
6. After merge, run `/plugin install <slug>@<marketplace>` to switch from local-build to installed plugin.

### What both modes share

You stay in your venture's working dir the whole time. **No clone, no nav-to-subdir, no manual file copy.** The PR contains exactly the bytes you tested locally.

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
2. Compares it against **11 dimensions** every domain agent should meet — clear decision format, verdict vocabulary, confidence labelling, refusal rules, knowledge base, **domain-vs-project framing** (you reason about a domain, not act as a PM for one product), and **persona homage** (offers to rebuild an abstract agent in homage to a real domain figure — first-person voice, cited works, no fabricated quotes).
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
| Push a local agent improvement back to the catalog as a PR | `/domain-experts:domain-contribute` |
| Open a browser chat UI for an agent (agent-kit) | `/domain-experts:domain-chat` |

---

## Install

Two paths (full detail + the Windows note in the [catalog README](../../README.md#install--30-seconds)):

**A) Developer (clone + setup)** — the clone is your dev copy; edit, `git pull` to update, PR to share:

```bash
git clone https://github.com/onestudio-exp/domain-experts.git ~/.claude/skills/domain-experts \
  && cd ~/.claude/skills/domain-experts && ./setup
```
→ skills appear flat: `/domain-creator`, `/domain-eval`, `/domain-capture`, `/domain-contribute`, `/domain-chat`.

**B) Consumer (plugin marketplace)**:

```
/plugin marketplace add onestudio-exp/domain-experts
/plugin install domain-experts@domain-experts
```
→ skills appear namespaced: `/domain-experts:domain-creator`, etc.

> Examples below use the **B** namespaced form. If you installed via **A**, drop the `domain-experts:` prefix (e.g. `/domain-creator`).

---

## Status

All five skills complete. Reference agent (Nala) validated 11/11. Internal to OneStudio for now.

## Changelog

**Unreleased** *(domain-creator overhaul)*
- **Context discovery** replaces PRD-only prefill: auto-scans + silently reads the venture's high-signal docs (no file-picking question); proposes a professional domain label.
- **Persona homage flow**: interview reordered to domain → persona → identity; a Workflow finds 3 real domain figures (comparison table + recommendation); the agent is named after and built in homage to the chosen figure (first-person, cited, no fabricated quotes).
- **Knowledge harvest (Workflow)**: deep bilingual search + extraction of the figure's works + the domain's official/academic canon into a cited KB, with a 3-tier source gate.
- **Refit parity**: audit grew to **11 dimensions** (adds Persona) and now offers the knowledge harvest; KB scaffold matches create mode.
- **Live source reframed**: default live source is the official domain sources (WebFetch), not the project's code — a domain expert, not a product auditor (spine-level change).
- **Presentation**: data screens render as markdown tables (RTL-friendly) instead of ASCII code blocks.
- **Distribution**: gstack-style `clone + ./setup` install (skills into `~/.claude/skills/`) alongside the plugin marketplace; `bin/team-init` for consumer auto-provisioning.

**v0.5.0**
- New skill: **`/domain-chat`** — opens a browser chat UI for a domain expert. Boots a local [agent-kit](https://github.com/onestudio-exp/agent-kit) install (clones it into the current project, gitignored, on first use), starts the dev server, and opens the browser at the right agent. Zero config — agent-kit auto-discovers the persona, KB, and memory from `.claude/agents/`.
- README updates to reflect the new 5-skill surface.


**v0.2.0** *(2026-05-08)*
- Added 10th audit dimension: **Domain-vs-Project framing**. Refit now flags agents whose description leads with a product, whose body has code-level coupling (file paths / class names / commit hashes), or that lack a `## Comparable peers` section.
- New CREATE-mode framing gate (`Q2.0 — Domain or project?`). The skill refuses to build a project-bound PM agent and explains why.
- New required template sections: `## Reference implementation` (the venture as one example, not the agent's identity) and `## Comparable peers` (3–7 peers in the category).
- New eval check: `cross_venture_applicability` — synthesizes a prompt that asks the agent to advise a peer company from its own Comparable peers list, and verifies that advice transfers in principle.
- Source: 2026-05-08 audit of OneStudio's 13 agents revealed that 6 of them were project-coupled in ways the v0.1 framework didn't catch. v0.2 closes that gap.
- **Known**: Nala (the reference agent in this repo, `agents/nala.md`) was authored against v0.1 and does not yet have `## Reference implementation` or `## Comparable peers` sections. She'll be refit to v0.2 in a follow-up commit so the canonical example passes its own checks.

**v0.1.0** *(initial release)*
- Three skills: `domain-creator`, `domain-eval`, `domain-capture`. Reference agent: Nala.
