---
name: domain-creator
description: Walk a user through creating a new domain expert agent in Claude Code via interactive Q&A. Asks roughly 10 questions covering domain, primary user, output type, response schema, confidence vocabulary, knowledge structure, refusal rules, and bilingual handling, then produces a complete .claude/agents/<id>.md file plus a starter knowledge scaffold and a starter prompt set. Use when the user wants to create a NEW domain expert agent — not edit an existing one (use domain-capture for edits).
---

# /domain-creator

Interview the user to design a new domain expert agent, then generate the agent definition file plus a knowledge scaffold and starter prompt set.

## When to invoke

- User wants to create a new domain expert agent.
- User has a domain in mind but no agent yet.
- User has a draft agent file but wants to restart cleanly with proper structure.

## When NOT to invoke

- User wants to **edit knowledge** in an existing agent → use `domain-capture` instead.
- User wants to **evaluate** an existing agent → use `domain-eval` instead.
- User is creating a non-domain agent (coding agent, ops agent, integration agent) — this skill is scoped to domain expert agents only.

## How to run this skill

This is an **interactive** skill. Behavioral rules:

1. **Ask one question per turn.** Never batch questions. Wait for the user's answer, then ask the next.
2. **Use smart defaults.** Don't ask what you can infer. If the user says "Saudi merchants", assume bilingual Arabic/English and confirm rather than asking.
3. **Show running progress.** After each answer, briefly restate what you've captured ("Got it — domain is X, user is Y. Next question…") so the user can catch errors early.
4. **Offer templates, don't blank-start.** When asking about output schema, confidence vocabulary, refusal rules — present 2-4 concrete options drawn from real production patterns (see § Pattern library).
5. **Keep questions short.** Ask, give 2-3 example answers, stop. Don't lecture.
6. **Loop when answers are incomplete.** If a user gives a one-word answer to a question that needs detail, follow up specifically.
7. **At the end, show the draft files for review BEFORE saving.** Don't auto-save. The user must explicitly approve.

## The 9-phase interview

Each phase asks 1 question (occasionally 2), in order. Skip phases that prior answers made redundant.

### Phase 1 — Identity

**Q1.1 — Slug + display name**

> "What's the agent's slug (short snake-case identifier, e.g., `nala`, `rushd`, `fekri`) and a display name (proper case, e.g., `Nala`, `Rushd`)? If the agent has a meaningful Arabic display name too, share that."

Capture: `slug`, `display_name`, `display_name_ar` (optional).

### Phase 2 — Domain

**Q2.1 — Domain in one sentence**

> "Describe the agent's domain in one sentence. Three example shapes:
> — '[market/regulatory] expert for [geography]' — e.g., 'WhatsApp Business marketing expert for KSA Salla merchants'
> — '[product practice] expert for [audience]' — e.g., 'Venture-building expert for early-stage founders'
> — '[research domain] expert for [user]' — e.g., 'Iraqi K-12 education expert for ed-tech product teams'"

Capture: `domain_one_liner`.

**Q2.2 — Geographic / language scope** *(skip if Q2.1 already implies it)*

> "What's the geographic and language scope? E.g., KSA-only, GCC, MENA, US, global — and is the agent bilingual? If yes, what languages and which is primary?"

Capture: `geo_scope`, `bilingual` (bool), `languages`, `primary_language`.

### Phase 3 — User

**Q3.1 — Primary user + their context**

> "Who's the primary user of this agent? Their role, what they're trying to do, and one example of a real question they'd bring."

Capture: `user_role`, `user_context`, `example_question`.

### Phase 4 — Primary work

**Q4.1 — Which categories of work?**

