---
name: domain-eval
description: Run a domain expert agent against its own declared schema, vocabulary, and rules to detect regressions before shipping. Loads the agent definition + its starter prompts, invokes the agent on each prompt, runs structural checks (schema sections present, verdict vocab used, confidence tags applied, refusals trigger correctly), runs a light LLM judge pass against declared success criteria, and reports per-prompt PASS / WEAK / FAIL with diff against the last baseline. Use after editing an agent's definition or knowledge, or before publishing changes.
---

# /domain-eval

Run an agent against its own declared rules. Catch regressions.

## When to invoke

- After editing an agent definition.
- After adding knowledge via `domain-capture`.
- Before sharing or shipping the agent.
- To establish a baseline for a new agent.

## When NOT to invoke

- For agents with NO declared schema or starter prompts → run `domain-creator refit` first.
- For evaluating a non-domain agent (coding, ops) — this skill is scoped to domain expert agents.

## How to run

1. **One step per turn.** Wait for the user's input between steps.
2. **Use defaults.** Path resolution and rubric extraction have sensible defaults; user can override.
3. **Don't generate prompts.** Only run prompts that already exist in the agent's prompt set. If the prompt set is missing, redirect to `domain-creator refit`.
4. **Don't judge by absolute quality.** Judge against the agent's own DECLARED schema/vocab/rules. If the agent says "I use a 3-block decision schema", check for 3 blocks — not the framework's default 5-part.
5. **Snapshot the agent definition at start.** Don't re-read mid-run; the rubric is fixed for the run.

## Phase 1 — Locate

**Q1 — Agent**

Where's the agent? (path or slug)

**✨ Default — slug + search common locations**

Search order (first match wins):

```
1. <cwd>/.claude/agents/<slug>.md                                    # project override
2. <cwd>/agents/<slug>.md                                             # local-build (domain-creator new)
3. ~/.claude/agents/<slug>.md                                         # user-scoped agent
4. ~/.claude/plugins/cache/*/<slug>/*/agents/<slug>.md                # installed plugin (slug is the plugin name)
5. ~/.claude/plugins/marketplaces/*/plugins/<slug>/agents/<slug>.md   # marketplace source, multi-plugin
6. ~/.claude/plugins/marketplaces/*/agents/<slug>.md                   # marketplace source, single-plugin
```

The `cache/` paths use 4 levels: `<marketplace>/<plugin>/<version>/agents/`. The `<version>` is dynamic per install — glob with `*`. For agents inside a plugin whose name is NOT the slug (e.g. when nala lives inside the `domain-experts` plugin), also try `~/.claude/plugins/cache/*/*/*/agents/<slug>.md`.

→ Type a slug or full path.

**Q2 — Prompt set**

**✨ Default — `examples/<slug>-starter-prompts.yaml` next to the agent**

If found, use it. If not, ask for a path or abort with: *"No prompt set found — run `domain-creator refit` to generate one."*

→ Type `default` or a path.

## Phase 2 — Parse expectations

Read agent.md. Extract a rubric:

```
agent_id          (frontmatter name)
declared_categories          (parse from "What kinds of work" section)
verdict_vocab                (if decision_support claimed)
response_sections            (if decision_support claimed)
confidence_vocab             (if reference_lookup claimed)
review_sections              (if structured_review claimed)
competitor_classification    (if competitive_intel claimed)
regulation_citation_rule     (if regulatory_compliance claimed)
handoff_format               (if handoff_partner claimed)
explainer_structure          (if educational_explainer claimed)
out_of_scope                 (parse from "Hard rules" section)
anti_fabrication_rule        (parse from "Hard rules" section)
pressure_test_default        (parse from "How you operate" or behavior section)
reference_implementation     (parse from "# Reference implementation" section, may be null)
comparable_peers             (parse from "# Comparable peers" section — list of names)
```

For sections that didn't parse cleanly, mark as `unknown` — these will be skipped in checks rather than fail.

If `comparable_peers` is empty or missing → flag this run with a **structural warning** in the report. The agent has no declared category to reason against; cross-venture applicability cannot be tested. Recommend running `domain-creator refit` before re-evaluating.

Show summary:

```
Loaded rubric for <slug>:
  categories:        <list>
  verdict_vocab:     <list>
  confidence_vocab:  <list>
  out_of_scope:      <count> rules
  ...
Loaded N prompts: <category breakdown>
```

## Phase 3 — Run prompts

For each prompt in the set:

1. **Invoke the agent.**
   Use the Agent tool with `subagent_type: <slug>` (after `/reload-plugins` the agent must be in the registry).
   Pass `prompt: <prompt.text>`.
   Capture the full response.

2. **Run structural checks** based on `prompt.category` and the declared rubric:

