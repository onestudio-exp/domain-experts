---
name: domain-capture
description: Capture new evidence-backed knowledge into a domain expert agent. Takes a new claim from the user (a fact, a decision, a contradiction with the agent's current understanding), invokes the target agent to surface its current view, requires source or evidence from the user, debates contradictions, then writes the captured knowledge to the right location in the agent's structure (memory file, KB doc, or .md frontmatter — picks based on the agent's existing layout) with citation and a dated entry. Use when the agent has gone stale, when new evidence has emerged, or when the user wants to teach the agent something new.
---

# /domain-capture

> **Status:** Stub. Body under construction.

This skill is being built. When complete, it will turn the manual "edit the agent's .md file by hand" workflow into a guided, evidence-backed knowledge growth flow.

## Anchors for the build

- The skill is the OPPOSITE of letting an agent invent things. It's a controlled growth path with evidence trails.
- Validates new claims against the agent's current understanding before capturing.
- Requires source/evidence from the user. No silent edits.
- Picks the destination based on the agent's existing structure — does NOT impose one (per the live-source-vs-KB principle).
- Every capture gets a citation + timestamp. Audit trail must survive future runs.
