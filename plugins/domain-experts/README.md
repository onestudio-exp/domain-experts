# domain-experts — A PM's guide

A Claude Code plugin for **building, upgrading, and talking to** domain expert agents.

Three skills. The plugin ships **no agents of its own** — you build them. To make each step
concrete, this guide follows one running example: **Nala**, a *hypothetical* MENA/KSA Venture
Builder expert. Nala is a walkthrough device, not a bundled agent.

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

Any time the user wants to *talk* to one of these agents — not via Claude Code's text turns but through a real chat surface, with the KB and memory visible alongside — run `/domain-chat`. It boots [agent-kit](https://github.com/onestudio-exp/agent-kit) locally (auto-clones into the current project, gitignored) and opens the browser at the right agent. **Zero config** — agent-kit auto-discovers the persona, KB, and memory.

Both build skills compile agents from the same **spine** (`skills/domain-creator/spine/SPINE.md` — the invariant prose and output-schema catalog every agent shares). `domain-creator` compiles new agents onto it; `domain-upgrade` audits existing agents against it and recompiles them. One source of truth, no drift.

---

## 1. Create

```
/domain-experts:domain-creator
```

Builds a brand-new agent from ~10 short questions. Most have one-keystroke defaults — accept them and move on.

**In our running example:** to build Nala we ran the skill. It asked who she serves, what her domain is, what kinds of work she does (decision support? structured reviews? competitor profiling?), what verdicts she's allowed to give, and how she should refuse to invent facts. About 10 minutes start to finish.

It produced three things:

- **The agent itself** — Nala's role, rules, and refusals
- **A knowledge base** — an indexed scaffold (INDEX.md + per-topic folders: regulations, frameworks, market-data, cultural-context, …), seeded and — when a persona is chosen — populated by the knowledge-harvest Workflow with cited frameworks + an official-sources index
- **A set of starter prompts** — example questions the agent should answer well (incl. persona-fidelity + fabricated-quote refusal tests)

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

**Domain-widening is enforced.** A PRD usually describes one specific product. The skill *never* takes the product name as the agent's domain — instead it widens to the *category* the product lives in, and parks the product as the **Reference Implementation**. So a PRD titled "Member Plus" doesn't produce a "Member Plus expert"; it produces a "merchant-funded loyalty in MENA" expert with Member Plus as one example among many (Bilt, Rakuten, Entertainer, Collinson, Sprive). This is the discipline that keeps agents reusable — an agent any team building in this space can install, not a project agent painted as a domain expert.

> **Already have an agent?** Don't start over — run `/domain-experts:domain-upgrade`.

---

## 2. Upgrade

```
/domain-experts:domain-upgrade
> <your-agent-name>
```

Audits an existing agent and uplevels it — its own skill, fully separate from create.

**What it does, in plain language:**

1. Reads your existing agent (by path or slug — it searches all the standard install locations).
2. Compares it against **11 dimensions** every domain agent should meet — clear decision format, verdict vocabulary, confidence labelling, refusal rules, knowledge base, **domain-vs-project framing** (you reason about a domain, not act as a PM for one product), and **persona homage** (offers to rebuild an abstract agent in homage to a real domain figure — first-person voice, cited works, no fabricated quotes). It also checks the agent's `spine_version` and flags agents compiled against a stale spine.
3. Walks you through each gap **one at a time**, showing you *what's there now → what it should be → why it matters*.
4. You accept, edit, or skip each suggestion independently.
5. At the end, the agent file is regenerated onto the current spine, and any missing scaffolding (knowledge base folders, starter prompts) is created for you. Custom content you wrote is preserved under `## Custom additions` — never silently dropped.

**When to upgrade your agent:**

- Your agent's description leads with a product name (e.g. *"…for Member Plus"*) instead of a domain.
- The body references specific code: file paths, class names, commit hashes — that's a project agent, not a domain expert.
- The agent has no `## Comparable peers` section listing 3+ peer products in the category. Without comparables, the agent has nothing to reason against.
- It sometimes makes things up, or invents details that aren't in any source.
- Its outputs feel inconsistent — different verdict words, missing severity tags, no citations.
- The spine has advanced since the agent was compiled (`spine_version` in its frontmatter is older).
- It was written before this framework existed.

---

## Quick reference: which skill when?

| You want to... | Use |
|---|---|
| Build a new domain expert from scratch (or from a PRD) | `/domain-experts:domain-creator` |
| Audit + bring an existing agent up to spec | `/domain-experts:domain-upgrade` |
| Open a browser chat UI for an agent (agent-kit) | `/domain-experts:domain-chat` |

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

Three skills complete. The plugin ships no agents of its own — Nala is a hypothetical
example used in this guide. Internal to OneStudio for now.

## Changelog

**v2.0.0** — *3-skill surface; refit split out*
- **Split refit out of `domain-creator` into its own skill: `/domain-upgrade`.** Create and
  upgrade are now fully separate skills. `domain-upgrade` owns the 11-dimension audit, the
  one-change-per-turn walkthrough, the rewrite, and stale-spine detection. It reads the
  shared framework assets (spine, agent template, CONTRACT, KB templates) from the sibling
  `domain-creator` skill directory — one source of truth, no drifting copies.
- **Removed `domain-eval`, `domain-capture`, and `domain-contribute`.** The toolkit
  surface is now create / upgrade / chat. The KB templates no longer instruct users to run
  the removed skills (capture conventions are documented inline in the generated INDEX.md).
  Also removed the Python eval tooling (`scripts/`, `pyproject.toml`, `uv.lock`) that
  existed to serve `domain-eval`.

**v1.0.0** — *first stable release; breaking layout changes*
- **Removed the bundled Nala agent.** The toolkit no longer ships any agent — every file
  under `agents/` was being loaded by Claude Code as an invokable subagent, which confused
  agent selection. Nala now survives only as the hypothetical worked example in this guide.
  The one piece of reusable guidance from her KB (the "don't dump live sources here"
  anti-pattern) moved into the KB index template.
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
- Added 10th audit dimension: **Domain-vs-Project framing**. Refit now flags agents whose description leads with a product, whose body has code-level coupling (file paths / class names / commit hashes), or that lack a `## Comparable peers` section.
- New CREATE-mode framing gate (`Q2.0 — Domain or project?`). The skill refuses to build a project-bound PM agent and explains why.
- New required template sections: `## Reference implementation` (the venture as one example, not the agent's identity) and `## Comparable peers` (3–7 peers in the category).
- New eval check: `cross_venture_applicability` — synthesizes a prompt that asks the agent to advise a peer company from its own Comparable peers list, and verifies that advice transfers in principle.
- Source: 2026-05-08 audit of OneStudio's 13 agents revealed that 6 of them were project-coupled in ways the v0.1 framework didn't catch. v0.2 closes that gap.
- **Known** *(historical — Nala was the bundled reference agent at this version; removed in v1.0.0)*: Nala was authored against v0.1 and lacked `## Reference implementation` and `## Comparable peers` sections.

**v0.1.0** *(initial release)*
- Three skills: `domain-creator`, `domain-eval`, `domain-capture`. Reference agent: Nala.
