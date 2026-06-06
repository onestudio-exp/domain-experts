# domain-experts

A Claude Code plugin for **building, upgrading, and talking to** domain expert agents.

Three skills. The plugin ships **no agents of its own** — it ships the *discipline* for
building yours: a deep, evidence-driven creation pipeline, a framework audit for
existing agents, and a browser chat surface.

---

## Why not just write an agent file by hand?

Claude Code already lets you drop a markdown file in `.claude/agents/` and call it an
agent. That works — and produces a one-paragraph prompt that *sounds* like an expert.
This plugin exists because a real domain expert is more than a prompt:

| | Hand-rolled agent file | `domain-experts` plugin |
|---|---|---|
| **Domain framing** | Whatever you typed — usually the product you're building | **Domain-widening enforced**: the agent owns the *category*, your product is parked as one Reference Implementation among named peers |
| **Knowledge** | Whatever the base model happens to know | **Harvested KB**: workflow-driven bilingual search over the domain's official/academic canon, written as cited files with a 3-tier source gate |
| **Identity** | A made-up persona, often generic | **Persona homage** (optional): built on a *real, researched domain figure* — first-person voice, cited works, hard fabricated-quote guard |
| **Output quality** | Free-form prose, different every time | **Output schemas from a shared spine**: verdict vocabularies, confidence tags, severity markers, handoff briefs — invariant shapes, tested across production agents |
| **Honesty** | Hopes the model doesn't hallucinate | **Anti-fabrication floor** compiled into every agent: cite per claim, declare uncertainty, never invent quotes/stats/dates |
| **Memory** | None | **Per-project agent memory** (`memory: project`) — durable, committed, scoped |
| **Testability** | None | **Starter prompts** generated per work category, incl. refusal + persona-fidelity tests |
| **Maintenance** | Drifts silently | **`spine_version` stamped** — `/domain-upgrade` detects stale agents and recompiles them onto the current framework |
| **Interview cost** | One blank page | **~3 turns**: context discovery prefills the interview from your venture's own docs, with per-field confidence + source citations |

The short version: a hand-rolled agent is a *prompt*; a domain expert built here is a
**system** — framing + knowledge + schemas + memory + tests, compiled from one shared
spine so every agent you build behaves consistently and stays upgradable.

---

## The skills

```
┌──────────────┐    ┌──────────────┐
│  1. CREATE   │ ─> │  2. UPGRADE  │
│              │    │              │
│ /domain-     │    │ /domain-     │
│  creator     │    │  upgrade     │
└──────────────┘    └──────────────┘
   build a new        audit + uplevel
   agent              an existing agent
```

**Plus a side-channel skill:**

```
┌──────────────┐
│  /domain-    │   talk to the agent through a browser chat UI
│   chat       │   (streaming chat, KB browser, memory CRUD, Workshop)
└──────────────┘
```

Both build skills compile agents from the same **spine**
(`skills/domain-creator/spine/SPINE.md` — the invariant prose and output-schema catalog
every agent shares). `domain-creator` compiles new agents onto it; `domain-upgrade`
audits existing agents against it and recompiles them. One source of truth, no drift.

---

## 1. Create — the deep creation pipeline

```
/domain-experts:domain-creator
```

Not a "describe your agent" form. A pipeline:

### Stage 1 — Context discovery (silent)

The skill auto-scans your venture for *all* high-signal docs (PRD, README, CLAUDE.md,
specs, plans, discovery notes), ranks them by signal density, and reads the top ones
**silently** — no "which files?" question. It then proposes the full framing — domain,
primary user, work categories, reference implementation, comparable peers — each field
tagged with **confidence (🟢/🟡/🔴) and the source line it came from**. You confirm or
edit on one screen. The interview collapses to **~3 forced turns**; everything else is
derived or inherited.

### Stage 2 — Domain widening (enforced, not optional)

A PRD describes one product. The skill **never** takes the product as the agent's
domain — it widens to the *category* the product lives in, parks the product as the
**Reference Implementation**, and requires **3–7 named comparable peers** so the agent
has a real category to reason against. Auto-checks reject any framing that leads with a
product name. If no peers exist, the skill says so and refuses to paint a project agent
as a domain expert.

### Stage 3 — Persona discovery (optional, workflow-driven)

Once the domain is locked, a multi-angle **Workflow** searches bilingually for **3
influential real figures** in that domain — deduped across transliteration variants,
disambiguated by field + era + body of work, ranked by influence corroborated across
≥2 independent sources — and proposes them in a comparison table. Pick one and the
agent is built in **homage**: first-person voice, the figure's school of thought, named
after them, grounded in their documented work. The homage contract is hard: one-time
disclosure, and a "line you never cross" — no invented quote, stat, or position ever
attributed to the figure. Or skip it and build an abstract expert.