> "Which of these does the agent primarily do? You can pick 1-3 (most agents have one primary plus one or two secondary):
>
>   1. **decision_support** — produces a structured verdict with reasoning (Yes/No/Adjust, Approved/Provisional/Rejected, Go/No-Go, etc.)
>   2. **reference_lookup** — answers domain questions with cited evidence
>   3. **structured_review** — audits an artifact (PRD, design, plan) and returns categorized findings
>   4. **competitive_intelligence** — profiles competitors, comparables, market structure
>   5. **regulatory_compliance** — applies named regulations to user's situation
>   6. **handoff_partner** — produces structured briefs for other agents/humans to act on
>   7. **educational_explainer** — teaches domain concepts with worked examples
>
> Type the numbers, primary first."

Capture: `primary_categories` (ordered list).

### Phase 5 — Output schema (branched on Phase 4)

For EACH primary category in the answer, ask the relevant schema question. Skip categories not chosen.

**If `decision_support` is claimed → Q5a.1 + Q5a.2:**

**Q5a.1 — Verdict vocabulary**

> "What's the verdict vocabulary? Pick or write your own:
>
>   • `Yes / No / Needs adjustment` (Rushd-style — product decisions)
>   • `APPROVED / APPROVED (PROVISIONAL) / REJECTED / NEEDS REDESIGN / INSUFFICIENT EVIDENCE` (Ziad-style — domain reviews)
>   • `Go / Go-with-conditions / No-Go` (Membership-style — venture/feature validation)
>   • `[VERIFIED] / [UNVERIFIED] / [NEEDS-RESEARCH]` (Omar-style — claim labeling)
>   • Custom (your own)"

Capture: `verdict_vocab`.

**Q5a.2 — Response sections**

> "What named sections does every decision response include? Pick or write your own:
>
>   • Rushd's 5-part: `Decision · Why · Risks · Safer alternative · Product impact`
>   • Wafaa's 7-step: `Clarification · Options table · Trade-offs · GCC/governance implications · Risks · Recommendation · 3 follow-up questions`
>   • Omar's 3-block: `الإجابة المختصرة · ليه · اللي أنا هعمله` (with confidence-tagged citations)
>   • BLUF: `Bottom line · Context · Detailed analysis · Trade-offs & risks · Next steps · Open questions`
>   • Custom"

Capture: `response_sections`.

**If `reference_lookup` is claimed → Q5b.1:**

**Q5b.1 — Confidence vocabulary**

> "How do you label uncertain claims? Pick or write your own:
>
>   • `[VERIFIED] / [UNVERIFIED] / [NEEDS-RESEARCH]` with citation per claim (Omar-style)
>   • `confirmed / reported / estimated / uncertain / not knowable` (Shaheen-style)
>   • `from my direct experience / from my readings and degrees / from general context as [identity] / from an official source [name]` (Fekri-style — for personal-experience domains)
>   • `[knowledge/<path>.md] / [vector: <source>]` (Aref-style — KB-citation)
>   • Tier-labeled sources: `Tier 1 (official) / Tier 2 (analysis) / Tier 3 (synthesis)`
>   • Custom"

Capture: `confidence_vocab`.

**If `structured_review` is claimed → Q5c.1:**

**Q5c.1 — Review section schema**

> "What sections does every review include? Pick or write your own:
>
>   • Merchant-Advocate-style: `🔴 Blockers · 🟡 Friction · 🟢 Wins · 📋 Persona walkthrough · ❓ Open questions · 🚏 Routed to other agents` (with file:line citations)
>   • Adam-style 8-section: `Executive Summary · Mode/Date/Confidence · [...] · Confidence & Unknowns`
>   • Ziad-style: structured verdict with conditional fields (Confirm Before Ship / Reframed Requirement / Questions Before Build)
>   • Custom"

Capture: `review_sections`.

**If `competitive_intelligence` is claimed → Q5d.1:**

**Q5d.1 — Competitor classification**

> "How do you classify competitors? Pick or write your own:
>
>   • Adam-style: `Direct / Indirect / Substitute` (3 tiers, exclusive)
>   • Custom 4-tier with explicit definitions
>   • No tiering, comparison matrix only"

Capture: `competitor_classification`.

**If `regulatory_compliance` is claimed → Q5e.1:**

**Q5e.1 — Regulation citation rule**

