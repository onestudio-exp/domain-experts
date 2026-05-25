---
name: propose-pr
description: Take one specific pattern from a learn-from-edits report and draft a complete PR (description + file changes + test plan) ready for human review. Reads the report, the proposed fix, and the relevant toolkit files; invokes an author subagent that produces concrete diffs; creates a branch in the local submodule clone; saves the PR body. Stops at gh pr create command — never pushes without human approval.
---

# /domain-experts:propose-pr

Convert one pattern from a learn-report into a draft PR. The skill stops at `gh pr create` — it never pushes or merges.

## When to invoke

- After `/domain-experts:learn-from-edits` produced a report.
- User picked one specific pattern they want to act on.

## When NOT to invoke

- If no learn-report exists → run `/domain-experts:learn-from-edits` first.
- If you want to ship MULTIPLE patterns at once → run propose-pr once per pattern; do not batch into one mega-PR.
- For agent-level improvements (changing burhan itself, not the toolkit) → use the existing `/domain-experts:domain-contribute` skill instead. This skill is for toolkit improvements.

## Prerequisites

1. A `.telemetry/learn-report-<date>.md` exists.
2. The submodule (`<venture>/.claude/plugins/domain-experts/`) is checked out and clean.
3. `gh` CLI is installed (only needed for the final `gh pr create` step — the skill prints the command but does not execute it).

## How to run

1. **One pattern per invocation.** No batching.
2. **Read-only on the toolkit until the user confirms.** The skill plans, shows, asks. Only on `apply` does it write files.
3. **Never pushes.** The skill prints the `git push` and `gh pr create` commands for the user to review and run.

## Phase 1 — Load the pattern

Inputs:
- `--report <path>` (default: most recent `.telemetry/learn-report-*.md`)
- `--pattern <N>` (which pattern number from that report)

Read the report, extract:
- Pattern category
- Root cause (from synthesizer)
- Proposed toolkit fix (from synthesizer)
- Suggested PR title
- Tier (auto-promote / seed-stub / human-review)
- Evidence entries

If `--pattern` is omitted, list the patterns and ask which to act on:
```
Patterns in learn-report-2026-05-25.md:
  1. plugin_scaffolding_added       (5 occ, tier-1-auto-promote)
  2. operating_manual_sections      (3 occ, tier-1-auto-promote)
  3. kb_file_added                  (2 occ, tier-2-seed-stub)

Which pattern? [1/2/3]
```

## Phase 2 — Identify the toolkit files to change

Based on the proposed fix, determine which files in the submodule need editing. Common targets:

| Fix mentions | Files to touch |
|---|---|
| "agent template" / "template" | `plugins/domain-experts/references/agent-template.md` |
| "domain-creator skill" / Phase X | `plugins/domain-experts/skills/domain-creator/SKILL.md` |
| "scaffold X file" / "Phase 9 output" | The skill's Phase 9 section + add a template file |
| "frontmatter field" | The agent template's frontmatter block + Phase 1 questions |
| "new KB stub" | Stub template (likely in `references/kb-stubs/<category>.md` — create if missing) |

Read the current state of each target file (full content). Limit to ≤3 files per pattern; if more, ask the user to scope.

## Phase 3 — Author subagent

Construct a self-contained prompt:

```
You are a PR author for the domain-experts toolkit. Produce concrete
file changes that implement a proposed improvement.

# The pattern (root cause + proposed fix)

{{paste pattern's root cause + proposed fix from the report}}

# Files in scope (full current content)

## File 1: {{path}}

```
{{full file content}}
```

## File 2: {{path}}

```
{{full file content}}
```

# Constraints

- Output unified diff per file. Do NOT rewrite whole files.
- Do NOT touch files not listed in scope.
- Keep changes minimal and surgical.
- Match the existing code/markdown style.
- If a stub template doesn't exist yet, propose creating it under
  `references/{{appropriate-path}}.md`.

# Output (markdown)

## Summary
{{1-3 sentences: what changes and why, citing pattern evidence}}

## File changes

### {{path}}
```diff
@@ ... @@
{{diff}}
```

### {{path}} (NEW FILE)
```
{{full content of new file}}
```

## PR body

```markdown
{{full PR description ready to paste into gh pr create}}
```

## Test plan
- [ ] {{verification step 1}}
- [ ] {{verification step 2}}
- [ ] Run `/domain-experts:domain-eval` against an existing agent and verify no regression
```

