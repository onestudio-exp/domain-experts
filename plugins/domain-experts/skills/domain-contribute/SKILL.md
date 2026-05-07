---
name: domain-contribute
description: Contribute a local edit of a domain expert agent back to the catalog repo it came from — without leaving the user's project. Detects when the cwd has a `.claude/agents/<slug>.md` that diverges from the plugin's canonical version, shows the diff, branches the catalog repo, opens a PR with the change, and (optionally) cleans up the local override after merge. Use when an owner has improved an agent in-flight and wants to ship the change back upstream without manually cloning the catalog.
---

# /domain-contribute

Ship a local agent improvement back to its catalog repo. No clone, no nav-to-subdir.

## When to invoke

- Owner edited `.claude/agents/<slug>.md` in their venture's project to improve the agent and wants to push the improvement upstream.
- Eval surfaced a fix; owner patched the local override; ready to land it in the catalog.
- Knowledge / vocab / refusal rule learned in production should become canonical.

## When NOT to invoke

- For adding new evidence/knowledge to an agent → `domain-capture`.
- For creating a new agent → `domain-creator new`.
- For upleveling an existing agent (audit + rewrite) → `domain-creator refit`.
- When the project doesn't have a `.claude/agents/<slug>.md` — there's nothing to contribute. Tell the user to edit the override first, test, then run this skill.

## How to run

1. **Find the override.** Look for `.claude/agents/*.md` in cwd. If multiple, ask which.
2. **Resolve the catalog.** From the agent's slug, find which installed plugin shipped the canonical version (search the plugin cache, parse marketplace metadata).
3. **Diff.** Show the user the diff between their override and the canonical.
4. **One question:** what changed and why? Capture as a one-line PR title + a 3–7 line PR body.
5. **Confirm before pushing.** Show the planned branch + commit + PR title.
6. **`gh pr create`** — branch the catalog repo, commit the agent file change, open the PR.
7. **Offer cleanup** — once the PR is open (or merged), offer to delete the local override so the project pulls the canonical version going forward.

## Phase 1 — Locate the override

Search for `.claude/agents/*.md` in cwd.

```
0 files       → "No local agent override found. Edit `.claude/agents/<slug>.md`
                first, test it, then re-run this skill."
1 file        → use it; capture `slug` (filename without .md).
2+ files      → list them; ask which to contribute.
```

Capture: `override_path`, `override_content`, `slug`.

Skip if the override is byte-identical to the canonical version (nothing to contribute):

```
diff --quiet <override_path> <canonical_path>
→ if equal: tell the user "Override matches the canonical version — nothing to
  contribute. If you intended to make changes, edit the override first."
```

## Phase 2 — Resolve the catalog

Find which marketplace + plugin shipped this agent.

**Search order for the canonical agent file:**

```
1. ~/.claude/plugins/cache/<marketplace>/<plugin>/agents/<slug>.md
2. ~/.claude/plugins/cache/<marketplace>/<plugin>/plugins/<plugin>/agents/<slug>.md  (multi-plugin marketplaces)
3. <user-configured plugin source paths>
```

Parse the **marketplace metadata** to find the source repo URL:

```
~/.claude/plugins/cache/<marketplace>/.claude-plugin/marketplace.json
  → look up the matching plugin entry
  → its `source` field, combined with the marketplace `repo` URL,
    gives you: `<repo_url>` + relative path to the plugin
```

If the marketplace cache does NOT carry a remote `repo` URL (e.g., installed from a local marketplace path), abort and tell the user: *"This agent was installed from a local marketplace — there's no remote to contribute to. Push your local marketplace yourself."*

Capture: `catalog_repo_url`, `catalog_subdir` (e.g., `plugins/aref/`), `canonical_path`, `canonical_content`.

## Phase 3 — Show the diff

Render a unified diff. Group by section if the change spans multiple parts of the agent:

```
─── <slug>.md ───
@@ frontmatter
- description: <old>
+ description: <new>

@@ # Comparable peers
+ - **NewPeer** — one-line role/positioning
```

If the diff is large (>40 lines), show only the summary:

```
3 sections changed:
  - frontmatter (description tightened)
  - # Comparable peers (added 2 entries)
  - ## Decision schema (clarified verdict vocab)
```

Then offer: *"Show full diff?"*

## Phase 4 — Frame the PR

**One question:**

```
What changed and why? (one or two sentences — becomes the PR title)
```

→ User types one or two sentences.

**Two derived fields:**

```
Title:  <first sentence, truncated to 70 chars>
Body:   What:  <reframed first sentence>
        Why:   <second sentence if given, else asked>
        Files: agents/<slug>.md
        Source: improved while using the agent on <venture/project name>
```

The `Source:` line is captured automatically from the cwd's git remote or the project's package metadata.

Capture: `pr_title`, `pr_body`.

## Phase 5 — Branch + commit + PR

Run, in this order, all in a temp clone of the catalog repo (`/tmp/contrib-<slug>-<timestamp>/`):

```bash
gh repo clone <catalog_repo_url> /tmp/contrib-<slug>-<ts>
cd /tmp/contrib-<slug>-<ts>
git checkout -b contrib/<slug>-<short-summary>
cp <override_path>  <catalog_subdir>/agents/<slug>.md
git add <catalog_subdir>/agents/<slug>.md
git commit -m "<pr_title>"
git push -u origin contrib/<slug>-<short-summary>
gh pr create --title "<pr_title>" --body "<pr_body>"
```

**Do NOT push without confirmation.** Show the user:

```
Plan:
  Catalog:  <repo_url>
  Branch:   contrib/<slug>-<short-summary>
  Commit:   <pr_title>
  PR body:
    <body preview>

  → Type `go` to push & open the PR, or `edit` to revise the title/body.
```

On `go`, run the commands. Capture the PR URL from `gh pr create` output.

On error (auth, branch conflict, etc.), surface the actual error and stop. Do not retry silently.

## Phase 6 — Offer cleanup

After the PR opens (regardless of merge state):

```
PR opened: <url>

Local override:
  <override_path>

Options:
  keep    — leave the override in place (it'll keep overriding the plugin
            until merged; useful while iterating)
  remove  — delete the override now (project will fall back to plugin
            canonical version; safe if you trust the PR will be accepted)
  later   — handle it manually after merge

→ Type `keep`, `remove`, or `later`.
```

Default is `keep` — owners often iterate on a PR. Only suggest `remove` after the user confirms the PR is small and merge-ready.

## Anti-patterns

- **Don't push without showing the diff first.** The user must see the exact bytes that will land in the catalog.
- **Don't auto-derive the PR title.** Ask. The owner's framing of "what changed and why" is what reviewers need; a regex over the diff isn't.
- **Don't rebase / amend / force-push.** Each contribution is one commit on its own branch. If owner wants to revise, they amend manually after seeing the PR.
- **Don't delete the override silently.** Always confirm.
- **Don't assume single-plugin marketplaces.** Multi-plugin layouts (marketplace with N plugins, each in its own subdir) are the recommended OneStudio pattern — handle both.
- **Don't try to merge.** Opening the PR is the skill's responsibility. Review and merge are human + governance, not automatable here.

## Handoff

After the PR opens, suggest the next steps to the user:

```
Next:
  1. The catalog owner will review your PR.
  2. After merge, run `/plugin install <plugin>@<marketplace>` to pull
     the new canonical version (and `/reload-plugins`).
  3. If you picked `keep` above, delete `<override_path>` once the PR
     merges — otherwise it'll keep shadowing the canonical version.

Want me to schedule a reminder, or are you good?
```
