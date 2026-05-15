# Expert → Hub Registration Playbook

One call registers an expert into the OneStudio hub. Works for a brand-new
venture AND a pre-existing stub. Idempotent — safe to re-run.

## Prerequisites

- `.claude/agents/<slug>.md` exists (domain-creator wrote it).
- Optionally `.claude/agents/<slug>-knowledge/INDEX.md` and
  `examples/<slug>-starter-prompts.yaml`.
- A OneStudio MCP token with `read` + `post:self` scope.

## Path A — greenfield (venture does not exist yet)

1. Read the agent file (and the optional `<slug>-knowledge/INDEX.md` /
   `<slug>-starter-prompts.yaml` if present) with the Read tool.
2. Call `register_my_venture` with `venture.{slug,name,...}`, your
   `portfolio_id` (required — use `studio` as the recommended catch-all),
   and **`expert_spec`** = the raw file
   texts. Do NOT hand-transcribe `name_ar`/`skills`/`model` — the hub
   parses them.
3. Review the returned `venture.action` / `expert.action` and any
   `warnings` (e.g. repo not visible to the hub).

## Path B — venture already exists (the common stub case)

Identical call. `register_my_venture` detects the existing venture and
**enriches it** (fill-only-nulls — your inferred values fill blanks but
never clobber set fields). The expert is created if missing, or synced.
Re-running after editing the agent file re-syncs the spec. Pass
`force: true` only to deliberately overwrite already-set fields.

You do NOT need admin tools for either path.

## After registration

- Run `/domain-eval`; let its Phase 4.5 push the score via
  `report_agent_eval` so the hub badge is real.
- Record produced deliverables (induction deck, briefs) with
  `add_agent_artifact` so they show on the agent page.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Git activity empty on the agent | Hub token can't see the repo | Heed the `warnings` from registration — install the OneStudio GitHub app on the org |
| A skill is missing in the hub | `categories:` frontmatter missing/wrong | Fix `categories` per `CONTRACT.md`, re-run register |
| "no eval" badge persists | domain-eval push skipped | Re-run `/domain-eval` and allow Phase 4.5 |
| Field didn't update on re-run | fill-only-nulls protected a set value | Re-run with `force: true` if the overwrite is intended |
