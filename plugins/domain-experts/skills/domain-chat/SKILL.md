---
name: domain-chat
description: Open a browser chat UI for a domain expert agent. Boots a local agent-kit dev server (clones it into the project if absent, gitignored) and opens the browser at the right agent. Use when the user wants to TALK to an expert through a real chat surface — streaming chat, KB browser, memory CRUD, Workshop — instead of through Claude Code's text interface. Examples that trigger: "chat with <expert>", "open <expert> in the browser", "launch the chat UI", "start the chat for <slug>". Do NOT use to create a new agent (that's domain-creator) or to audit/uplevel one (that's domain-upgrade).
---

# /domain-chat

Open a browser chat UI for a domain expert.

This skill spawns / re-uses a local [agent-kit](https://github.com/onestudio-exp/agent-kit) install and opens the browser. agent-kit auto-discovers the agent's persona, KB, and memory — no config needed.

## When to invoke

- User wants to **talk to** an expert through a real chat UI, not via Claude Code's text turns.
- User wants to **browse** the expert's KB or memory through a UI.
- User wants to **show** an expert to someone else (agent-kit runs on localhost; you can share via screen share or `*.test` Caddy if configured).

## When NOT to invoke

- User wants to **create** a new agent → use `domain-creator`.
- User wants to **audit / uplevel** an agent → use `domain-upgrade`.

## How to run

### Step 1 — pick the agent

If the user gave a slug in their message (e.g. `/domain-chat my-expert`), use that.

Otherwise, find candidate agents by scanning:

```bash
ls .claude/agents/*.md 2>/dev/null
ls plugins/*/agents/*.md 2>/dev/null
ls ~/.claude/agents/*.md 2>/dev/null
```

- **One candidate** → use it, tell the user which one you picked.
- **Multiple** → list them and ask which.
- **None** → tell the user: "No persona files found. Create one with `/domain-creator` first." Stop.

### Step 2 — boot agent-kit

Check whether a local copy is already cloned at `./agent-kit/`:

```bash
test -d agent-kit/.git && echo "exists" || echo "absent"
```

If **absent**:

1. Clone:
   ```bash
   git clone https://github.com/onestudio-exp/agent-kit.git agent-kit
   ```
2. Add to project `.gitignore` (skip if already there):
   ```bash
   grep -qxF '/agent-kit/' .gitignore || echo '/agent-kit/' >> .gitignore
   ```
3. Install:
   ```bash
   cd agent-kit && npm install
   ```

If **present**: pull latest (optional, ask user) — `cd agent-kit && git pull --ff-only`.

### Step 3 — verify auth

Run the doctor:

```bash
cd agent-kit && npm run doctor
```

If doctor fails on auth, tell the user the exact fix: either set `ANTHROPIC_API_KEY` in `agent-kit/.env.local`, or install Claude Code and run `claude login`. Then re-run doctor.

### Step 4 — start the dev server

Check whether something is already on port 3737:

```bash
lsof -nP -iTCP:3737 -sTCP:LISTEN 2>/dev/null | tail -n +2
```

- If a previous agent-kit run is already there → re-use it.
- Otherwise start in the background:
   ```bash
   cd agent-kit && (npm run dev > /tmp/agent-kit-dev.log 2>&1 &)
   ```
   Wait until `http://localhost:3737/` returns HTTP 200:
   ```bash
   until curl -sf -o /dev/null http://localhost:3737/; do sleep 0.5; done
   ```

### Step 5 — open the browser at the right agent

```bash
# macOS:
open "http://localhost:3737/?agent=<slug>"
# Linux:
xdg-open "http://localhost:3737/?agent=<slug>"
# Windows:
start "http://localhost:3737/?agent=<slug>"
```

If the project is using Caddy `*.test` routing, the URL `https://agent-kit.test/?agent=<slug>` also works and is auto-registered on first localhost open by the user's local setup (if present).

### Step 6 — confirm to the user

Tell the user, in one short message:

- The URL to open (HTTPS form if `*.test` Caddy is set up, otherwise localhost)
- Which agent they're chatting with (display name)
- How to stop the dev server when done: `kill $(lsof -tiTCP:3737 -sTCP:LISTEN)`

Stop. Do not start any conversation with the agent on the user's behalf.

## What agent-kit picks up automatically

Once running, agent-kit auto-discovers from the current project root:

| Thing | Looks for |
|---|---|
| Persona | `.claude/agents/<slug>.md` (also `plugins/*/agents/<slug>.md` and `~/.claude/agents/`) |
| KB | `<slug>-knowledge/` sibling of the persona file |
| Memory | `<project>/.claude/agent-memory/<slug>/memories/` (auto-created) |
| Display name | YAML frontmatter `name` + optional `name_ar` |
| Model default | YAML frontmatter `model: opus|sonnet|haiku` |

No edits to any config file needed.

## Anti-patterns

- **Don't auto-stop the dev server when the user is done.** Leave it running; tell them how to kill it. They may want to keep chatting.
- **Don't clone agent-kit outside the current project.** Cloning into `./agent-kit/` keeps the install scoped to where the agent lives.
- **Don't edit agent-kit's source.** It's auto-discovery — nothing to edit. If something doesn't work, run `npm run doctor` in `agent-kit/` and read the output.
- **Don't open multiple browser tabs in a loop.** One open call per invocation.
- **Don't start a chat for the user.** The skill's job is to open the UI; the conversation is the user's, not yours.