```
decision_support:
  ✓ at least one verdict_vocab keyword appears (case-insensitive)
  ✓ declared response_sections present per the schema
    (adaptive: Verdict + Why required; others optional)
    (rigid/3-block/7-step: all sections required)

reference_lookup:
  ✓ at least one confidence_vocab token used per substantive claim
  ✓ at least one citation (URL, source name, footnote)

structured_review:
  ✓ declared review_sections all present

competitive_intel:
  ✓ every competitor mentioned has a tier label

regulatory_compliance:
  ✓ regulations cited per the agent's rule (article-level vs name-year-url)
  ✓ applicability check phrase present

handoff_partner:
  ✓ all 6 (or declared) handoff brief parts present

educational_explainer:
  ✓ all declared pedagogical structure parts present

refusal_test (expects_refusal: true):
  ✓ response declines to substantively answer
  ✓ refusal language present ("out of scope", "defer to", "won't", "can't")
  ✗ FAIL if it answers the substantive question

refusal_test (expects_refusal: false):
  ✓ response answers (no refusal)
  ✓ stays within declared scope

cross_venture_applicability (NEW in v0.2):
  HOME VENTURE = `reference_implementation.name` (parsed in Phase 2).
  PEER = pick any name from `comparable_peers` that is NOT the home venture.
  Synthesize a prompt:
    "Advise <PEER> on <a question parallel to one the home venture
     would ask>." E.g., for Aref the home venture is Amos; pick Bilt
     from comparables and ask the equivalent question.
  Run the agent against this prompt and check:
  ✓ response answers substantively (no "I only advise <home venture>")
  ✓ advice transfers in PRINCIPLE — frameworks, regulations, decision
    drivers are the same as the home venture would get
  ✓ specifics differ — concrete numbers / partners / channels reflect
    the peer's reality, not the home venture's
  ✗ FAIL if the response refuses, OR substitutes home-venture-specific
    facts into peer-venture context (e.g., quoting the home venture's
    proprietary metrics as universal), OR collapses the advice to
    "this is exactly how <home venture> does it"
  ⚠ WEAK if the response is correct in framing but thin on peer-specific
    detail (e.g., uses the home venture's vocabulary throughout)
```

The cross-venture prompt is generated AT RUN TIME from the agent's `comparable_peers` field — it doesn't need to live in the starter prompt set. Skip this check if `comparable_peers` is empty (the structural warning from Phase 2 already flagged it).

3. **Light judge pass.** Score on 1-5 scale:
   - `output_discipline` — adherence to declared schema/vocab
   - `domain_accuracy` — claims appear sound; no obvious fabrication
   - `calibration` — uncertain claims labeled per the agent's vocab

4. **Classify the prompt:**

```
PASS  — all structural checks pass + all judge dimensions ≥3
WEAK  — most structural checks pass + 1-2 judge dimensions at 2; non-critical gaps
FAIL  — critical structural check fails (e.g., refusal test answers the question);
        OR any judge dimension at 1; OR severe rubric violation
```

## Phase 4 — Report

Show inline:

```
**Eval results for <slug>** (N prompts · <date>)

  PASS:  X / N
  WEAK:  Y / N
  FAIL:  Z / N

By category:
  decision_support       PASS X · WEAK Y · FAIL Z
  reference_lookup       ...
  refusal_test           ...

Per prompt:
  ✓ PASS  decision_support-001  Verdict: Pivot · sections OK · accuracy 4 · calibration 5
  ⚠ WEAK  reference_lookup-001  Missing confidence tags on 2/5 claims
  ✗ FAIL  refusal-002           Did not refuse; answered the cap-table math question
```

Save the run? Default `yes`. Path: `<agent-dir>/eval-runs/<YYYY-MM-DDTHHMM>.yaml`

## Phase 5 — Baseline + diff (optional)

If `<agent-dir>/eval-baseline.yaml` exists, compute diff:

```
Diff vs baseline:
  +1 PASS    decision_support-002 (was WEAK)
  -1 FAIL    refusal-002 (was PASS) ← REGRESSION
```

Ask: *"Update baseline to current run? (yes/no)"*

On `yes`, copy the saved run to `<agent-dir>/eval-baseline.yaml`.

## Anti-patterns

- **Don't generate test prompts.** If the prompt set is missing, redirect to `domain-creator refit`.
- **Don't judge against framework defaults.** Judge against the agent's DECLARED rules. An agent that uses a 3-block decision schema PASSES if it produces 3 blocks — even though the framework default is adaptive.
- **Don't fail an agent for stylistic disagreement.** PASS / WEAK / FAIL is about declared-rule compliance, not your taste.
- **Don't run on a moving target.** Snapshot the rubric once at start of the run.
- **Don't skip refusal tests silently.** If a refusal test fails, that's a critical signal — do NOT downgrade to WEAK.
