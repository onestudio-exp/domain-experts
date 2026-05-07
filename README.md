# domain-experts

OneStudio's catalog of domain expert agents — packaged as a Claude Code multi-plugin marketplace. **One plugin per agent.** Install only what you need.

## What's here

```
domain-experts/
├── .claude-plugin/marketplace.json    # one entry per plugin
├── plugins/
│   ├── domain-experts/                # the toolkit (4 skills + Nala)
│   │   └── README.md                  # toolkit usage guide
│   ├── aref/                          # loyalty / embedded fintech
│   └── ... (more agents land here as owners ship)
└── README.md                          # this file
```

The repo hosts **two kinds of plugins**:

1. **The toolkit** (`plugins/domain-experts/`) — skills for building, evaluating, evolving, and contributing domain expert agents. Install this if you're building or maintaining agents.
2. **Domain expert agents** (`plugins/aref/`, `plugins/fekri/`, etc.) — the agents themselves, each in its own plugin. Install the ones your project needs.

## Available plugins

| Plugin | Kind | Status | Use it for |
|---|---|---|---|
| **domain-experts** | toolkit | v0.3.0-dev | Building / maintaining domain expert agents |
| **aref** | agent | v1.0.0 | Merchant-funded loyalty, embedded cashback, MENA payments |

*(More agents land here as owners refit to v0.2 of the toolkit and pass the structural audit, including the dimension-10 framing check.)*

---

## Install

Add the marketplace once:

```
/plugin marketplace add onestudio-exp/domain-experts
```

Then install only what you need:

```
# The toolkit (only if you're building agents)
/plugin install domain-experts@domain-experts

# A domain expert agent
/plugin install aref@domain-experts

# Multiple in one go
/plugin install aref@domain-experts <other-agent>@domain-experts

/reload-plugins
```

After install, agents appear via the Agent tool (e.g. `subagent_type: aref`) or as direct slash commands. Toolkit skills appear as `/domain-experts:domain-creator`, `/domain-experts:domain-eval`, `/domain-experts:domain-capture`, `/domain-experts:domain-contribute`.

---

## Per-project memory and KB

Each agent supports per-project state without overlap:

- **Memory** — `memory: project` in the agent's frontmatter auto-creates `.claude/agent-memory/<slug>/MEMORY.md` in your project. Persists across sessions, scoped to the working dir.
- **Project KB extension** — drop venture-specific knowledge under `.claude/agents/<slug>-knowledge/`. The agent reads project KB first, falls back to the plugin's bundled defaults.
- **Project override** — to customize the agent itself, create `.claude/agents/<slug>.md` in your project. Claude Code uses your override instead of the plugin's canonical version.

---

## Contributing improvements back

Owners and consumers discover improvements while using agents on real work. Path of least friction:

1. In your venture's project, edit `.claude/agents/<slug>.md` (the override). Test live.
2. Run `/domain-experts:domain-contribute` — it detects the override, diffs against this catalog, asks "what changed and why", opens a PR here.
3. After merge, delete the override; your project pulls the new canonical version.

You stay in your venture's working dir. **No clone, no nav-to-subdir.**

---

## For agent owners — adding your agent to this catalog

1. Refit your agent with `/domain-experts:domain-creator → refit`. Pass the v0.2 audit (incl. dimension 10 — domain-vs-project framing).
2. Run `/domain-experts:domain-eval`. Confirm PASS.
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

**Marketplace v0.3.0-dev** — restructured today from single-plugin to multi-plugin layout. Toolkit + Aref pilot live. The remaining 12 OneStudio agents will be added as their owners pass the structural audit.

See [`plugins/domain-experts/README.md`](plugins/domain-experts/README.md) for the toolkit's usage guide and lifecycle docs.
