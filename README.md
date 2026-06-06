# domain-experts

OneStudio's toolkit for building domain expert agents — packaged as a Claude Code plugin. **One plugin: 5 skills + Nala, a reference agent.**

## What's here

```
domain-experts/
├── .claude-plugin/marketplace.json    # one plugin entry (the toolkit)
├── plugins/
│   └── domain-experts/                # the toolkit (5 skills + Nala)
│       └── README.md                  # toolkit usage guide
└── README.md                          # this file
```

The repo hosts **one plugin — the toolkit** (`plugins/domain-experts/`): skills for building, evaluating, evolving, contributing, and chatting with domain expert agents, plus **Nala**, a venture-building reference agent built with the toolkit.

## The toolkit

| Plugin | Version | Use it for |
|---|---|---|
| **domain-experts** | 0.5.0 | Build / refit / evaluate / extend / chat-with domain expert agents (5 skills + Nala) |

The five skills:

- **`domain-creator`** — build a new agent (from blank or a PRD) or uplevel an existing one (11-dimension refit audit).
- **`domain-eval`** — test an agent against its declared schema, vocabulary, and rules.
- **`domain-capture`** — add evidence-backed knowledge to an agent.
- **`domain-contribute`** — push a local agent improvement back to its source repo.
- **`domain-chat`** — open a browser chat UI for an agent via [agent-kit](https://github.com/onestudio-exp/agent-kit).

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

Skills appear namespaced: **`/domain-experts:domain-creator`**, `/domain-experts:domain-eval`,
`/domain-experts:domain-capture`, `/domain-experts:domain-contribute`, `/domain-experts:domain-chat`.

- **Update:** `/plugin marketplace update domain-experts` — then Claude Code installs the new
  version on the next session. (Or browse + manage everything with `/plugin`.)
- **Remove:** `/plugin uninstall domain-experts@domain-experts`.

**Team auto-provision (optional).** To make every teammate get the plugin auto-installed and
auto-updated when they open a project — no manual commands — commit a settings file once:

```bash
# from inside your project repo (needs a local clone of this repo — see mode B):
/path/to/domain-experts/bin/team-init required \
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
flat slash commands: **`/domain-creator`**, `/domain-eval`, `/domain-capture`,
`/domain-contribute`, `/domain-chat`.

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
| **B** clone + `./setup` (skills) | `/domain-creator`, `/domain-eval`, `/domain-capture`, `/domain-contribute`, `/domain-chat` |

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
2. Edit `plugins/domain-experts/skills/<skill>/SKILL.md` (or `spine/SPINE.md`).
3. Test live. On Windows without Developer Mode, re-run `./setup` after each edit to refresh the copy.
4. `git push` and open a PR to `onestudio-exp/domain-experts:main`. After merge, everyone gets it on their next `git pull && ./setup` (or auto-update for plugin consumers).

The installed plugin cache is **never** edited for development — always work from a clone.

### Improving an agent you built (the persona / KB)

You discover improvements while using an agent on real work. Path of least friction:

1. In your venture's project, edit `.claude/agents/<slug>.md` (the override). Test live.
2. Run `domain-contribute` — it detects the override, diffs against the agent's source repo, asks "what changed and why", opens a PR there.
3. After merge, delete the override; your project pulls the new canonical version.

You stay in your venture's working dir. **No clone, no nav-to-subdir.**

---

## Status

**Toolkit v0.5.0** — 5 skills + Nala (reference agent). Two install modes live: the official plugin marketplace (`/plugin install domain-experts@domain-experts`) and a gstack-style clone + `./setup` (skills). `domain-creator` runs an 11-dimension refit audit (incl. persona homage) and workflow-driven persona discovery + knowledge harvest.

See [`plugins/domain-experts/README.md`](plugins/domain-experts/README.md) for the toolkit's usage guide and lifecycle docs.