### Stage 4 — Knowledge harvest (workflow-driven)

A second **Workflow** deep-searches the figure's own works plus the domain's
official/academic canon and writes a **cited knowledge base**: per-topic folders,
an indexed manifest, a live `sources/official-sources.md` index, and a 3-tier source
gate (official → analyst-grade → synthesis). Empty stays empty until evidence exists —
the harvest never hand-writes "knowledge" from model memory.

### Stage 5 — Spine composition

The agent file is **compiled**, not free-written: a shared spine carries the invariant
expert mechanics (operating principles, anti-fabrication floor, citation discipline,
confidence vocabulary, output-schema catalog, memory + bilingual mechanics, the persona
tribute contract); the template carries only this agent's *delta*. The spine's version
is stamped into the agent's frontmatter, so future spine improvements reach every agent
via `/domain-upgrade` — no copy-paste drift.

### What you get

- **The agent definition** — role, rules, refusals, schemas; self-contained for native Claude Code loading
- **A cited knowledge base** — indexed scaffold + harvested content
- **Starter prompts** — 1–2 per claimed work category plus refusal tests (and persona-fidelity + fabricated-quote tests when a persona was chosen)
- **Per-project memory** — `memory: project` wiring out of the box

---

## 2. Upgrade — audit an existing agent

```
/domain-experts:domain-upgrade
> <your-agent-name>
```

For agents that already exist — hand-rolled, inherited, or built on an older version of
this framework:

1. Locates the agent (by path or slug, across all standard install locations).
2. Audits it against **11 dimensions**: identity, domain framing, primary user,
   categories, output schemas, knowledge, hard rules, behavior, tools/model,
   **domain-vs-project coupling** (regex-level checks for product-led descriptions,
   code coupling, missing comparables), and **persona consistency**. It also flags
   agents compiled against a **stale spine** (`spine_version` drift).
3. Walks you through each gap **one at a time**: *what's there now → what it should be
   → why it matters for this agent*. Accept, edit, or skip each — no bulk-accept.
4. Regenerates the agent onto the current spine. Your custom content is preserved under
   `## Custom additions` — never silently dropped. Missing scaffolding (KB, starter
   prompts) is created; existing KB files are never overwritten.

**When to run it:** the agent's description leads with a product name · the body
references file paths / class names / commit hashes · there's no Comparable peers
section · outputs are inconsistent (mixed verdict words, missing confidence tags) ·
the spine has advanced since the agent was compiled · the agent predates this
framework.

---

## 3. Chat — a real UI for your expert

```
/domain-experts:domain-chat <slug>
```

Boots [agent-kit](https://github.com/onestudio-exp/agent-kit) locally (auto-clones into
the current project, gitignored), starts the dev server, and opens the browser at your
agent — streaming chat, KB browser, memory CRUD, a workshop canvas. **Zero config**:
agent-kit auto-discovers the persona, KB, and memory.

---

## Quick reference: which skill when?

| You want to... | Use |
|---|---|
| Build a new domain expert (from blank or from venture docs) | `/domain-experts:domain-creator` |
| Audit + bring an existing agent up to spec | `/domain-experts:domain-upgrade` |
| Open a browser chat UI for an agent | `/domain-experts:domain-chat` |

---

## Install

Two paths (full detail + the Windows note in the [catalog README](../../README.md#install--30-seconds)):

**A) Developer (clone + setup)** — the clone is your dev copy; edit, `git pull` to update, PR to share:

```bash
git clone https://github.com/onestudio-exp/domain-experts.git ~/.claude/skills/domain-experts \
  && cd ~/.claude/skills/domain-experts && ./setup
```
→ skills appear flat: `/domain-creator`, `/domain-upgrade`, `/domain-chat`.

**B) Consumer (plugin marketplace)**:

```
/plugin marketplace add onestudio-exp/domain-experts
/plugin install domain-experts@domain-experts
```
→ skills appear namespaced: `/domain-experts:domain-creator`, etc.

> Examples in this doc use the **B** namespaced form. If you installed via **A**, drop the `domain-experts:` prefix (e.g. `/domain-creator`).

---

## Status

Three skills complete. The plugin ships no agents of its own — you build them.
Internal to OneStudio for now.

## Changelog

**v2.1.0** — *docs overhaul*
- READMEs rewritten feature-first: "why not just write an agent file by hand?"
  comparison, and the creation flow documented as a 5-stage pipeline (context
  discovery → domain widening → persona discovery → knowledge harvest → spine
  composition).
