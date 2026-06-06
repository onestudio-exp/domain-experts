# domain-experts

OneStudio's toolkit for building domain expert agents — packaged as a Claude Code plugin. **One plugin, 3 skills. It ships no agents of its own — you build them.**

## Why not just write an agent file by hand?

Claude Code lets you drop a markdown file in `.claude/agents/` and call it an agent.
That gives you a *prompt*. This plugin gives you a **system**:

- **Deep creation, not a blank page** — the skill auto-reads your venture's docs (PRD,
  README, specs) and prefills the whole framing with per-field confidence + source
  citations. The interview collapses to ~3 turns.
- **Domain-widening, enforced** — the agent owns the *category*, never your product.
  Your product becomes one Reference Implementation among 3–7 named comparable peers,
  so the agent has a real category to reason against and stays reusable across ventures.
- **Persona homage (optional)** — a workflow researches real influential figures in the
  domain (bilingually, ≥2 independent sources) and builds the agent in their school of
  thought — cited works, hard fabricated-quote guard.
- **Harvested, cited knowledge** — a workflow pulls the domain's official/academic canon
  into a per-topic KB with a 3-tier source gate. No "knowledge" from model memory.
- **A shared spine** — anti-fabrication floor, citation discipline, confidence
  vocabulary, and tested output schemas are *compiled* into every agent from one
  versioned source. Fix the spine once, `/domain-upgrade` recompiles every agent.
- **Testable + maintainable** — generated starter prompts (incl. refusal tests),
  per-project memory, and an 11-dimension audit that catches drift.

