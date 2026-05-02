---
name: domain-creator
description: Walk a user through creating a new domain expert agent in Claude Code via dialog. Asks domain, primary user, output type (decisions / references / reviews / explainers), output schema, confidence vocabulary, refusal and scope rules, knowledge structure (KB vs live source vs memory), and bilingual handling, then produces a complete .claude/agents/<id>.md file plus a starter knowledge scaffold and a starter prompt set for evaluation. Use when the user wants to create a NEW domain expert agent — not edit an existing one.
---

# /domain-creator

> **Status:** Stub. Body under construction.

This skill is being built. When complete, it will guide a user through creating a new domain expert agent end-to-end via dialog, embedding the patterns observed across 13 production domain agents at OneStudio.

## Anchors for the build

- Ask many questions; don't assume. The user can edit later — but the first version should be as complete as the dialog allows.
- Embed empirical patterns from the source agents: fixed output schemas, confidence vocabularies, refusal rules, bilingual handling, live-source-vs-KB principle.
- Output one file per artifact, not a single monolith — the agent's `.md` + a starter knowledge scaffold + a starter prompt set in separate files.
- Trigger when the user wants a NEW agent. Do not trigger when editing an existing one — that's `domain-capture`'s job.