- Final sweep of named examples in skill bodies — placeholders only.

**v2.0.0** — *3-skill surface; refit split out; all bundled examples removed*
- **Split refit out of `domain-creator` into its own skill: `/domain-upgrade`.** Create and
  upgrade are now fully separate skills. `domain-upgrade` owns the 11-dimension audit, the
  one-change-per-turn walkthrough, the rewrite, and stale-spine detection. It reads the
  shared framework assets (spine, agent template, CONTRACT, KB templates) from the sibling
  `domain-creator` skill directory — one source of truth, no drifting copies.
- **Removed `domain-eval`, `domain-capture`, and `domain-contribute`.** The toolkit
  surface is now create / upgrade / chat. The KB templates no longer instruct users to run
  the removed skills (capture conventions are documented inline in the generated INDEX.md).
  Also removed the Python eval tooling that existed to serve `domain-eval`.
- **Removed every named example agent from docs and skills.** Skill examples use
  placeholders (`<product-name>`, `<Figure Name>`); patterns are described by shape,
  never by author.

**v1.0.0** — *first stable release; breaking layout changes*
- **Removed the bundled reference agent.** The toolkit no longer ships any agent — every
  file under `agents/` was being loaded by Claude Code as an invokable subagent, which
  confused agent selection. The one piece of reusable guidance from its KB (the "don't
  dump live sources here" anti-pattern) moved into the KB index template.
- **Fixed spine packaging.** `SPINE.md`, `CONTRACT.md`, and `PLAYBOOK.md` lived at the repo
  root, so they did **not** ship with the marketplace plugin — `domain-creator` could not
  compose agents on a plugin install. They now live inside the `domain-creator` skill
  (`spine/SPINE.md`, `references/CONTRACT.md`, `references/PLAYBOOK.md`); the ~14 path
  references were rewritten skill-relative so both install modes work.
- **One install entrypoint.** Folded `bin/team-init` into `setup` as `./setup team-init`
  and removed the `bin/` dir. The repo root is now just `setup`, `README.md`, `plugins/`,
  and config.
- **Context discovery** replaces PRD-only prefill: auto-scans + silently reads the venture's high-signal docs (no file-picking question); proposes a professional domain label.
- **Persona homage flow**: interview reordered to domain → persona → identity; a Workflow finds 3 real domain figures (comparison table + recommendation); the agent is named after and built in homage to the chosen figure (first-person, cited, no fabricated quotes).
- **Knowledge harvest (Workflow)**: deep bilingual search + extraction of the figure's works + the domain's official/academic canon into a cited KB, with a 3-tier source gate.
- **Refit parity**: audit grew to **11 dimensions** (adds Persona) and now offers the knowledge harvest; KB scaffold matches create mode.
- **Live source reframed**: default live source is the official domain sources (WebFetch), not the project's code — a domain expert, not a product auditor (spine-level change).
- **Presentation**: data screens render as markdown tables (RTL-friendly) instead of ASCII code blocks.
- **Distribution**: gstack-style `clone + ./setup` install (skills into `~/.claude/skills/`) alongside the plugin marketplace; `./setup team-init` for consumer auto-provisioning.

**v0.5.0**
- New skill: **`/domain-chat`** — opens a browser chat UI for a domain expert. Boots a local [agent-kit](https://github.com/onestudio-exp/agent-kit) install (clones it into the current project, gitignored, on first use), starts the dev server, and opens the browser at the right agent. Zero config — agent-kit auto-discovers the persona, KB, and memory from `.claude/agents/`.
- README updates to reflect the then 5-skill surface.

**v0.2.0** *(2026-05-08)*
- Added 10th audit dimension: **Domain-vs-Project framing**. The audit now flags agents whose description leads with a product, whose body has code-level coupling (file paths / class names / commit hashes), or that lack a `## Comparable peers` section.
- New CREATE-mode framing gate (`Q2.0 — Domain or project?`). The skill refuses to build a project-bound PM agent and explains why.
- New required template sections: `## Reference implementation` (the venture as one example, not the agent's identity) and `## Comparable peers` (3–7 peers in the category).
- New eval check: `cross_venture_applicability` — synthesizes a prompt that asks the agent to advise a peer company from its own Comparable peers list, and verifies that advice transfers in principle.
- Source: a 2026-05-08 audit of 13 production agents revealed that 6 of them were project-coupled in ways the v0.1 framework didn't catch. v0.2 closes that gap.

**v0.1.0** *(initial release)*
- Three skills: `domain-creator`, `domain-eval`, `domain-capture`, plus a bundled reference agent (since removed).
