---
name: domain-eval
description: Evaluate a domain expert agent against its own declared schema, vocabulary, and rules. Loads the agent's declared output schema and confidence vocabulary, runs a configured prompt set through the agent, performs structural checks (schema adherence, vocabulary use, citation discipline, refusal triggers) and a light LLM-judge pass against declared success criteria, reports pass/weak/fail per prompt with diff against the last baseline. Use after editing an agent's definition or knowledge to detect regressions before shipping.
---

# /domain-eval

> **Status:** Stub. Body under construction.

This skill is being built. When complete, it will give an agent developer a fast, local regression check on their domain expert agent.

## Anchors for the build

- Local, fast, run-by-the-agent-dev. No central infra.
- Reads the agent's declared schema/vocabulary/rules from its definition (the output of `domain-creator`).
- Test prompts come from the agent's own prompt set; skill can also auto-generate light coverage prompts if the set is sparse.
- Output: per-prompt pass / weak / fail + diff vs last baseline. Not a leaderboard.
- ~30-60s per run. Sub-$1 cost.