> "How do you cite regulations? Pick or write your own:
>
>   • Article-level when possible, with applicability check per (geography, segment) — e.g., `PDPL Article 22, applies to KSA-resident data subjects`
>   • Regulation name + year + source URL
>   • Custom"

Capture: `regulation_citation_rule`.

**If `handoff_partner` is claimed → Q5f.1:**

**Q5f.1 — Handoff brief format**

> "What's in every handoff brief? Pick or write your own:
>
>   • Wafaa-style 6-part: `Question being handed off · Receiver context · Domain constraints to honor · What NOT to prescribe · What good looks like · Open questions`
>   • Custom"

Capture: `handoff_format`.

**If `educational_explainer` is claimed → Q5g.1:**

**Q5g.1 — Pedagogical structure**

> "What's the structure of every explanation? Pick or write your own:
>
>   • Membership-style 5-part: `Simple definition · Why it matters · Practical example · Common mistake · How it applies to your context`
>   • 4-part: `Definition · Example · Anti-pattern · Application`
>   • Custom"

Capture: `explainer_structure`.

### Phase 6 — Knowledge structure

**Q6.1 — Knowledge needed**

> "What knowledge does this agent need that ISN'T in code or live external sources? Pick all that apply:
>
>   • Regulations and statutes (regulatory texts that change rarely)
>   • Industry frameworks and methodologies (RFM, JTBD, Lean Startup, AAPOR, etc.)
>   • Market data and benchmarks (CPM/CPC ranges, BNPL stats, etc.)
>   • Cultural / linguistic context (Arabic dialects, Hijri calendar, GCC procurement norms)
>   • Vendor / competitor playbooks (specific to the domain)
>   • Personal experience anchored to a place or community
>   • None of the above (the agent reasons from prompt context only)"

Capture: `kb_categories`.

**Q6.2 — Live source vs static KB** *(only ask if `kb_categories` is non-empty)*

> "Should this agent ALSO read live source files at runtime (a venture's code, real-time API outputs, etc.) — or is its knowledge purely static reference material?"
>
> *Mention the principle:* "*If yes, the agent should read live source via Read/Grep/Glob — never copy source into a static KB. KB stays for stuff external to live sources (regulations, frameworks, market context).*"

Capture: `live_source_access` (bool), and if yes, `live_source_paths` (list — what files/dirs).

**Q6.3 — Memory / continuity** *(skip if not applicable)*

> "Should the agent remember things across sessions? E.g., reads a memory file at session start, logs durable learnings at session end."

Capture: `memory_enabled` (bool).

### Phase 7 — Hard rules

**Q7.1 — Out of scope**

> "What's explicitly out of scope? List 2-4 things this agent should refuse to do or redirect."

Capture: `out_of_scope` (list).

**Q7.2 — Anti-fabrication rule**

> "What's the anti-fabrication rule? Pick or write your own:
>
>   • `Two-source verification rule` — every factual claim verified against ≥2 independent credible sources before output (Abo-Lijan-style)
>   • `One-source-with-confidence-tag rule` — single source acceptable if tagged with confidence/freshness label (Omar-style)
>   • `Direct experience may be uncited; external claims must cite source` (Fekri-style)
>   • `No claims without citation, period`
>   • Custom"

Capture: `anti_fabrication_rule`.

### Phase 8 — Behavior

**Q8.1 — Pressure-testing default**

> "When the user brings a proposal, should the agent challenge weak assumptions and risky framings BY DEFAULT, or wait until asked?
>
>   • Pressure-test by default (Rushd, Sales-marketing, Sada — recommended for decision-heavy agents)
>   • Wait until asked (lighter-touch agents)"

Capture: `pressure_test_default` (bool).

### Phase 9 — Confirm and generate

After all answers captured:

