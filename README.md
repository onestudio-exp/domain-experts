# domain-experts

OneStudio's catalog of domain expert agents — packaged as a Claude Code multi-plugin marketplace. **One plugin per agent.** Install only what you need.

## What's here

```
domain-experts/
├── .claude-plugin/marketplace.json    # one entry per plugin
├── plugins/
│   ├── domain-experts/                # the toolkit (5 skills + Nala)
│   │   └── README.md                  # toolkit usage guide
│   ├── aref/                          # loyalty / embedded fintech
│   └── ... (more agents land here as owners ship)
└── README.md                          # this file
```

The repo hosts **two kinds of plugins**:

1. **The toolkit** (`plugins/domain-experts/`) — skills for building, evaluating, evolving, and contributing domain expert agents. Install this if you're building or maintaining agents.
2. **Domain expert agents** (`plugins/aref/`, `plugins/fekri/`, etc.) — the agents themselves, each in its own plugin. Install the ones your project needs.

## Available plugins

**1 toolkit + 15 domain expert agents** (see [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json) for the authoritative list + descriptions).

| Plugin | Kind | Use it for |
|---|---|---|
| **domain-experts** | toolkit (v0.5.0) | Build / refit / evaluate / extend / chat-with domain expert agents (5 skills + Nala) |
| **aref** | agent | Merchant-funded loyalty, embedded cashback, MENA payments |
| **wafaa** | agent | GCC corporate gifting governance |
| **fekri** | agent | Iraqi K-12 education |
| **shaheen** | agent | Qatar economy |
| **merchant-advocate** | agent | MENA merchant end-user advocacy / UX pressure-testing |
| **membership** | agent | Loyalty & subscription commerce |
| **omar** | agent | WhatsApp Business marketing for KSA Salla merchants |
| **rushd** | agent | E-commerce cashback / wallet loyalty (Saudi / Salla) |
| **adam** | agent | SaaS competitive intelligence |
| **harvester** | agent | Research intake & knowledge-base curation |
| **sada** | agent | Employee advocacy & internal-comms platforms |
| **abo-lijan** | agent | Election intelligence & polling methodology |
| **sales-marketing** | agent | GCC/MENA B2B revenue (CRO-level) |
| **ziad** | agent | Diplomatic / OSINT intelligence analysis |
| **salwa** | agent | Coworking-space asset management (MENA/GCC, KSA-anchored) |

---

## Install — 30 seconds

Two paths. Pick by whether you'll also *improve* the toolkit.

### A) Developer (or consumer = developer) — clone + `setup`

The clone **is** the install: you run the skills, edit them, `git pull` to update, and
`git push` / PR to share — all from one directory. This is the recommended path while the
toolkit is actively evolving.

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

### B) Pure consumer (team auto-provision) — committed settings, official plugin system

For teammates who only *use* the toolkit (never edit it), bootstrap a project once so
everyone who opens it gets the plugin auto-installed and auto-updated — no manual commands,
no vendored files:

```bash
# from inside your project repo:
~/.claude/skills/domain-experts/bin/team-init required \
  && git add .claude/settings.json && git commit -m "require domain-experts toolkit"
```

This writes `.claude/settings.json` registering the `onestudio-exp/domain-experts`
marketplace (`autoUpdate: true`) and enabling the plugin. On a teammate's first trusted
open, Claude Code prompts them to add the marketplace + enable the plugin, then tracks the
repo each session. (Via the plugin system, skills are namespaced `/domain-experts:domain-creator`.)

Pre-built domain expert agents (aref, salwa, …) still install per-need:
`/plugin install aref@domain-experts`.

### Which invocation do I type?

Same skills, name depends on how you installed:

| Install path | Invoke as |
|---|---|
| **A** clone + `./setup` (skills) | `/domain-creator`, `/domain-eval`, `/domain-capture`, `/domain-contribute`, `/domain-chat` |
| **B** plugin (marketplace) | `/domain-experts:domain-creator`, … (namespaced) |

Examples elsewhere in this doc use the **B** namespaced form; if you installed via **A**, drop the `domain-experts:` prefix.

---

## Per-project memory and KB

Each agent supports per-project state without overlap:

- **Memory** — `memory: project` in the agent's frontmatter auto-creates `.claude/agent-memory/<slug>/MEMORY.md` in your project. Persists across sessions, scoped to the working dir.
- **Project KB extension** — drop venture-specific knowledge under `.claude/agents/<slug>-knowledge/`. The agent reads project KB first, falls back to the plugin's bundled defaults.
- **Project override** — to customize the agent itself, create `.claude/agents/<slug>.md` in your project. Claude Code uses your override instead of the plugin's canonical version.

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

If you installed via **path A** (clone + `./setup`), the clone IS your dev copy — improve the skills in place:

1. `cd ~/.claude/skills/domain-experts && git checkout -b feat/<change>`
2. Edit `plugins/domain-experts/skills/<skill>/SKILL.md` (or `spine/SPINE.md`).
3. Test live. On Windows without Developer Mode, re-run `./setup` after each edit to refresh the copy.
4. `git push` and open a PR to `onestudio-exp/domain-experts:main`. After merge, everyone gets it on their next `git pull && ./setup` (or auto-update for plugin consumers).

The installed plugin cache is **never** edited for development — always work from a clone.

### Improving an agent (the persona / KB)

Owners and consumers discover improvements while using agents on real work. Path of least friction:

1. In your venture's project, edit `.claude/agents/<slug>.md` (the override). Test live.
2. Run `domain-contribute` — it detects the override, diffs against this catalog, asks "what changed and why", opens a PR here.
3. After merge, delete the override; your project pulls the new canonical version.

You stay in your venture's working dir. **No clone, no nav-to-subdir.**

---

## For agent owners — adding your agent to this catalog

1. Refit your agent with `domain-creator → refit`. Pass the 11-dimension audit (incl. dimension 10 — domain-vs-project framing — and dimension 11 — persona homage).
2. Run `domain-eval`. Confirm PASS.
3. Drop your plugin under `plugins/<slug>/`:
   ```
   plugins/<slug>/
   ├── .claude-plugin/plugin.json     # name, version 1.0.0, description
   ├── agents/<slug>.md               # canonical agent definition
   ├── agents/<slug>-knowledge/       # plugin-default KB (REUSABLE only —
   │                                  # no venture-specific content)
   └── examples/<slug>-starter-prompts.yaml
   ```
4. Add an entry to `.claude-plugin/marketplace.json`:
   ```json
   {
     "name": "<slug>",
     "source": "./plugins/<slug>",
     "version": "1.0.0",
     "description": "<one-line domain summary>"
   }
   ```
5. Open a PR. After merge, tag the release: `git tag <slug>--v1.0.0 && git push origin <slug>--v1.0.0`.

Updates ship per-agent. Bumping Aref to v1.1 doesn't touch any other agent. Consumers pull the new version with `/plugin install aref@domain-experts`.

---

## Status

**Marketplace v1.0.0** — full portfolio shipped: the toolkit (5 skills + Nala) + 15 domain expert agents. Two install paths live: gstack-style clone + `./setup` (skills) and the official plugin marketplace (`/plugin install …@domain-experts`). The toolkit's `domain-creator` runs an 11-dimension refit audit (incl. persona homage) and workflow-driven persona discovery + knowledge harvest.

See [`plugins/domain-experts/README.md`](plugins/domain-experts/README.md) for the toolkit's usage guide and lifecycle docs.