Full comparison table in the [toolkit README](plugins/domain-experts/README.md#why-not-just-write-an-agent-file-by-hand).

## What's here

```
domain-experts/
├── .claude-plugin/marketplace.json    # one plugin entry (the toolkit)
├── plugins/
│   └── domain-experts/                # the toolkit (3 skills)
│       └── README.md                  # toolkit usage guide
└── README.md                          # this file
```

The repo hosts **one plugin — the toolkit** (`plugins/domain-experts/`): skills for building, upgrading, and chatting with domain expert agents. It ships no agents itself — you build your own with it.

## The toolkit

| Plugin | Version | Use it for |
|---|---|---|
| **domain-experts** | 2.0.0 | Build / upgrade / chat-with domain expert agents (3 skills) |

The three skills:

- **`domain-creator`** — the deep creation pipeline: context discovery → domain widening → persona discovery (workflow) → knowledge harvest (workflow) → spine composition. Output: agent definition + cited KB + starter prompts + memory wiring.
- **`domain-upgrade`** — audit an existing agent against the framework's 11 dimensions (incl. product-coupling regex checks and stale-`spine_version` detection) and recompile it, preserving custom content.
- **`domain-chat`** — open a browser chat UI for an agent via [agent-kit](https://github.com/onestudio-exp/agent-kit): streaming chat, KB browser, memory CRUD. Zero config.

---

## Install — 30 seconds

Two modes. Pick by whether you'll also *improve* the toolkit.

### A) Normal — official Claude Code plugin marketplace

The standard path for anyone who just wants to *use* the toolkit. Inside Claude Code,
add the marketplace once, then install the plugin:

```text
/plugin marketplace add onestudio-exp/domain-experts
/plugin install domain-experts@domain-experts
```

Skills appear namespaced: **`/domain-experts:domain-creator`**, `/domain-experts:domain-upgrade`,
`/domain-experts:domain-chat`.

- **Update:** `/plugin marketplace update domain-experts` — then Claude Code installs the new
  version on the next session. (Or browse + manage everything with `/plugin`.)
- **Remove:** `/plugin uninstall domain-experts@domain-experts`.

**Team auto-provision (optional).** To make every teammate get the plugin auto-installed and
auto-updated when they open a project — no manual commands — commit a settings file once:

```bash
# from inside your project repo (needs a local clone of this repo — see mode B):
/path/to/domain-experts/setup team-init required \
  && git add .claude/settings.json && git commit -m "require domain-experts toolkit"
```

This writes `.claude/settings.json` registering the `onestudio-exp/domain-experts` marketplace
(`autoUpdate: true`) and enabling the plugin. On a teammate's first trusted open, Claude Code
prompts them to add the marketplace + enable the plugin, then tracks the repo each session.

### B) Developer — clone + `setup`

For anyone who will also *edit* the toolkit. The clone **is** the install: you run the skills,
edit them, `git pull` to update, and `git push` / PR to share — all from one directory.

```bash
git clone https://github.com/onestudio-exp/domain-experts.git ~/.claude/skills/domain-experts \
  && cd ~/.claude/skills/domain-experts && ./setup
```

`setup` registers the toolkit skills into `~/.claude/skills/`, so they appear as
flat slash commands: **`/domain-creator`**, `/domain-upgrade`, `/domain-chat`.

- **Live edits** require symlink support. macOS/Linux: automatic. **Windows: turn on
  Developer Mode** (Settings → Privacy & security → For developers), then `./setup --link`.
  Without it, `setup` copies (works, but re-run `./setup` after each edit).
- **Update:** `git -C ~/.claude/skills/domain-experts pull && ~/.claude/skills/domain-experts/setup`
- **Remove:** `./setup --uninstall`
- Flags: `--prefix` (namespace as `domain-experts-<skill>`) · `--local` (install into
  `./.claude/skills` of the current project) · `--status`.

### Which invocation do I type?

Same skills, name depends on how you installed:

| Install mode | Invoke as |
|---|---|
| **A** plugin (marketplace) | `/domain-experts:domain-creator`, … (namespaced) |
| **B** clone + `./setup` (skills) | `/domain-creator`, `/domain-upgrade`, `/domain-chat` |

Examples elsewhere in this doc use the **A** namespaced form; if you installed via **B**, drop the `domain-experts:` prefix.

---

## Per-project memory and KB

Each agent you build supports per-project state without overlap:

- **Memory** — `memory: project` in the agent's frontmatter auto-creates `.claude/agent-memory/<slug>/MEMORY.md` in your project. Persists across sessions, scoped to the working dir.
- **Project KB extension** — drop venture-specific knowledge under `.claude/agents/<slug>-knowledge/`. The agent reads project KB first, falls back to the plugin's bundled defaults.
- **Project override** — to customize the agent itself, create `.claude/agents/<slug>.md` in your project. Claude Code uses your override instead of the canonical version.

---

## Chatting with an agent in the browser

Sometimes you want a real chat UI — streaming chat, sessions, KB browser, memory CRUD, a workshop canvas — instead of Claude Code's text turns. We ship that too, via [agent-kit](https://github.com/onestudio-exp/agent-kit).

```
/domain-experts:domain-chat <slug>
```

What it does:

1. Clones agent-kit into your project at `./agent-kit/`, gitignored (first run only).
2. Installs deps, runs `npm run doctor`, starts the dev server on port 3737.
3. Opens the browser at `http://localhost:3737/?agent=<slug>`.

No config. agent-kit auto-discovers any persona at `.claude/agents/<slug>.md` (or under `plugins/<x>/agents/`), the matching `<slug>-knowledge/` KB folder, and creates a `<project>/.claude/agent-memory/<slug>/` folder for memory on first chat. Memory survives re-cloning agent-kit.

---

## Contributing improvements back

### Improving the toolkit itself (the skills)

If you installed via **mode B** (clone + `./setup`), the clone IS your dev copy — improve the skills in place:

1. `cd ~/.claude/skills/domain-experts && git checkout -b feat/<change>`
2. Edit `plugins/domain-experts/skills/<skill>/SKILL.md` (the agent spine lives at `plugins/domain-experts/skills/domain-creator/spine/SPINE.md`).
3. Test live. On Windows without Developer Mode, re-run `./setup` after each edit to refresh the copy.
4. `git push` and open a PR to `onestudio-exp/domain-experts:main`. After merge, everyone gets it on their next `git pull && ./setup` (or auto-update for plugin consumers).

The installed plugin cache is **never** edited for development — always work from a clone.

### Improving an agent you built (the persona / KB)

You discover improvements while using an agent on real work:

1. In your venture's project, edit `.claude/agents/<slug>.md` (the override if the agent is installed from a repo; the file itself if it lives in your project). Test live.
2. Run `/domain-experts:domain-upgrade` afterwards if you want the edit audited against the framework's 11 dimensions.
3. If the agent's canonical home is another repo, open a PR there with your tested change; after merge, delete the local override.

---

## Status

**Toolkit v2.0.0** — 3 skills (create / upgrade / chat), no bundled agents (you build your own). Two install modes live: the official plugin marketplace (`/plugin install domain-experts@domain-experts`) and a gstack-style clone + `./setup` (skills). `domain-creator` runs workflow-driven persona discovery + knowledge harvest; `domain-upgrade` runs the 11-dimension audit (incl. persona homage) and recompiles agents onto the current spine.

See [`plugins/domain-experts/README.md`](plugins/domain-experts/README.md) for the toolkit's usage guide and lifecycle docs.
