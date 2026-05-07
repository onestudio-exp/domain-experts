---
name: domain-contribute
description: Contribute a domain expert agent to the catalog repo it came from — without leaving the user's project. Two auto-detected modes — (1) PATCH: a local override (`.claude/agents/<slug>.md`) of an installed agent has been edited; the skill diffs vs the canonical version, opens a PR with the change, and (optionally) cleans up the override. (2) PUBLISH: a brand-new agent built locally that's not yet in the catalog; the skill packages it as a new plugin (plugin.json, agent file, reusable KB, starter prompts), inserts the marketplace.json entry, and opens a PR adding the plugin. The mode is detected by checking whether the slug already lives in the catalog. Use when an agent owner has either improved an existing agent in-flight or built a new one and wants to ship it back upstream without manually cloning the catalog.
---

# /domain-contribute

Ship a local agent — improvement or brand-new — back to its catalog repo. **Two modes, auto-detected.** No clone, no nav-to-subdir.

## When to invoke

- **PATCH** — Owner edited `.claude/agents/<slug>.md` of an installed agent and wants to push the improvement upstream.
- **PUBLISH** — Owner built a new agent (typically via `domain-creator new`), tested it, and wants to add it to the catalog as a new plugin.
- Eval surfaced a fix; owner patched the local override; ready to land it.
- Knowledge / vocab / refusal rule learned in production should become canonical.

## When NOT to invoke

- For adding new evidence/knowledge to an *existing* canonical agent → `domain-capture`.
- For creating a new agent from scratch (interview / scaffold) → `domain-creator new`. Run that first; THIS skill ships the result to the catalog.
- For upleveling an existing agent (audit + rewrite) → `domain-creator refit`.
- When the project has no `.claude/agents/<slug>.md` AND no `agents/<slug>.md` — there's nothing to contribute. Build or override first.

## How to run

1. **Find a local agent file.** Search `.claude/agents/*.md` (project override) and `agents/*.md` (local-build location used by `domain-creator new`).
2. **Resolve the catalog** — find which marketplace + plugin shipped (or would ship) this slug.
3. **Detect mode automatically** by checking whether the slug already exists in the catalog's marketplace.json:
   - Slug present → **patch mode**.
   - Slug absent → **publish mode**.