1. **Show running summary** — re-list every captured answer in a compact table the user can scan in 30 seconds.
2. **Ask for confirmation:** "Look right? Type 'go' to generate the files, or call out edits."
3. **On 'go', produce 3 files:**
   - `agents/<slug>.md` — the agent definition (use the template at `references/agent-template.md` and fill it in based on captured answers)
   - `agents/<slug>-knowledge/README.md` — knowledge directory scaffold (only if `kb_categories` is non-empty)
   - `examples/<slug>-starter-prompts.yaml` — 5-10 starter prompts derived from the claimed canonical categories (for `domain-eval` to use later)
4. **Show the generated files** — don't write to disk yet.
5. **Ask:** "Save these 3 files? You can also say 'edit X' first."
6. **On confirmation, write to disk.**

## Pattern library

When asking schema questions, you offer concrete templates. The empirical patterns to draw from (with which production agent uses each):

| Pattern | Source agent | Domain |
|---|---|---|
| 5-part decision (Decision/Why/Risks/Alternative/Impact) | Rushd | WalletPlus + Salla |
| 7-step advisory (Clarification/Options/Trade-offs/Implications/Risks/Recommendation/Follow-ups) | Wafaa | GCC corporate gifting governance |
| 3-block Arabic decision (الإجابة/ليه/اللي هعمله) | Omar | KSA WhatsApp Business |
| BLUF + 5 sections | Abo Lijan | Election intelligence |
| 8-section CI report | Adam | SaaS competitive intel |
| 🔴/🟡/🟢/📋/❓/🚏 review | Merchant Advocate | Salla merchant UX |
| APPROVED/PROVISIONAL/REJECTED/NEEDS REDESIGN/INSUFFICIENT EVIDENCE verdict | Ziad | MoFA intelligence |
| Go/Go-with-conditions/No-Go | Membership | Salla Member Plus |
| Direct/Indirect/Substitute tiers | Adam | Competitor classification |
| 5-part educational (Definition/Why-matters/Example/Mistake/Application) | Membership | Domain concepts |
| 6-part handoff brief | Wafaa | Cross-agent handoff |
| `[VERIFIED]/[UNVERIFIED]` confidence tags | Omar | Per-claim labeling |
| Tier-labeled sources (Tier 1/2/3) | Shaheen | Qatar economy |
| `from direct experience / readings / general context / official source` | Fekri | Iraqi K-12 |
| Two-source verification rule | Abo Lijan | Election fact-checking |

When a user picks "Custom", let them describe their own — but encourage them to draw from these patterns first.

## Output assembly

Read `references/agent-template.md` once before generating. The template has placeholders like `{{slug}}`, `{{domain_one_liner}}`, `{{response_sections}}` etc. Fill them in from captured answers.

For sections that depend on Phase 4 choices (e.g., the agent only includes a "Decision schema" section if it claimed `decision_support`), conditionally include or omit those sections.

For starter prompts in `examples/<slug>-starter-prompts.yaml`, generate 5-10 prompts: 1-2 per claimed canonical category, plus 1-2 adversarial prompts that test refusal rules. Format:

```yaml
slug: <slug>
prompts:
  - id: <category>-001
    category: <canonical_id>
    consumer: for_human    # or for_agent
    text: |
      <a realistic prompt the user would bring>
  ...
```

## Anti-patterns

- **Don't ask 30 questions.** ~10 is the target. If you find yourself asking more, you're over-engineering.
- **Don't force a pattern that doesn't fit.** If the user's domain genuinely doesn't need bilingual handling or memory or live source access, skip those sections in the output. The empirical 13 agents differ widely — some have rich KB, some have none. Both are valid.
- **Don't write code or run benchmarks.** This is a creation skill. The user runs `domain-eval` separately.
- **Don't impose canonical categories on a domain that doesn't fit.** The 7 categories cover most cases but not all. If the user describes work that doesn't map, capture it as agent-specific in the output.
- **Don't auto-save without explicit confirmation.** The user must say "save" before any file is written.
- **Don't ask about scoring weights, leaderboards, or cross-agent comparison.** This skill produces an agent. Evaluation comes later, locally, via `domain-eval` — and the user already chose to drop cross-agent ranking.