Invoke `general-purpose` subagent with this prompt. Capture the full markdown response.

## Phase 4 — Show + confirm

Show the subagent's output to the user inline. Then ask:

```
The author subagent proposed the changes above.

Options:
  apply       - create a branch, apply the diffs, save the PR body,
                print the gh commands. Does NOT push.
  revise      - send the subagent back with your feedback
  cancel      - drop the proposal; no files changed
```

→ Wait for input. Do not auto-apply.

## Phase 5 — Apply (only on confirm)

When the user types `apply`:

1. **Create a branch in the submodule:**
   ```
   cd <submodule>
   git checkout -b feat/{{pattern-slug}}
   ```

2. **Apply each diff** using `git apply` or by writing the new file contents directly. Verify each apply succeeds; abort and rollback on any failure.

3. **Save the PR body:**
   ```
   <venture>/.telemetry/pr-drafts/{{pattern-slug}}.md
   ```

4. **Print the next-step commands** for the user to run themselves:
   ```
   ===========================================
   Proposed PR ready for review.

   Branch:    feat/{{pattern-slug}}  (in submodule, not pushed)
   Diff:      cd <submodule> && git diff main
   PR body:   .telemetry/pr-drafts/{{pattern-slug}}.md

   To open the PR (run yourself after reviewing):
     cd <submodule>
     git push origin feat/{{pattern-slug}}
     gh pr create --title "{{title}}" --body-file <pr-body-path>

   To discard:
     cd <submodule>
     git checkout main
     git branch -D feat/{{pattern-slug}}
   ===========================================
   ```

The skill ends here. The user is in control of push.

## Critical constraints (NEVER violate)

- **NEVER push.** The skill ends at `git push` instruction — does not execute.
- **NEVER commit to main.** Always create a feature branch.
- **NEVER touch files outside the toolkit submodule.** No changes to venture project files, no changes to other plugins.
- **NEVER modify multiple unrelated patterns in one PR.** One pattern = one branch = one PR.
- **NEVER auto-fix linting/formatting in unrelated files.** Stay surgical.

## Anti-patterns

- **Do NOT inflate the diff with refactors the pattern evidence doesn't justify.** If the pattern says "add a section", add the section — don't restructure the whole template.
- **Do NOT propose changes that contradict explicit decisions in the toolkit's `decisions/` log** (if it exists). Read existing decisions first.
- **Do NOT generate tests that mock things the toolkit doesn't have.** Test plan should be runnable.
- **Do NOT proceed past Phase 4 without explicit `apply` from the user.** No silent writes.

## What this skill does NOT do

- Push or merge the PR.
- Aggregate multiple patterns.
- Generate tests beyond the test plan checklist.
- Modify any file outside the toolkit submodule.

## Example invocation

```
User: /domain-experts:propose-pr --pattern 1

Skill:
  Loading .telemetry/learn-report-2026-05-25.md, pattern 1...
  Pattern: plugin_scaffolding_added (5 occurrences)

  Identifying toolkit files to change:
    - plugins/domain-experts/skills/domain-creator/SKILL.md (Phase 9 section)
    - plugins/domain-experts/references/agent-template.md
    - plugins/domain-experts/references/plugin-readme-template.md (NEW)

  Invoking author subagent...
  [author subagent returns diffs + PR body]

  [Show the proposed changes inline]

  apply / revise / cancel?

User: apply

Skill:
  cd <submodule>
  git checkout -b feat/scaffold-plugin-files
  Applying diff to SKILL.md ... OK
  Applying diff to agent-template.md ... OK
  Creating new file plugin-readme-template.md ... OK
  Saving PR body to .telemetry/pr-drafts/scaffold-plugin-files.md

  =========================================
  Proposed PR ready for review.

  Branch: feat/scaffold-plugin-files (in submodule, not pushed)
  Run yourself when ready:
    cd <submodule>
    git push origin feat/scaffold-plugin-files
    gh pr create --title "feat(domain-creator): scaffold plugin files in Phase 9" \
      --body-file ../../../.telemetry/pr-drafts/scaffold-plugin-files.md
  =========================================
```