4. Run the mode-specific phases (4a/4b) below.
5. Frame the PR (one question — *what changed and why?* / *what's the new agent?*).
6. Confirm before pushing. Branch, commit, `gh pr create`.
7. Offer cleanup of the local files.

---

## Phase 1 — Locate the local agent files

Search cwd in this order; first match wins (or list and ask if multiple):

```
1. .claude/agents/<slug>.md              # project override (patch mode source)
2. agents/<slug>.md                       # local-build (publish mode source — created by domain-creator new)
```

For each found, also probe for siblings:

```
.claude/agents/<slug>-knowledge/         OR    agents/<slug>-knowledge/
examples/<slug>-starter-prompts.yaml
```

Capture: `local_agent_path`, `local_agent_content`, `slug`, `local_kb_path` (or null), `local_prompts_path` (or null).

If nothing is found: tell the user *"No local agent file. Run `domain-creator new` to build one, or edit `.claude/agents/<slug>.md` to override an installed agent, then re-run this skill."*

---

## Phase 2 — Resolve the catalog

Find which marketplace + plugin shipped this slug, or — for publish mode — which marketplace this would land in.

**Search order for the canonical agent file:**

```
1. ~/.claude/plugins/cache/<marketplace>/<plugin>/agents/<slug>.md
2. ~/.claude/plugins/cache/<marketplace>/plugins/<plugin>/agents/<slug>.md   (multi-plugin marketplaces)
```

Parse the **marketplace metadata** to find the source repo URL:

```
~/.claude/plugins/cache/<marketplace>/.claude-plugin/marketplace.json
  → look up the matching plugin entry by slug
  → its `source` field, combined with the marketplace `repo` URL,
    gives you: <repo_url> + relative path to the plugin
```

For **publish mode** (slug not yet in any marketplace), ask the user:

```
**Q1 — Target catalog**

Which catalog should this agent ship to?

  default  — the most recently-used domain-experts marketplace
            (resolved from ~/.claude/plugins/cache/)
  custom   — type the marketplace slug or repo URL

→ Type `default` or paste a marketplace slug / URL.
```

If the marketplace cache lacks a remote `repo` URL (installed from a local marketplace path), abort: *"This catalog has no remote — push your local marketplace yourself."*

Capture: `catalog_repo_url`, `catalog_marketplace_path`, and (for patch mode) `canonical_path`, `canonical_content`.

---

## Phase 3 — Detect mode

Read the catalog's `marketplace.json` and check whether `<slug>` appears in the `plugins[]` array.

```
slug present  → patch mode    (skip to Phase 4a)
slug absent   → publish mode  (skip to Phase 4b)
```

Show the user one line:

```
Detected mode: PATCH (improving installed agent)
   — or —
Detected mode: PUBLISH (adding <slug> as a new plugin)
```

If detection is ambiguous (e.g. file present at both `.claude/agents/<slug>.md` AND `agents/<slug>.md`), surface and ask which is the source of truth.

---

## Phase 4a — PATCH mode (improving an installed agent)

### Show the diff

Render a unified diff between `local_agent_path` and `canonical_path`. Group by section if the change spans multiple parts. If diff is large (>40 lines), show the section summary + offer *"Show full diff?"*.

```
─── <slug>.md ───
@@ frontmatter
- description: <old>
+ description: <new>

@@ # Comparable peers
+ - **NewPeer** — one-line role/positioning
```

Skip if the override is byte-identical to canonical (`diff --quiet` returns 0): tell the user *"Override matches canonical — nothing to contribute. Edit the override first."*

---

## Phase 4b — PUBLISH mode (shipping a new agent to the catalog)

### Inventory what will be shipped

Show the user:

```
Publishing <slug> as a new plugin to <marketplace>:

  Local files found:
    ✓ <local_agent_path>                        → plugins/<slug>/agents/<slug>.md
    [✓/✗] <local_kb_path>                       → plugins/<slug>/agents/<slug>-knowledge/
    [✓/✗] <local_prompts_path>                  → plugins/<slug>/examples/<slug>-starter-prompts.yaml

  Will create:
    plugins/<slug>/.claude-plugin/plugin.json   (auto-generated from agent frontmatter)

  Will modify:
    .claude-plugin/marketplace.json             (insert new plugin entry)
```

Mark missing files. The agent .md is required; KB folder and starter prompts are recommended but not blockers.

### KB reusability check (only if local KB exists)

Walk the top-level subdirs of the local KB folder. For each, ask one question:

```
**Q — `<subdir>` reusability**

  ship    — bundle this in the plugin (reusable across all consumers)
  skip    — leave behind in the project (venture-specific)

→ Type `ship` or `skip`.
```

Common patterns to call out by default:

- `my-venture/` → **skip** (venture-specific by definition)
- `decisions/` → **skip** (the project's own decision log; consumers will keep their own)
- `playbooks/`, `reference/`, `glossary.md`, `INDEX.md`, `sources.md` → **ship** (canonical domain material)
- `digests/` → **skip** (venture-specific market intel)

Default the recommendation; let the user override per dir.

### Plugin manifest auto-generation

Generate `plugins/<slug>/.claude-plugin/plugin.json` from the agent file's YAML frontmatter:

```json
{
  "name": "<slug>",
  "version": "1.0.0",
  "description": "<from frontmatter `description:` field, truncated if needed>",
  "author": { "name": "<from git config user.name OR catalog marketplace owner>" }
}
```

Show it to the user. Offer `edit` to revise version / description / author before saving.

### Marketplace.json delta

Show the planned diff against `marketplace.json`:

```diff
  "plugins": [
    { "name": "domain-experts", ... },
    { "name": "aref", ... },
+   {
+     "name": "<slug>",
+     "source": "./plugins/<slug>",
+     "version": "1.0.0",
+     "description": "<one-line, from frontmatter, truncated to ~140 chars>"
+   }
  ]
```

---

## Phase 5 — Frame the PR

**One question, mode-aware:**

```
PATCH:    What changed and why? (one or two sentences — becomes the PR title)
PUBLISH:  In one sentence — what's <slug> for? (becomes the PR title)
```

→ User types one or two sentences.

**Two derived fields:**

```
PATCH title:    <first sentence, truncated to 70 chars>
PATCH body:     What:    <reframed first sentence>
                Why:     <second sentence if given, else asked>
                Files:   agents/<slug>.md
                Source:  improved while using the agent on <venture/project>

PUBLISH title:  Add <slug> as a new domain expert plugin
PUBLISH body:   What:    <one-sentence summary>
                Domain:  <from frontmatter description>
                Files:   plugins/<slug>/{plugin.json, agents/<slug>.md,
                         agents/<slug>-knowledge/, examples/<slug>-starter-prompts.yaml}
                Source:  built and tested in <venture/project>
                Eval:    [if domain-eval was run] <pass/weak/fail summary>
```

The `Source:` line is captured from the cwd's git remote or project metadata.

Capture: `pr_title`, `pr_body`.

---

## Phase 6 — Branch + commit + PR

Run, in order, in a temp clone of the catalog repo (`/tmp/contrib-<slug>-<timestamp>/`):

### PATCH mode

```bash
gh repo clone <catalog_repo_url> /tmp/contrib-<slug>-<ts>
cd /tmp/contrib-<slug>-<ts>
git checkout -b contrib/patch-<slug>-<short-summary>
cp <local_agent_path> <catalog_subdir>/agents/<slug>.md
git add <catalog_subdir>/agents/<slug>.md
git commit -m "<pr_title>"
git push -u origin contrib/patch-<slug>-<short-summary>
gh pr create --title "<pr_title>" --body "<pr_body>"
```

### PUBLISH mode

```bash
gh repo clone <catalog_repo_url> /tmp/contrib-<slug>-<ts>
cd /tmp/contrib-<slug>-<ts>
git checkout -b contrib/publish-<slug>

# Lay down the plugin subdir
mkdir -p plugins/<slug>/.claude-plugin plugins/<slug>/agents plugins/<slug>/examples
echo "<auto-generated plugin.json>" > plugins/<slug>/.claude-plugin/plugin.json
cp <local_agent_path> plugins/<slug>/agents/<slug>.md

# KB — copy only the dirs the user marked `ship`
for dir in <ship_list>; do
  cp -r "<local_kb_path>/$dir" plugins/<slug>/agents/<slug>-knowledge/
done

# Starter prompts (if present)
[ -f "<local_prompts_path>" ] && cp "<local_prompts_path>" plugins/<slug>/examples/<slug>-starter-prompts.yaml

# Insert marketplace entry (use jq to keep formatting clean)
jq '.plugins += [<new_entry>]' .claude-plugin/marketplace.json > /tmp/mkt.json && mv /tmp/mkt.json .claude-plugin/marketplace.json

git add plugins/<slug>/ .claude-plugin/marketplace.json
git commit -m "<pr_title>"
git push -u origin contrib/publish-<slug>
gh pr create --title "<pr_title>" --body "<pr_body>"
```

**Do NOT push without confirmation.** Show the user:

```
Plan:
  Mode:     PATCH | PUBLISH
  Catalog:  <repo_url>
  Branch:   contrib/<patch|publish>-<slug>-<...>
  Commit:   <pr_title>
  PR body:
    <body preview>

  Files affected:
    <list — for patch: just the agent .md;
             for publish: plugin subdir + marketplace.json>

  → Type `go` to push & open the PR, or `edit` to revise.
```

On `go`, run the commands. Capture the PR URL from `gh pr create`.

On error (auth, branch conflict, schema invalid), surface the actual error and stop. Do not retry silently.

---

## Phase 7 — Offer cleanup

After the PR opens (regardless of merge state):

### PATCH mode

```
PR opened: <url>

Local override:
  <local_agent_path>

Options:
  keep    — leave the override in place (it'll keep overriding the plugin
            until merged; useful while iterating)
  remove  — delete the override now (project will fall back to plugin
            canonical after merge & reinstall)
  later   — handle it manually after merge

→ Type `keep`, `remove`, or `later`.
```

Default: `keep` while the PR is open.

### PUBLISH mode

```
PR opened: <url>

Local files (built before catalog had this agent):
  <local_agent_path>
  <local_kb_path>      (if exists)
  <local_prompts_path> (if exists)

Options:
  keep    — leave them in place (you'll need to switch to project-override
            usage once the plugin lands)
  archive — move them to `.local-builds/<slug>/` so they don't conflict
            with the installed plugin after merge
  later   — handle manually

→ Type `keep`, `archive`, or `later`.
```

After merge, the user runs `/plugin install <slug>@<marketplace>` to switch from local-build to plugin-install. The skill suggests this in the next-steps block.

---

## Anti-patterns

- **Don't push without showing the diff or the inventory first.** The user must see what will land in the catalog.
- **Don't auto-derive the PR title.** Ask. The owner's framing of "what" / "why" is what reviewers need.
- **Don't rebase / amend / force-push.** One contribution = one commit on its own branch. Owner amends manually if they need to revise.
- **Don't delete local files silently.** Always confirm in cleanup phase.
- **Don't ship venture-specific KB.** In publish mode, the KB reusability check is mandatory — never bundle `my-venture/`, `decisions/`, `digests/`, or anything else specific to the home venture.
- **Don't auto-pick mode without surfacing it.** Show the user *"Detected mode: …"* before doing mode-specific work — they may want to override (e.g. force a publish even when patch is detected, for an explicit fork).
- **Don't try to merge.** Opening the PR is the skill's responsibility. Review and merge are governance, not automatable here.
- **Don't generate a plugin.json without showing it.** In publish mode, the auto-generated manifest is plausible but not always right — version, author, description should be reviewable.
- **Don't insert a marketplace entry beyond the array.** Keep formatting clean (use `jq`); don't append after closing brackets or break the JSON.

---

## Handoff

After the PR opens:

```
Next:
  1. The catalog owner will review your PR.
  2. (PATCH) After merge, run `/plugin install <plugin>@<marketplace>` +
     `/reload-plugins` to pull the new canonical version. If you picked
     `keep` above, delete the override once merged.
  3. (PUBLISH) After merge, run the same install + reload commands. The
     agent now lives as an installed plugin instead of a local build.
     If you picked `archive`, your local files moved to `.local-builds/`
     and won't shadow the plugin.

Want me to schedule a reminder, or are you good?
```
