---
name: domain-creator
description: Build or uplevel a domain expert agent in Claude Code. Three entry paths — (1) CREATE from scratch: interview the user with ~10 short questions and produce a new agent definition, knowledge scaffold, and starter prompt set; (2) CREATE with context-aware prefill: scan the venture for ALL useful context (PRD, README, CLAUDE.md, specs, plans, discovery docs — any markdown with strong signal density), let the user pick which files to merge, then propose answers for identity / domain / primary user / categories / reference implementation / comparable peers with per-field confidence and source citations — collapsing the interview to ~3 turns. Domain-widening enforced: the product described becomes the Reference Implementation, never the agent's identity; (3) REFIT: read an existing agent file, audit it against the framework's 10 dimensions (incl. Domain-vs-Project framing — flags agents coupled to a single product instead of a category), advise the user which changes to apply, then overwrite the agent with the upleveled version plus a KB scaffold and starter prompts if missing. Most questions have a tested default the user can accept with one keystroke. Use when the user wants to create a NEW agent (from blank or with context prefill) OR uplevel an EXISTING one to fit domain-expert practice. Do not use for adding knowledge to an existing agent (that's domain-capture).
---

# /domain-creator

Build or uplevel a domain expert agent.

Two modes, three entry paths:

- **Create — blank** — interview the user from scratch, produce a new agent + KB scaffold + starter prompts.
- **Create — with context-aware prefill** *(v0.6: replaces the PRD-only path)* — scan the venture for ALL useful context (PRD, README, CLAUDE.md, specs, plans, discovery docs, vision docs — any markdown with strong signal density), rank candidates, let the user pick which files to merge, then propose values for identity / domain / primary user / categories / reference implementation / comparable peers with **per-field confidence** and **source citations**. The user accepts or edits each field, then continues with output-schema questions only. **Domain-widening is enforced**: the product described becomes the Reference Implementation, never the agent's identity — the agent is built around the wider *category*.
- **Refit** — read an existing agent, audit it, apply framework changes, overwrite it (and add KB scaffold + starter prompts if they don't exist).

All paths produce the same output set: `agents/<slug>.md`, `agents/<slug>-knowledge/{INDEX.md, README.md, <category>/<seed-stub>.md}`, `examples/<slug>-starter-prompts.yaml`. The KB scaffold (v0.6+) ships an indexable `INDEX.md` manifest plus per-category seed stubs so the agent is usable immediately after creation.

## When to invoke

- User wants to create a new domain expert agent.
- User wants to uplevel/refit an EXISTING agent to fit domain-expert practice.
- User has a draft agent and wants to restart cleanly with framework structure.

## When NOT to invoke

- User wants to **add new knowledge** to an existing agent → use `domain-capture`.
- User wants to **evaluate** an existing agent → use `domain-eval`.
- User is creating a non-domain agent (coding, ops, integration) — this skill is scoped to domain expert agents only.

## How to run

1. **Ask one question per turn.** Wait for the answer. Then ask the next.
2. **Use defaults.** Most schema questions have a tested default. Show it. Let the user type one keyword to accept.
3. **Show progress.** After each answer, restate what you captured in one short line.
4. **Use short sentences.** Many users are not English-native. One idea per sentence. Simple verbs.
5. **Describe options by shape, not by author.** Patterns are named by structure (e.g., "5-part schema"), never by which agent uses them.
6. **Loop on incomplete answers.** If a one-word answer needs more, follow up specifically.
7. **Show drafts before saving.** Never auto-save. The user must say `save`.

## Question template

Every question with a default uses this exact format:

```
**Q<N> — <Field>**

<one-line question>

**✨ Default — <name>**

```
<aligned shape — code block for monospace clarity>
```

*<one-line why>*

**Override:**

```
keyword  — short explanation
keyword  — short explanation
custom   — write your own
```

→ Type `default`, `keyword`, ..., or `custom`.
```

Questions without a meaningful default (slug, user, out-of-scope) skip the Default block.

## Phase 0 — Mode detection

**Q0 — New or refit?**

Are we creating a new agent, or refitting an existing one?

```
new      — start from scratch (Phase 1 onward)
refit    — read an existing agent, audit it, apply framework changes
```

→ Type `new` or `refit`.

If `new` → continue to **Phase 0.5 — Context Discovery & Synthesis** (below).
If `refit` → jump to **Refit mode** (after Phase 9).

---

## Phase 0.5 — Context Discovery & Synthesis *(v0.6 — replaces PRD-only prefill)*

Before launching the 10-turn interview, scan the venture for ALL useful context — not just a PRD. A typical OneStudio venture has signal scattered across `README.md`, `CLAUDE.md`, `docs/`, `specs/`, `plans/`, and discovery notes. Reading multiple sources at once produces a far richer prefill than locking onto one file.

This phase is **mode-gated to `new`**. If the user picked `refit` in Phase 0, skip directly to Refit mode.

The flow:

1. **Discover** candidate context files across the venture.
2. **Rank** them by signal density.
3. **Read + synthesize automatically** — read the top-ranked files **silently, without
   asking the user which to read**. The job here is just to pull a clean, professional
   domain label (and the other prefill fields) out of whatever's on disk. Don't make
   the user curate a file list.
4. **Enforce** domain-widening discipline + professional domain-label convention.
5. **Present** a single proposal screen with per-field confidence colors.
6. **Resolve** — accept, edit, widen, narrow, verify, add source, or restart.

### Step 0.5.1 — Discover context candidates

Run a multi-path scan. For each `*.md` file in these locations, capture name + line count + last-modified:

```
Tier 1 (repo root):
  README.md · CLAUDE.md · AGENTS.md · VISION.md · prd.md · PRD.md

Tier 2 (common doc folders):
  docs/*.md         (all, not just one)
  specs/*.md
  plans/*.md
  discovery/*.md
  .github/copilot-instructions.md

Tier 3 (assistant context):
  .claude/CLAUDE.md   (note: read-only context, not for extraction)
```

Cap discovery at 20 candidates. If a folder contains > 8 markdown files, take only the 8 most-recently-modified.

**If zero candidates exist:** skip directly to Phase 1 — there is nothing to read or prefill from.

### Step 0.5.2 — Rank by signal density

For each candidate, compute a score:

```
+ 3   filename contains: prd · vision · brief · spec · overview · architecture
+ 2   ≥ 5 markdown headings
+ 2   contains domain keywords (audience · user · scope · market · regulation ·
       compliance · jurisdiction · stakeholder · workflow · feature)
+ 2   filename is CLAUDE.md (high-signal: project rules + decisions)
+ 1   ≥ 200 lines
+ 1   last modified within 30 days
- 2   filename matches: CHANGELOG · LICENSE · CONTRIBUTING · CODE_OF_CONDUCT
```

Sort descending. Reject candidates with score < 2 (low signal). Keep top 10.

### Step 0.5.3 — Auto-read (no question)

**Do not ask the user which files to read.** Reading the venture's own docs is a
no-risk action — just do it. Take the **top 5** ranked candidates (or all of them if
fewer than 5) and read them silently in Step 0.5.4. The whole point of this step is to
mine an accurate, professional **domain label** plus the other prefill fields — the
user shouldn't have to curate a reading list to get that.

```
(silent) Reading the 5 highest-signal docs to draft your domain framing…
```

A one-line progress note is fine; a file-selection menu is not. The user's review
happens **once**, on the proposal screen (Step 0.5.6) — where they can `add-source` a
path the scan missed. Don't add a confirmation gate before reading.

**If zero candidates exist** (already handled in Step 0.5.1) → jump to Phase 1 and run
the blank interview.

### Step 0.5.4 — Read + synthesize

Use the Read tool to load each of the top-ranked files end-to-end (no user prompt — see Step 0.5.3). While reading, build an in-memory candidate map for each prefill field. **A single field may draw evidence from multiple files** — record every source.

Fields to extract:

```
(no slug / display_name)   The agent's identity is NOT extracted here. It is set in
                           Phase 2 — derived from the persona (Phase 1.5), or from the
                           domain if `abstract`. Do NOT show a Slug or Display-name
                           row on the proposal screen.
domain_one_liner           the WIDER category, never a specific product — phrased with
                           the PROFESSIONAL DOMAIN-LABEL CONVENTION (see Step 0.5.5).
                           A named practice band + geography-as-modifier + sub-topics,
                           NOT a whole sector + a whole region.
geo_scope                  any geography mentioned (MENA, KSA, GCC, …)
bilingual + languages      true if any source is bilingual or names a non-English audience
primary_user               role + seniority (from user/audience/customer sections)
user_context               what they're doing (from use cases / scenarios)
example_question           a real question that user would bring to the agent
primary_categories         1–3 categories from Phase 4's canonical list
reference_implementation   the venture/product described in the sources (name, role, note)
comparable_peers           3–7 named peer companies in the same category
out_of_scope_hints         any "we won't do X" or "out of scope" language (prefills Phase 7 Q7)
kb_categories_guess        likely KB folders from source type, mapped to Phase 6's
                           canonical list (regulations · frameworks · market-data ·
                           cultural-context · vendor-playbooks · experience).
                           e.g. compliance/statute sources → regulations;
                           bilingual/glossary sources → cultural-context.
                           (prefills Phase 6 Q6)
```

For each extracted value, attach **confidence + sources[]**:

```yaml
domain_one_liner:
  value: "merchant-funded loyalty in MENA, focused on retention economics"
  confidence: high              # high | medium | low
  sources:
    - file: docs/prd.md
      lines: "4-12"
      quote: "We help MENA retailers fund cashback…"
    - file: CLAUDE.md
      lines: "§1"
      quote: "Loyalty platform serving regional brands"
  derived: false                # true if no direct quote; LLM inferred
```

**Confidence rules:**

- **high** — value extracted nearly verbatim from a quoted phrase in at least one source.
- **medium** — value synthesized across multiple sources, no single direct quote.
- **low** — value guessed or inferred without clear textual evidence (e.g. peers list with no source mentioning competitors).

### Step 0.5.5 — Enforce domain widening + professional domain-label convention

The sources almost always describe ONE specific product. The agent's domain MUST be the wider category, never the product itself. Apply these checks **before showing the proposal**:

**Professional domain-label convention** *(how the existing catalog names domains —
match it):*

The label is what feeds the persona search and the agent's `# Your domain` section, so
it must read like the catalog, not like a casual phrase. The catalog pattern is:

```
[senior · independent] expert {on | in | for} <named practice band>
  <geography as a MODIFIER, glued to the practice>
  : <2–4 scoping sub-topics>

Real examples from the catalog:
  ✓ "merchant-funded loyalty, embedded cashback, retention economics" (Aref)
  ✓ "Iraqi K-12 education: curriculum G6-G12, Wazari exams"            (Fekri)
  ✓ "GCC corporate gifting governance: anti-bribery, GAP…"            (Wafaa)
  ✓ "Qatar's economy: hydrocarbons, financial system, policy"         (Shaheen)
```

Three rules that separate a professional label from a flat one:

1. **Practice band, not a whole sector.** Narrow the field to a named sub-discipline.
   `"education"` → `"K-12 education policy"`. `"economy"` → `"macroeconomy & energy
   policy"`. The narrower and more named, the more professional.
2. **Geography is a coherent modifier, not the headline.** Use the smallest unit where
   the expertise genuinely differentiates — usually one country, or a real regulatory
   bloc (GCC). Avoid sprawling units like "the Arab world" unless the domain is truly
   homogeneous across it.
3. **Append 2–4 sub-topics** (the colon list). This is what makes the scope auditable.

```
✗ too flat   "education expert in Saudi Arabia"
✓ pro        "K-12 education policy expert for Saudi Arabia: curriculum, assessment,
              Tatweer reforms, teacher pipeline"

✗ too flat   "economy expert in the Arab world"
✓ pro        "GCC macroeconomy & energy-policy expert: fiscal balance, diversification,
              sovereign funds, hydrocarbon transition"

✓ already pro "GCC tax-compliance expert across VAT, Corporate Tax & Excise"
```

Render the label bilingually when the domain is bilingual (e.g.
`خبير الامتثال الضريبي الخليجي · GCC tax-compliance expert`).

**Domain-widening examples — required widening:**

```
Sources describe "Member Plus" (loyalty platform)
  ✗ domain: "Member Plus expert"
  ✓ domain: "merchant-funded loyalty in MENA"
  → Reference implementation: Member Plus
  → Peers: Bilt, Rakuten, Entertainer, Collinson, Sprive

Sources describe "RevXAI Auditor" (AI code reviewer)
  ✗ domain: "RevXAI expert"
  ✓ domain: "AI-assisted code review for rapid-prototype apps"
  → Reference implementation: RevXAI Auditor
  → Peers: Snyk, SonarQube, CodeRabbit, GreptileAI, DeepCode

Sources describe "TaxFlow" (bilingual GCC tax practice platform)
  ✗ domain: "TaxFlow expert"
  ✓ domain: "GCC tax compliance across VAT, CT, and Excise"
  → Reference implementation: TaxFlow
  → Peers: PwC ME, Deloitte ME, EY ME, KPMG ME, BDO ME
```

**Auto-checks (run before presenting):**

- `slug` MUST NOT contain a product name from any source.
- `domain_one_liner` MUST NOT begin with `for <ProductName>` or `<ProductName> expert`.
- `domain_one_liner` MUST describe a body of knowledge applicable to **multiple companies**.
- `comparable_peers` MUST list **≥3 named companies/products** that aren't the venture's subject.

If any check fails, **fix it silently before showing the user**. Don't show a draft you'd have to apologize for. Demote the field's confidence to `medium` after a domain-widening fix (the value is now LLM-synthesized, not directly extracted).

**Project-detection fallback:** if no peers can be found, the work is likely a *project*, not a *domain*. Surface explicitly:

> "I can't find a wider category for this — the sources read as one specific product without peers. A project-PM agent is a legitimate ask, but it's NOT what this skill produces. Want me to (a) push you to articulate the wider domain anyway, or (b) bail and recommend a generic Claude Code subagent with your CLAUDE.md as context?"

### Step 0.5.6 — Present the proposal

Show **one compact screen** with confidence colors. Use 🟢 (high), 🟡 (medium), 🔴 (low) markers.

```
**Proposed framing** — synthesized from N sources

  Field               Proposed                                       Conf.   Source
  ─────────────────   ───────────────────────────────────────────    ────    ──────
  Domain              GCC tax compliance across VAT, CT, Excise        🟢      PRD §1, CLAUDE.md §1
  Geo / language      GCC, bilingual EN/AR                              🟢      PRD §2, CLAUDE.md §1
  Primary user        Tax advisors serving GCC clients                  🟡      derived from PRD §3
  User context        Filing VAT returns + advising on CT obligations   🟡      PRD §5–7
  Example question    "How do I treat reverse-charge VAT on imports     🟡      derived
                      between UAE and KSA?"
  Primary categories  regulatory_compliance, reference_lookup           🟢      PRD §1, §5
  Reference impl.     TaxFlow                                           🟢      PRD title
  Comparable peers    PwC ME, Deloitte ME, EY ME, KPMG ME, BDO ME       🔴      no source — guessed
  Out-of-scope hints  zakat (refused), personal tax advice              🟢      CLAUDE.md §3
  Knowledge folders   regulations, cultural-context                     🟡      derived from source type

**Notice:** sources describe one specific venture (TaxFlow). I framed the
agent around the WIDER category (GCC tax compliance) so any team in the
same space can use it. The venture becomes the Reference Implementation,
not the agent's identity.

**The agent's name is NOT decided here.** The `slug` + display name are set in
**Phase 2 (Identity)** — derived from the **persona** you choose in Phase 1.5. That's
why no Slug row appears above.

⚠ Fields marked 🔴 need your review — I had no direct source for them.
   Run `verify-peers` to do a web search for stronger peer candidates.

Does this framing fit?

  yes               — accept all → Phase 1.5 (Persona) → Phase 2 (Identity) → Phase 5
  edit N            — edit field N
  verify-peers      — run web search to propose better peers (uses Firecrawl/Tavily)
  show-source N     — show full quoted evidence for field N
  add-source PATH   — feed me another file, re-synthesize
  too-narrow        — propose a broader domain framing
  too-wide          — propose a narrower domain framing
  restart           — drop the prefill, run the full interview from Phase 1
```

→ Type one option.

### Step 0.5.7 — Resolve the choice

- **`yes`** → capture every proposed value into the running answers, preserving each value's `confidence` and `sources[]` metadata. Mark each field's `origin` as `prefilled` in the running summary (so the user sees later which came from sources vs. typed vs. default). This covers Phases 1–4 **plus** the Phase 6 `kb_categories` guess and the Phase 7 `out_of_scope` hints — so those two later questions become **confirm-only** (shown with the prefilled value as the default). The domain is now locked (the proposed `slug` is **provisional** — it will be finalized in Phase 2 from the persona), so run **Phase 1.5 — Persona Discovery** next, then **Phase 2 — Identity** (derive/confirm the name), then **Phase 5 — Output schemas**, then continue 6 → 7 → 8 → 9, confirming the prefilled Phase 6/7 values in one keystroke each.

- **`edit N`** → ask for the new value for that field only. Update the running answers; set `origin: typed` and `confidence: high` (user-authored is authoritative). Re-display the table. Loop until the user types `yes`.

- **`verify-peers`** → use the available MCP web-search tool (Firecrawl `firecrawl_search` or Tavily) with a query derived from `domain_one_liner` + `geo_scope` (e.g. `"GCC tax compliance firms" comparable peers`). Propose 5–8 candidates with one-line descriptions. Ask the user to pick 3–7. Update `comparable_peers` with `confidence: high` and `sources: [<URL>...]`. Re-display the table. **Do not fabricate peers** — if web search is unavailable, say so and ask the user to provide names.

- **`show-source N`** → print the full quoted evidence for field N (file + lines + quote). Re-display the table after.

- **`add-source PATH`** → verify the path exists, append it to the read set, re-run Step 0.5.4 (synthesize) and Step 0.5.5 (widen). Re-display.

- **`too-narrow`** → re-extract with a wider lens (e.g. "GCC tax compliance" → "MENA regulatory & tax practice"). Re-run auto-checks. Re-display.

- **`too-wide`** → tighten the framing toward the actual specialty (e.g. "MENA fintech" → "merchant-funded loyalty in MENA"). Re-run auto-checks. Re-display.

- **`restart`** → drop the prefill entirely. Continue to Phase 1.

### Anti-patterns in Phase 0.5

- **Don't lock onto one file when more is available.** Always present the ranked list and let the user pick scope.
- **Don't fabricate sources.** If a field is `low` confidence (no source), label it that way — don't manufacture a citation.
- **Don't ever take a product name as the domain.** The product is the Reference Implementation. If you find yourself proposing it, stop and widen.
- **Don't skip the auto-checks.** They exist because LLM extraction will sometimes slip the product into the domain field.
- **Don't show the proposal if `comparable_peers` is empty.** That's the strongest single signal the framing is too narrow. Either widen first, or run `verify-peers` proactively before showing.
- **Don't ask 5 questions to verify the discovery.** One question (Q0.5 list selection), one synthesis pass, one proposal screen.
- **Don't lose the user's overrides.** Once they `edit N`, that field is theirs (`origin: typed`) — don't re-propose it on re-display, even after `add-source`.
- **Don't ignore confidence.** The 🔴 markers tell the user where to focus review. If you proceed without them, the value of confidence collapses.

---

## Create mode — the 9-phase interview

### Phase 1 — Domain framing *(runs first — the persona search and the agent's name both key off it)*

> **Order note (v0.7):** the domain comes **before** identity now. The agent's
> name is no longer invented from scratch — it is **derived from the persona**
> chosen in Phase 1.5 (which itself needs the domain to search). So the first
> three phases run: **1 Domain → 1.5 Persona → 2 Identity.**

> **Prefill reuse:** if the user accepted a Phase 0.5 proposal, `domain_one_liner`,
> `geo_scope` / `bilingual`, `reference_implementation`, and `comparable_peers`
> are already captured. **Do not re-ask the domain screen.** Go straight to
> **Phase 1.5 (Persona)**. Only run the screen below when there was no prefill
> (blank create, or the user typed `restart`).

**Q1 — Domain framing** *(one screen, five parts)*

Ask all five parts together. The user answers in one message. This screen sets the
agent's **domain spine** and seeds the persona search that follows.

```
**1 · Domain or project?**  (framing gate)

  domain   — a body of knowledge that applies to many companies
             (e.g., "merchant-funded loyalty in MENA", "GCC corporate
              gifting governance", "Iraqi K-12 education").
             Reference companies are EXAMPLES, not the agent's identity.
  project  — a single product, codebase, or venture's PM work.
             (e.g., "Member Plus product manager", "RevXAI auditor").

**2 · Domain in one sentence**

  Shapes:  [market/regulatory] expert for [geography]
           [product practice] expert for [audience]
           [research domain] expert for [user]

**3 · Geography + language**   (default: monolingual English)
  bilingual — name primary language + one to switch to on user signal

**4 · Reference implementation**   (optional — type "none")
  Name / Role / Note — the one venture where this domain is applied today,
  framed as ONE example, never the agent's identity.

**5 · Comparable peers**   (3–7 names — REQUIRED)
  Named companies/products/programs in the same category. Examples:
    loyalty / cashback  →  Bilt, Rakuten, Entertainer, Collinson, Sprive
    K-12 education       →  IB, Cambridge, AERO, regional curricula bodies
    WhatsApp marketing   →  Wati, Gallabox, AiSensy, Twilio, Meta BSPs
```

→ Answer parts 1–5 in one message (part 4 may be `none`).

**Resolution rules — apply in order after the user answers:**

1. **Framing gate.** If part 1 = `project`: **stop.** This skill is scoped to
   domain experts, not project agents. A project PM agent is legitimate but a
   different shape — use a generic Claude Code subagent with the project's
   CLAUDE.md as context. Re-invoke only when the work can be framed as a *domain*
   of which the project is one example.

2. **Reusability test.** Would another company in this same domain — not the
   user's venture — also benefit? If no, the framing is too narrow → ask once to
   widen part 2 before continuing.

3. **Anti-pattern auto-flag (part 2).** If the sentence leads with
   `for <ProductName>` or `<ProductName> expert`, or names a single venture as the
   agent's purpose → reframe; the venture belongs under part 4, not part 2.

4. **Bilingual smart-default.** If part 2 names a non-English geography and the
   user left part 3 blank, default to bilingual and confirm in the running line.

5. **Peers are mandatory.** If part 5 is empty, push back once: "Without
   comparables, the agent has no category to reason against. List 3 — even rough
   peers." If still empty after that one pushback, the work is actually a
   *project* — **return to part 1** and re-evaluate. Don't accept an empty list;
   the agent's own eval (cross-venture applicability) fails without peers.

Capture: `framing` (must = `domain`), `domain_one_liner`, `geo_scope`,
`bilingual`, `languages`, `primary_language`, `reference_implementation`
(object or null), `comparable_peers` (non-empty list).

---

### Phase 1.5 — Persona Discovery *(embody a real domain figure — and name the agent after them)*

An agent lands harder when it carries the voice of a real, influential expert in the
domain — a **homage** to that person's school of thought, frameworks, and style. This
is **inspired-by tribute, never quote-attribution**: the agent thinks and behaves
*like* the figure, grounded in their documented body of work; it does **not** claim
"X said Y" or invent their record.

**This phase drives the agent's identity.** When the user picks a figure here, the
next phase (2 Identity) derives the agent's `slug` and display name **from that
figure's name** — not from the domain. The persona *is* the agent.

This phase is **mode-gated to `new`**, runs **right after the domain is locked** (via
Phase 0.5 prefill or the Phase 1 screen) and **feeds Phase 2 (Identity)**. It **always
proposes 3 candidates**; the user may pick one, supply their own, blend a composite, or
skip to an abstract expert (in which case Phase 2 falls back to a domain-derived name).

#### Step A — Search (bilingual · multi-angle · anti-miss)

The whole value of this phase dies if the search misses well-known figures. Two rules
prevent that: **search in BOTH the domain's primary language AND English**, and **fan
out across angles**. MENA/Arabic figures are badly under-indexed in English-only search
— an English-only sweep would miss "صلاح أبو المجد" entirely.

1. Derive **5–6 query angles** from `domain_one_liner` + `geo_scope`. Render each in
   the domain's primary language **and** English:
   ```
   "<domain> thought leaders / experts"        · "خبراء / رواد <المجال>"
   "best-known <domain> author / speaker"      · "أشهر مؤلّفي / مدرّبي <المجال>"
   "top <domain> figures in <geo>"             · "أبرز شخصيات <المجال> في <المنطقة>"
   "<domain> most-followed / influencers"      + award / ranking / "top 50" lists
   "people behind <comparable peer>"           (reuse the Phase 2 peers)
   ```
2. Use the available web-search tool (firecrawl `firecrawl_search` / Tavily /
   `WebSearch`). Run the angles **concurrently** (parallel calls), each blind to the
   others — a multi-modal sweep, so no single search angle becomes the bottleneck.
3. **Dedup** by normalized name; reconcile transliteration variants
   (`Abo El Magd` ↔ `أبو المجد`).
4. **Disambiguate collisions** — confirm the candidate is the figure in *this* domain
   (e.g., Salah Abo El Magd the leadership trainer ≠ Ahmed Kamal Abo El Magd).
5. **Rank** by influence signals corroborated across **≥2 independent sources**:
   cross-platform following, books/publications, media presence, leadership of known
   orgs, recency of activity.
6. **Filter** to recognized **public** figures in this domain; drop private
   individuals.
7. Pick the **top 3 DIVERSE** candidates — different schools / eras / angles, not three
   clones of one niche.

If web search is unavailable, say so plainly and ask the user to name a figure
(→ Step C `custom`). **Never fabricate a candidate** — a made-up "expert" poisons the
whole agent.

#### Step B — Present 3 candidates

One card per candidate, with a confidence marker (🟢 high / 🟡 medium / 🔴 low):

```
**Persona candidates** — influential figures in <domain>

  [1] <Name> (<الاسم بالعربية>)                                  🟢
      Why influential — <one line: what they're known for>
      Signature — <frameworks / concepts / books they're known for>
      Era — living public figure | legacy        Fit — <why they suit this agent>
      Sources — <2–3 URLs>

  [2] ...                                                         🟡
  [3] ...                                                         🟡

This persona is a HOMAGE — the agent reasons in the figure's style and school,
grounded in their documented work. It never attributes invented quotes to them.

  pick N      — embody this figure
  custom      — name your own figure (+ links / notes); I'll verify and build it
  composite   — blend the three into one "school-of" archetype (broader, de-risked)
  abstract    — no real figure; a generated domain voice (skip persona)
  verify N    — deep-dive + corroborate a candidate before choosing
```

→ Type one option.

#### Step C — Resolve

- **`pick N`** → build the persona profile from that figure (Step D).
- **`custom`** → user names a figure + optional links/notes. Verify via search (don't
  trust a single unsourced claim), then build the profile. If the named person is a
  **private individual** (not a public domain figure), decline and offer `composite` or
  `abstract` instead.
- **`composite`** → blend the 3 (or a named set) into a **school-of archetype**. The
  profile cites all contributors. The agent's name becomes the archetype, not any one
  person.
- **`abstract`** → no real persona. The agent uses a generated domain voice (the
  pre-persona behaviour). Capture `persona_kind = abstract` and continue to Phase 2
  (Identity), which will then derive the name from the **domain** instead of a figure.
- **`verify N`** → deep-dive one candidate (more searches, corroborate signals),
  re-display the card set.

#### Step D — Build the persona profile (cited)

Extract from the chosen figure's **documented** body of work — each item with a source:

```
Signature frameworks / models   the figure is known for
Core concepts & vocabulary      their idioms, recurring terms
Communication style & tone      how they speak / write / structure ideas
Recurring themes & stances      positions evident across their work (cited)
Scope edges                     what they are NOT an authority on
```

Write it to `agents/<slug>-knowledge/persona/<figure-slug>-profile.md`. **Phase 1.5
owns this `persona/` folder** — it is **not** one of the canonical Phase-6 KB
categories, so do not add `persona` to the Q6 list or invent a new canonical slug.

#### The tribute contract *(baked into the generated agent — see template)*

- **One-time disclosure** at identity: "A domain expert inspired, in homage, by
  *<name>*'s body of work — not *<name>*, and not speaking for them."
- Speaks **first-person, confidently, in the figure's manner**; reasons in their style
  about new questions. **No per-message hedging** — the disclosure is stated once.
- **Grounded** in the figure's documented work (the cited profile drives the voice).
- **Floor (thin, non-intrusive):** never fabricate a specific quote, statistic, date,
  or publication and present it as the figure's actual record; never put a
  controversial or defamatory position in their mouth. This is the existing
  anti-fabrication rule, extended to the persona.

Capture: `persona_kind` (`real` | `composite` | `abstract`), `persona_name`,
`persona_name_ar`, `persona_voice` (style summary), `persona_sources[]`,
`persona_profile_path`.

---

### Phase 2 — Identity *(derived from the persona — this is the agent's name)*

By now the domain (Phase 1) and the persona (Phase 1.5) are known. Identity is no
longer invented from scratch — it **follows the persona choice**.

**If a figure was chosen (`persona_kind` = `real` or `composite`):**

Derive the identity from the figure's name and show it for one-tap confirmation —
don't ask from a blank field:

```
**Q2 — Confirm identity** (derived from your persona)

  slug          salah-abo-elmagd          ← kebab of the figure's name
  display_name  Salah Abo El Magd
  name_ar       صلاح أبو المجد              ← if the figure has an Arabic name

  confirm   — take these
  edit      — change slug / display name / Arabic name
```

Derivation rules:
- `slug` = kebab-case of the figure's common name (ASCII; transliterate Arabic).
- `display_name` = the figure's full name in the domain's primary script.
- `name_ar` = the figure's Arabic name when one exists; omit otherwise.
- For a `composite`, derive from the **archetype label** set in Phase 1.5
  (e.g. `gcc-loyalty-school`), not from any single contributor's name.
- This **overrides** any provisional slug proposed on the Phase 0.5 screen.

**If `abstract` was chosen:**

Fall back to the pre-persona behaviour — ask for slug + display name, or generate them
from the domain:

```
**Q2 — Slug + display name**

What's the slug (kebab-case) and display name? Add an Arabic display name only if the
domain is bilingual.

  Examples:  slug: tax-advisor    display: Tax Advisor
             slug: pricing-pro    display: Pricing Pro
```

→ Type / confirm slug + display name (and optional Arabic name).

Capture: `slug`, `display_name`, `display_name_ar`.

---

### Phase 3 — User *(auto-derive + confirm in Phase 9 — not a blank turn)*

**Q3 — Primary user** *(derive from the domain; don't ask blank)*

Do **not** ask from blank. The primary user is strongly inferable from the domain
(e.g. "residential real-estate marketing in KSA" → a marketing lead at a Saudi
brokerage/developer). Derive all three:

```
if Phase 0.5 prefilled user fields  → use them
else derive from domain_one_liner + geo_scope:
  Role:     <the obvious practitioner role + seniority for this domain>
  Context:  <what they're doing day-to-day>
  Example:  <a realistic question they'd bring — this anchors the agent's voice>
```

Surface all three read-only in the Phase 9 summary. The **example question** especially
must be shown for confirmation — it anchors the voice, so it's the one most worth a
human glance. Capture: `user_role`, `user_context`, `example_question`.

---

### Phase 4 — Primary work

**Q4 — Categories of work**

Pick 1–3 categories. Primary first.

```
1. decision_support      — structured verdict with reasoning
2. reference_lookup      — cited answers to domain questions
3. structured_review     — audit an artifact, return categorized findings
4. competitive_intel     — profile competitors, comparables
5. regulatory_compliance — apply named regulations
6. handoff_partner       — structured briefs for other agents/humans
7. educational_explainer — teach domain concepts
```

These slugs are also the CONTRACT category vocabulary — they are emitted
verbatim into the agent frontmatter `categories:` list and become the hub's
`agents.skills`. Do not invent new slugs.

→ Type the numbers. Primary first.

If user picks more than 3, gently note: *"That's broad. Most agents focus on 1–3. Want to mark a primary and use defaults for the rest?"*

Capture: `primary_categories`.

---

### Phase 5 — Output schemas *(NOT a question — silent spine inheritance + one auto-derived field)*

**Do NOT show a schema screen. Do NOT ask anything here.** Phase 5 is no longer an
interview turn. A question only earns a turn when its answer (a) varies meaningfully
across agents AND (b) the system can't infer it well. Run the schema fields through
that test:

```
Decision schema  (Verdict · Why + risks-when-needed)   →  doesn't vary   → SPINE, silent
Confidence vocab ([VERIFIED]/[UNVERIFIED]/[NEEDS-…])    →  doesn't vary   → SPINE, silent
Review schema    (🔴🟡🟢❓🚏)                            →  doesn't vary   → SPINE, silent
Verdict vocabulary (the decision WORDS)                →  varies, but inferable → AUTO-DERIVE
```

Portfolio evidence that only the verdict *words* vary (the shapes don't):
`membership → Go/Go-with-conditions/No-Go` · `rushd → Yes/No/Needs-adjustment` ·
`nala → Invest/Hold/Pivot/Kill` · `salwa → Pursue/Pass/Restructure`.

**What Phase 5 actually does (no user turn):**

1. **Schema shapes → spine, silent.** For each category claimed in Phase 4, the agent
   inherits the matching `schema_*` fragment from `domain-experts/spine/SPINE.md`
   verbatim (Phase 9 injects it). Mark every claimed category `schema_origin: spine`.
   Capture nothing. Ask nothing.
2. **Verdict vocabulary → auto-derive** (only if `decision_support` is claimed). From
   `domain_one_liner` + `primary_categories`, propose 3–5 domain-fit decision words
   using Q5a's catalog as a guide (e.g. real-estate marketing → `Launch / Adjust /
   Hold`; investment → `Invest / Hold / Pivot / Kill`). Store as `verdict_vocab` with
   `origin: derived`. **Do not interrupt the interview to confirm it** — it surfaces
   read-only in the Phase 9 summary, where the user can override it in one line.

So Phase 5 costs **zero** forced turns: the invariant shapes are inherited silently,
and the one genuinely domain-variable field (verdict words) is derived, not asked.

**Override paths (no mid-interview screen):**

- The user can change the derived verdict words at the Phase 9 summary (`edit
  verdict-vocab`). That flips it to `schema_origin: override` for `decision_support`.
- A user who explicitly wants to reshape a schema body (rare; expert move) can say so
  at Phase 9 — only then walk the relevant Q5a–Q5h override menu and capture a delta
  override. Absent that, every shape stays spine-inherited.

The Q5a–Q5h blocks below are the **catalog** the auto-derivation and the optional
Phase-9 override draw from — default content + override menus. They are reference,
**not a question sequence, and not a screen shown during the interview.**

#### Q5a — Verdict vocabulary *(if `decision_support` claimed)*

What words end every decision?

**✨ Default — pick from your domain**

```
Product decision      →  Yes / No / Needs adjustment
Investment decision   →  Invest / Hold / Pivot / Kill
Review decision       →  APPROVED / PROVISIONAL / REJECTED
Validation decision   →  Go / Go-with-conditions / No-Go
```

*3–5 words is the sweet spot. Easy to scan. Clear meaning.*

**Override:**

```
custom  — write your own
```

→ Type a vocabulary, or `custom`.

Capture: `verdict_vocab`.

#### Q5b — Decision schema *(if `decision_support` claimed)*

How does every decision answer look?

**✨ Default — adaptive**

```
Always:       Verdict · Why
When needed:  Risks · Conditions · Impact · Next steps
```

*Light questions stay short. Heavy ones go deep.*

**Override:**

```
rigid    — always show 5 sections (Decision/Why/Risks/Alt/Impact)
7-step   — full advisory (Clarification → Options → Trade-offs → ... → Follow-ups)
3-block  — short action format (Bottom-line/Why/Action)
custom   — write your own
```

→ Type `default`, `rigid`, `7-step`, `3-block`, or `custom`.

Capture: `response_sections`.

#### Q5c — Confidence vocabulary *(if `reference_lookup` claimed)*

How does the agent label uncertain claims?

**✨ Default — three-state tags**

```
[VERIFIED]      — cited and confirmed
[UNVERIFIED]    — stated, not cross-checked
[NEEDS-RESEARCH] — agent doesn't know; flagged
```

*Three states is enough. More is rarely used.*

**Override:**

```
five-state    — confirmed / reported / estimated / uncertain / not knowable
source-tier   — Tier 1 (official) / Tier 2 (analysis) / Tier 3 (synthesis)
experience    — direct experience / readings / general context / official source
kb-citation   — [knowledge/<path>.md] / [source: <url>]
custom        — write your own
```

→ Type `default`, a keyword, or `custom`.

Capture: `confidence_vocab`.

#### Q5d — Review schema *(if `structured_review` claimed)*

What sections does every review have?

**✨ Default — severity-marker schema**

```
🔴 Blockers          — issues that prevent moving forward
🟡 Friction          — issues that slow but don't block
🟢 Wins              — strengths to preserve
❓ Open questions    — unresolved before deciding
🚏 Routed            — findings for legal / finance / other roles
```

*Colored markers make the review skimmable. Routed forces explicit hand-offs.*

**Override:**

```
8-section   — Executive Summary / Mode / Confidence / [domain] / Unknowns
verdict-fields — single verdict + conditional follow-ups
custom      — write your own
```

→ Type `default`, a keyword, or `custom`.

Capture: `review_sections`.

#### Q5e — Competitor classification *(if `competitive_intel` claimed)*

How are competitors classified?

**✨ Default — three-tier**

```
Direct       — same problem, same audience, same approach
Indirect     — similar problem, different model
Substitute   — different category, replaces in practice
```

*Mutually exclusive tiers force clarity. Most teams overstate "direct".*

**Override:**

```
matrix-only  — comparison matrix, no tiering
custom       — write your own
```

→ Type `default`, a keyword, or `custom`.

Capture: `competitor_classification`.

#### Q5f — Regulation citation rule *(if `regulatory_compliance` claimed)*

How are regulations cited?

**✨ Default — article-level + applicability check**

```
Format:  <Reg-Name> Article <N> (<year>), applies to <geography> <segment>
Example: PDPL Article 22 (2023), applies to KSA-resident data subjects
```

*Article-level is auditable. The applicability check stops vague compliance gestures.*

**Override:**

```
name-year-url  — regulation name + year + source URL
custom         — write your own
```

→ Type `default`, a keyword, or `custom`.

Capture: `regulation_citation_rule`.

#### Q5g — Handoff brief format *(if `handoff_partner` claimed)*

What's in every handoff brief?

**✨ Default — six-part brief**

```
1. Question being handed off
2. Receiver context
3. Domain constraints to honor
4. What NOT to prescribe
5. What good looks like
6. Open questions for the receiver
```

*Covers the failure modes of cross-role handoffs. Hard to improve on.*

**Override:**

```
custom  — describe your own format
```

→ Type `default` or `custom`.

Capture: `handoff_format`.

#### Q5h — Pedagogical structure *(if `educational_explainer` claimed)*

What's the structure of every explanation?

**✨ Default — five-part teaching schema**

```
1. Simple definition
2. Why it matters
3. Practical example
4. Common mistake
5. How it applies to your context
```

*Forces examples and pitfalls. Pure definitions feel academic.*

**Override:**

```
4-part   — Definition / Example / Anti-pattern / Application
custom   — write your own
```

→ Type `default`, `4-part`, or `custom`.

Capture: `explainer_structure`.

---

### Phase 6 — Knowledge *(DERIVED + confirmed in Phase 9 — not a blank turn)*

**Q6 — Knowledge categories** *(auto-derive from the domain; never ask from blank)*

Do **not** present a blank picker. Derive `kb_categories` from the domain + source
types, then surface the proposal read-only in the Phase 9 summary for one-line edit:

```
if kb_categories_guess was captured in Phase 0.5  → use it
else derive from the domain one-liner + categories:
  regulated / statute / compliance domain   → regulations
  bilingual / dialect / culture-heavy domain → cultural-context
  competitor / vendor / platform domain      → vendor-playbooks
  benchmark / pricing / market domain         → market-data
  methodology / playbook domain               → frameworks
  practitioner-experience domain              → experience
```

The keywords are the **canonical folder names** (below) — Phase 9 emits one folder per
derived category. Do not invent new names. The reference picker list:

```
1. regulations         — Regulations and statutes
2. frameworks          — Industry frameworks and methodologies
3. market-data         — Market data and benchmarks
4. cultural-context    — Cultural / linguistic context
5. vendor-playbooks    — Vendor / competitor playbooks
6. experience          — Personal experience anchored to a community
7. none                — The agent reasons from prompt context only
```

Phase 9 emits one folder per derived category, plus seeded stubs for any category that
has a template in `templates/kb/`. If the derivation yields nothing (a pure
prompt-context agent), set `kb_categories = none`.

Capture: `kb_categories` (list of canonical folder names) — **derived, surfaced in the
Phase 9 summary, not asked as a blank turn.**

**Q6b — Live source access** *(DERIVED — not asked)*

Do **not** ask. Portfolio evidence: only ~7/16 agents read live source, and it tracks
exactly one thing — whether the agent is embedded in a codebase/venture it can read.
So derive it:

```
reference_implementation present (a repo/venture the agent applies to)
        → live_source_access = true,  live_source_paths = [TBD]  (or prefill paths)
otherwise (pure reference / web / research domain)
        → live_source_access = false
```

Surface the derived value read-only in the Phase 9 summary; the user can flip it
there in one line. Capture: `live_source_access` (bool), `live_source_paths`.

*(Why derived, not defaulted-yes: a blanket "yes" was wrong — most domain experts —
ziad, abo-lijan, fekri — have no live source to read. Presence of a reference
implementation is the real signal.)*

**Q6c — Memory scope** *(SILENT DEFAULT — not asked)*

Do **not** ask. Portfolio evidence: **15/15 agents = `project`** — zero variance. The
mechanics already live in the spine (`memory_mechanics`). So set silently:

```
memory_enabled = true ,  memory_scope = project
```

Surface it read-only in the Phase 9 summary; honor `user` / `local` / `none` **only**
if the user explicitly asks there. Capture: `memory_enabled`, `memory_scope`.

**Q6d — Knowledge harvest** *(workflow-driven deep search + extraction — the heart of a credible agent)*

This is what lifts the agent from *sounding like* the expert to *reasoning from* the
expert's knowledge and the domain's authoritative canon. Run it whenever
`kb_categories ≠ none`. It is a **deep search + extraction at creation time**, executed
as a **parallel Workflow** — sequential search would take far too long.

**Source policy (strict — quality over coverage).** Only three tiers may enter the KB;
everything else is rejected. The definition of "official" **adapts to the domain type**
— a single rigid definition fails across domains:

```
Tier E — the figure's own work      books · official site · channel · their org
                                     (only when persona_kind != abstract)
Tier O — official domain sources     authorities / ministries / regulators / standards
                                     bodies — ADAPTS TO DOMAIN:
                                       regulatory / tax → FTA · ZATCA · GAZT
                                       education        → ministry · curriculum bodies
                                       economy          → central banks · IMF · sovereign funds
                                       a person's field → the figure's institution + peers' official sites
Tier A — academic / canonical        known publishers · standard reference books · papers · universities
REJECTED                             personal blogs · reposts · authorless pages · SEO farms · forums
```

**Two registers of output — never blur them:**

```
→ PERMANENT (written into KB):  frameworks · models · methodologies · concepts ·
   principles — EXTRACTED in our own words with a citation (book/chapter · author · year).
   Never copy text verbatim (copyright + the anti-fabrication rule).
→ LIVE INDEX (URLs only, not text):  official sites + pages that update (rates, rosters,
   news). Stored as URL + what's there + when to read it. The agent reads them live via
   WebFetch at question time — never frozen as stale text.
```

**Quality gate per source:** tag each `[official]` / `[academic]` / `[figure-source]`;
reject anything outside the three tiers; any empirical claim (a number / date) needs
**≥2 independent** tier-O/A sources.

**Run it as a Workflow** (bilingual · multi-angle · parallel). The skill executes this
script at Phase 6 — fill `<figure>`, `<domain>`, `<geo>`, `<primary_lang>`:

```js
export const meta = {
  name: 'persona-knowledge-harvest',
  description: "Harvest a figure's works + the domain's official/academic canon into KB",
  phases: [{ title: 'Search' }, { title: 'Gate+Extract' }],
}

const FIGURE = '<figure>', DOMAIN = '<domain>', GEO = '<geo>', LANG = '<primary_lang>'

const tierE = FIGURE ? [   // figure's own work — skipped if abstract
  `Find ${FIGURE}'s published books and articles (search in ${LANG} AND English). Their official site / channel / org only. Return title, url, year.`,
  `Document ${FIGURE}'s signature frameworks/concepts AS STATED IN THEIR OWN WORK. Cite the book/talk. Do not invent.`,
] : []
const tierO = [            // official — definition adapts to the domain
  `Identify the OFFICIAL authorities / regulators / ministries / standards bodies for "${DOMAIN}" in ${GEO}. Official domains only. Names + URLs.`,
  `For "${DOMAIN}" in ${GEO}, list authoritative official pages that UPDATE over time (rates, rosters, news) — these are for LIVE reading, not copying.`,
]
const tierA = [            // academic / canonical
  `List the canonical / standard reference books and academic frameworks for "${DOMAIN}" from known publishers / universities. No blogs, no SEO content.`,
]

phase('Search')
const found = await parallel(
  [...tierE, ...tierO, ...tierA].map(q => () =>
    agent(q + ' Use web search. Reject blogs/reposts/authorless/SEO. Return JSON.',
          { phase: 'Search', schema: SEARCH_SCHEMA })))   // {sources:[{title,url,tier,why}], frameworks:[{name,summary,citation}]}

phase('Gate+Extract')
const result = await agent(
  `Quality-gate these candidates for the "${DOMAIN}" knowledge base. ACCEPT ONLY
   official, academic, or the figure's own sources — reject blogs/reposts/authorless/SEO.
   Tag each [official]/[academic]/[figure-source]. SEPARATE permanent knowledge
   (frameworks/concepts — re-express in our words + citation, never verbatim) from LIVE
   sources (URLs that update — keep as an index only). Require >=2 independent sources
   for any number/date. Candidates: ${JSON.stringify(found.filter(Boolean))}`,
  { phase: 'Gate+Extract', schema: GATE_SCHEMA })  // {frameworks:[...], figure_works:[...], official_sources:[...], rejected:[...]}

return result
```

**Cost cap:** ≤ 4 parallel research agents per tier, ≤ 12 total; stop a tier early once
it has 5 accepted sources. **Log what was dropped** — silent truncation reads as full
coverage.

Then write the outputs:

```
agents/<slug>-knowledge/
  persona/<figure>-works.md        ← figure's books/articles + EXTRACTED frameworks (cited)
  frameworks/<topic>.md            ← canonical domain frameworks (cited, in our words)
  sources/official-sources.md      ← LIVE index of official/authoritative URLs + trust tags
```

Capture: `harvested_frameworks[]`, `figure_works[]`, `official_sources[]` — each with a
trust tag + citation/URL. The `sources/` and `persona/` folders are owned by this phase;
they are not added to the canonical `categories:` list.

---

### Phase 7 — Hard rules

**Q7 — Out of scope** *(auto-derive from the domain; confirm in Phase 9 — not a blank turn)*

Do **not** ask from blank. The refusal set is highly inferable from the domain — the
portfolio shows the same shapes every time ("NOT a journalist/coder/UI", adjacent
regulated specialties). Derive 2–4 items, then surface read-only in the Phase 9
summary for one-line add/remove:

```
if out_of_scope_hints was captured in Phase 0.5  → use it
else derive from these shapes against the domain:
  • Adjacent specialist domains (legal, tax, finance, regulated specialties next door)
  • Implementation work (code, design, copywriting)
  • Decisions belonging to other roles
  • Out-of-domain questions
```

Confirmation matters here: a wrong refusal is high-cost, so the Phase 9 summary always
shows the derived list for the user to correct. Capture: `out_of_scope`.

**Q7b — Anti-fabrication rule** *(strengthening above the spine floor)*

Every agent already inherits the **anti-fabrication floor** from
`domain-experts/spine/SPINE.md` (`anti_fabrication_floor`): never fabricate a quote,
statistic, date, or publication; cite a source per empirical claim; flag uncertainty
rather than guess. **You do not need to ask about the floor — it is always in
force.** This question only asks whether THIS agent strengthens beyond it.

**✨ Default — floor only (the hybrid floor is enough)**

```
Accept the spine floor as-is. No per-agent strengthening line is emitted.
(The floor already requires ≥1 source per empirical claim + uncertainty tagging.)
```

*Most agents need nothing beyond the floor. Pick a strengthening below only when the
domain is high-stakes enough to justify a harder bar (e.g. regulated tax/medical/legal).*

**Strengthen to:**

```
two-source   — every empirical claim needs ≥2 sources, no exceptions
one-tagged   — single source acceptable everywhere if labeled
experience   — direct experience uncited; external claims must cite
strict       — no claims without citation, period
custom       — write your own
```

→ Type `default` (floor only), a keyword, or `custom`.

Capture: `anti_fabrication_rule`. On `default`, set it to the sentinel `floor` —
Phase 9 then emits the spine floor with **no** extra strengthening line. Any other
value emits the floor PLUS a "Beyond the floor, you hold yourself to: …" line.

---

### Phase 8 — Behavior *(DERIVED — not asked)*

**Q8 — Pressure-testing posture** *(derive from Phase 4 categories)*

Do **not** ask. Portfolio evidence confirms the posture tracks the categories, not the
user's taste: decision/review agents pressure-test (salwa, rushd, nala, membership,
sada…), while reference/educational/intake agents stay responsive (fekri, shaheen,
harvester). So derive:

```
primary_categories includes decision_support OR structured_review
        → pressure_test_default = true   (challenge weak assumptions, state disagreement)
otherwise (reference_lookup / educational_explainer / handoff only)
        → pressure_test_default = false  (responsive consultant; raise risks only when material)
```

Surface the derived posture read-only in the Phase 9 summary; the user can flip it
there in one line. Capture: `pressure_test_default`.

*(A blanket "yes" was nearly right but wrong for ~3 agents — the category signal is
exact, so derive rather than default.)*

---

### Phase 9 — Confirm and generate

After the few asked questions (domain framing · categories · persona) are captured,
**everything else is derived**. Phase 9 is the single place the user reviews and
corrects all of it — one screen instead of one turn per field.

1. **Show the consolidated review.** A compact table with every field, each tagged by
   origin: `[asked]` · `[derived]` · `[prefilled]` · `[spine]`. The derived rows are
   the whole point — they were inferred, not asked, so the user scans and corrects
   them here in one place:

   ```
   Identity        Saudi Residential Property Marketing · تسويق العقارات السكنية   [derived]
   Domain          residential real-estate marketing in KSA                       [asked]
   Geo / language  KSA · EN primary, AR on signal                                 [asked]
   Reference impl  Dar Listings (test venture)                                    [asked]
   Comparable peers Aqar · Bayut KSA · Wasalt · Roshn · Retal                     [asked]
   Primary user    marketing lead at a Saudi brokerage/developer                  [derived]
   Example question "Snapchat+TikTok launch, or portals first?"                   [derived]
   Categories      decision_support · competitive_intel · reference_lookup        [asked]
   Out of scope    legal · mortgage advice · valuation · building code            [derived]
   KB categories   market-data · cultural-context · vendor-playbooks              [derived]
   Live source     no (no repo to read)                                           [derived]
   Memory          project                                                        [derived]
   Pressure-test   ON (has decision_support)                                      [derived ← cats]
   Anti-fab        spine floor                                                    [spine]

   Output schemas (inherited from spine — silent)
     Decision schema   adaptive: Verdict · Why (+ Risks/Conditions)   [spine]
     Confidence vocab  [VERIFIED] / [UNVERIFIED] / [NEEDS-RESEARCH]    [spine]
     Review schema     🔴 Blockers · 🟡 Friction · 🟢 Wins · ❓ · 🚏    [spine]
     Verdict vocab     Launch / Adjust / Hold                          [derived ← domain]
   ```

   Show only rows that apply (e.g. the schema rows for claimed categories only; the
   `Reference impl` row only if one exists). Every `[derived]` row is editable in one
   line — this is what replaces the ~5 interview turns those fields used to cost.
2. **Ask:** *"Look right? Type `go` to generate, or `edit <field>` to change any row
   (e.g. `edit user`, `edit out-of-scope`, `edit verdict-vocab`, `edit pressure-test`)."*
   On any `edit <field>`, capture the new value with `origin: typed` (user-authored is
   authoritative — it overrides the derived value), re-show the summary, loop until
   `go`. For `edit verdict-vocab`, also set `decision_support`'s `schema_origin:
   override`. A deeper schema-shape reshape is an expert move — honor it via the
   Q5a–Q5h override menus only if explicitly asked.
3. **On `go`, produce the file set** (do NOT write to disk yet):
   - **Read the spine first.** Load `domain-experts/spine/SPINE.md` and follow its
     "Composition rules". The agent file is *compiled* = template delta + spine
     fragments. For every `{{spine:<name>}}` marker in the template, inject the
     matching fragment, wrapping each injected region in the output with
     `<!-- BEGIN SPINE (generated — do not edit) -->` … `<!-- END SPINE -->`. Fill
     the fragment placeholders that carry delta values (`{{slug}}` in
     `memory_mechanics`; `{{primary_language}}`/`{{other_language}}` in
     `bilingual_mechanics`; `{{verdict_vocab}}` in `schema_decision_support` ← the
     Phase-5 derived words / Phase-9 override / fallback `Go / Go-with-conditions /
     No-Go`). Inject a `schema_*` fragment for every category claimed
     in Phase 4 whose `schema_origin` is `spine`; for any `schema_origin: override`,
     render that one section from the captured override instead. Emit the
     `anti_fabrication_floor` fragment always; emit the extra "Beyond the floor…"
     line only when `anti_fabrication_rule` ≠ the sentinel `floor`.
   - `agents/<slug>.md` — agent definition (use `references/agent-template.md`)
   - `examples/<slug>-starter-prompts.yaml` — 5–12 starter prompts (1–2 per claimed category + 2–3 refusal tests)
   - **If `kb_categories` ≠ `none`, build the KB scaffold:**
     - `agents/<slug>-knowledge/INDEX.md` — render `templates/kb/INDEX.md.tmpl`
       with `{{agent_slug}}`, `{{display_name}}`, `{{created_at}}`, and the
       resolved `{{categories}}` list. Initialize every `seed_counts[<cat>]` to `0`.
     - `agents/<slug>-knowledge/README.md` — brief human-readable orientation
       (one paragraph + "see INDEX.md for the manifest").
     - For each picked category, create the folder `agents/<slug>-knowledge/<cat>/`.
     - For each picked category that has a matching template under
       `templates/kb/<cat>/*.md.tmpl`, render every template into the folder
       (substituting `{{agent_slug}}`, `{{display_name}}`, `{{created_at}}`).
       Currently shipped templates:
       ```
       templates/kb/cultural-context/glossary.md.tmpl
       templates/kb/regulations/overview.md.tmpl
       ```
     - Categories without a shipped template (`frameworks`, `market-data`,
       `vendor-playbooks`, `experience`) get the folder only — no stub file.
   - **If `persona_kind` ≠ `abstract`, emit the persona artifacts (Phase 1.5):**
     - `agents/<slug>-knowledge/persona/<figure-slug>-profile.md` — the cited
       persona profile from Step D (signature frameworks · core concepts &
       vocabulary · communication style · recurring stances · scope edges — each
       line with a source). This `persona/` folder is owned by Phase 1.5 and is
       **not** added to `categories:` or the Q6 list.
     - Include the `persona:` frontmatter block and the `# Who you are` homage
       paragraph from the template. Render the homage contract **verbatim** — do
       not soften or drop the "one line you never cross" sentence.
   - Emit `name_ar:`, `categories:`, and `spine_version:` in frontmatter per
     `domain-experts/CONTRACT.md`. `categories` = the exact canonical slugs picked in
     Phase 4 (a missing/wrong category silently drops a skill from the hub).
     `spine_version` = the `spine_version` from the spine's frontmatter you just
     read — it records which spine this agent was compiled against, so refit can flag
     it when the spine advances.
4. **Show the generated files inline.** For KB stubs, show the rendered
   path tree; show the full body of `INDEX.md` and any seed stubs.
5. **Validate `INDEX.md` before save.** Parse its frontmatter as YAML;
   if parsing fails, abort and surface the error — do not write a broken
   manifest the hub can't read.
6. **Ask:** *"Save these files? Or say `edit X` first."*
7. **On `save`, write to disk.**

#### Handoff — register in the hub

The agent file is the source of truth. To put this expert in the OneStudio
hub, follow `domain-experts/PLAYBOOK.md`. One `register_my_venture` call
with `expert_spec` (the raw file texts) works for both a new venture and a
pre-existing stub — idempotent, no admin tools, no hand-transcription.

## Refit mode — uplevel an existing agent

When the user picks `refit` in Phase 0, follow these steps. The goal is to migrate an existing agent to fit framework practice and produce all 3 framework files (agent definition + KB scaffold + starter prompts).

### Step R1 — Locate the agent

**Q-R1**

Where's the agent? You have two options:

```
path     — give me the full path to the .md file
slug     — give me just the slug, I'll search common locations
```

→ Type a path or a slug.

If slug, search in this order (first match wins; if multiple, list and ask):

```
1. <cwd>/.claude/agents/<slug>.md                                    # project override
2. <cwd>/agents/<slug>.md                                             # local-build
3. ~/.claude/agents/<slug>.md                                         # user-scoped agent
4. ~/.claude/plugins/cache/*/<slug>/*/agents/<slug>.md                # installed plugin (slug = plugin name)
5. ~/.claude/plugins/cache/*/*/*/agents/<slug>.md                     # installed plugin (slug ≠ plugin name)
6. ~/.claude/plugins/marketplaces/*/plugins/<slug>/agents/<slug>.md   # marketplace source, multi-plugin
7. ~/.claude/plugins/marketplaces/*/agents/<slug>.md                   # marketplace source, single-plugin
```

Cache paths are 4 levels deep: `<marketplace>/<plugin>/<version>/agents/`. The version dir is dynamic per install — always glob with `*`.

Capture: `existing_path`, `existing_content` (full file text).

Also probe for sibling artifacts (used in audit):

```
  agents/<slug>-knowledge/        →  capture exists / not exists
  examples/<slug>-starter-prompts.yaml   →  capture exists / not exists
```

### Step R2 — Run the audit

Read the file. Parse YAML frontmatter and body. For each of these 10 dimensions, classify:

- ✓ **aligned** — present and matches framework
- ⚠ **partial** — present but doesn't match the recommended pattern
- ✗ **missing** — not declared

Dimensions:

```
 1. Identity            slug · display_name · bilingual display name (frontmatter)
 2. Domain              one-liner · geo + language scope
 3. Primary user        role · context · example question
 4. Categories          declared canonical categories (decision_support, etc.)
 5. Output schemas      verdict vocab · response sections · confidence vocab · review schema · etc.
 6. Knowledge           KB structure · live source · memory scope
 7. Hard rules          out of scope · anti-fabrication
 8. Behavior            pressure-test default
 9. Tools / model       frontmatter tools · model · memory: scope
10. Domain-vs-project   framing leads with a domain (not a product) ·
                        Reference implementation framed as one example ·
                        Comparable peers section listed ·
                        no code-level coupling in body
+ KB scaffold           does agents/<slug>-knowledge/ exist
+ Starter prompts       does examples/<slug>-starter-prompts.yaml exist
```

**Dimension 10 — auto-checks (regex / structural):**

Run all of these against the file. Any flag → mark dimension 10 as ⚠ or ✗.

```
A. Description leads with a product
   regex on `description:` line — flag if matches:
     /\bfor [A-Z][A-Za-z0-9 ]+\b/         e.g. "for Member Plus"
     /\b[A-Z][A-Za-z0-9]+ (PM|product manager|expert)\b/  e.g. "WalletPlus expert"
   → ✗ if leads-with-product detected.

B. Persona subtitle binds identity to a venture
   scan for "Operating Persona" / "Project Persona" / "<Venture> Persona"
   in the first 30 lines of the body.
   → ⚠ "subtitle couples identity to one venture; drop or rephrase."

C. Code-level coupling in body
   regex flags (count any 3+ matches as ✗, 1–2 as ⚠):
     - File paths:        /\bapp\/|backend\/|frontend\/|src\/[A-Za-z]/
     - Class names:       /\b[A-Z][a-zA-Z]+(Service|Controller|Repository|Provider|Interface)\b/
     - Commit hashes:     /\b[0-9a-f]{7,40}\b/
     - ORM model refs:    /\bModel:|Migration:|Schema:.*\b/i
   → ⚠/✗ "agent body references a specific codebase; abstract to category-level
     terms or move to a separate ## Reference implementation section."

D. Missing comparable peers
   scan for an `## Comparable peers` (or `## Comparables` / `## Category benchmarks`)
   section in the body.
   → ✗ if absent. *Strongest single signal that the agent is product-coupled.*

E. Missing reference implementation framing
   if a venture name appears in description AND there's no `## Reference implementation`
   section, the venture IS the agent's identity → ⚠.

F. Multi-purpose role
   if the body has a "two layers" / "two jobs" structure where one job is
   domain-expert and the other is "code reviewer" / "codebase auditor" /
   "implementation auditor" → ⚠ "split into two agents; this skill is scoped
   to domain experts only."
```

If the agent has zero issues across A–F: ✓ aligned. Otherwise enumerate findings in the audit report (see format below) so the user knows exactly which lines triggered each flag.

**Audit report format:**

```
**Audit for <slug>** (path: <existing_path>)

✓ aligned (N)        ⚠ partial (M)        ✗ missing (K)

──────────────────────────────────────────────
1. Identity
   ✓ slug + display_name OK
   ⚠ display_name_ar missing (body uses Arabic)

2. Domain
   ✓ one-liner: "<excerpt>"
   ⚠ language handling not declared explicitly

3. Primary user
   ✗ no "Who you serve" section
   → Recommend: add user role + example question

4. Categories
   ✓ decision_support detected (3-block schema present)
   ✗ no other categories declared
   → Recommend: declare additional categories or confirm decision-only scope

5. Output schemas
   ⚠ decision uses 3-block (good); confidence vocab inconsistent
   → Recommend: standardize to three-state tags

6. Knowledge
   ✗ no KB structure
   ✗ no memory declared
   → Recommend: add memory: project + KB scaffold dir

7. Hard rules
   ⚠ out-of-scope present in body, not formalized
   ✗ no explicit anti-fabrication rule
   → Recommend: add hybrid anti-fab rule

8. Behavior
   ✓ "challenge weak ideas" rule present

9. Tools / model
   ✓ tools list OK
   ⚠ no `memory:` field — recommend adding `memory: project`

10. Domain-vs-project framing
    ⚠ description leads with "for Member Plus" — couples agent to one venture
    ✗ no `## Comparable peers` section — agent has no category to reason against
    ⚠ body references specific class `WhatsAppMessageService.php:42`
    → Recommend: reframe description domain-first; add Reference implementation
      + Comparable peers sections; abstract code-level references to category
      terms.

──────────────────────────────────────────────

Sibling files:
   ✗ KB scaffold missing       → will create agents/<slug>-knowledge/
   ✗ Starter prompts missing   → will generate from claimed categories
```

### Step R3 — Walk through changes one by one

After the audit, walk the user through each recommended change INDIVIDUALLY. Same one-question-per-turn pattern as create mode. Same `default-with-WHY` template. Same single-keystroke acceptance.

**For each recommended change in the audit** (in order: dimensions 1–9, then sibling files), ask ONE question:

```
**Change <N> of <total>: <short title>**

Current state in the agent:
  <excerpt from the existing file, OR "not declared">

**✨ Default — <recommended new value>**

```
<aligned shape — code block>
```

*<one-line why this is recommended FOR THIS AGENT, not generic>*

**Override:**

```
<keyword>  — <short alt>
skip       — leave the agent's current state alone
```

→ Type `default`, an override keyword, or `skip`.
```

Behavioral rules during R3:

- **One change per turn.** Wait for the user's answer. Then move to the next change.
- **Show progress.** After each answer, briefly: *"Got it — change N: <decision>. Next…"*
- **Tailor the WHY to this agent.** Don't use generic boilerplate. The WHY should reference what the agent already does (e.g., *"Your agent already deflects out-of-scope politely — declaring `pressure_test_default = wait-until-asked` formalizes the current behavior"*).
- **Skip is a real option.** If the user types `skip`, that change is dropped. The existing value stays.
- **Don't bulk-accept by default.** No "type `all` to accept everything" — every change earns its keystroke.

After ALL changes processed, show a compact summary on one screen:

```
**Summary of changes** (X accepted · Y skipped)

✓ Change 1 — Add "Who you serve" section          → accepted (default: VB C-level team)
✓ Change 2 — Declare canonical categories          → accepted (default: reference_lookup, educational_explainer)
✗ Change 3 — Add memory: project                   → skipped
✓ Change 4 — Formalize confidence vocab            → accepted (override: existing five-state — no change)
...
```

Then ask:

```
Type `go` to generate the rewrite, or `back <N>` to revisit one change.
```

### Step R4 — Generate the rewrite (3 files)

Produce all 3 framework outputs, even if some already exist:

**File 1 — agent definition** *(overwrite)*
- Use `references/agent-template.md`.
- Merge: existing aligned values + accepted changes from R3 + new values from R4.
- Preserve any custom body content from the existing agent that doesn't map to a framework section by appending under `## Custom additions` near the end of the file. Don't silently drop content.

**File 2 — KB scaffold** *(create only if missing)*
- If `agents/<slug>-knowledge/` doesn't exist, generate `README.md` + 5 subdirectories (`regulations/`, `frameworks/`, `market-data/`, `cultural-context/`, `vendor-playbooks/`) — same structure as create mode.
- If it already exists, leave the existing structure alone.

**File 3 — starter prompts** *(create or extend)*
- If `examples/<slug>-starter-prompts.yaml` doesn't exist, generate from claimed categories: 1–2 prompts per category + 2–3 refusal tests.
- If it exists, MERGE: keep existing prompts (they are real-usage gold), add prompts only for categories not yet covered. Mark any new prompts with `# generated by domain-creator refit` comment.

### Step R5 — Show + save

Show all 3 files inline in this order:

1. Agent definition (the overwrite — most important to review)
2. KB scaffold README (if newly created)
3. Starter prompts file (full content if newly created; just the diff if extended)

Show a one-line summary diff per file:

```
agents/<slug>.md                            ← overwrite (N lines, M sections changed)
agents/<slug>-knowledge/README.md           ← create (new)
examples/<slug>-starter-prompts.yaml        ← extended (+K new prompts)
```

Ask:

```
Save options:
  save        — write all changes to disk
  save-as     — save the agent .md to a new path (specify); KB + prompts go to default
  edit X      — edit something first
  cancel      — discard the rewrite
```

→ Type one option.

On `save`, write all 3 files. The agent .md goes to `existing_path` (overwrite). KB and prompts go to their conventional paths relative to the agent's parent dir.

### Refit-specific anti-patterns

- **Don't silently drop existing content.** If the original agent has custom sections that don't map to the framework, append under `## Custom additions` — don't lose them.
- **Don't recreate KB if it already exists.** The user may have populated it. Refit only ADDS the scaffold if missing; never overwrites existing KB files.
- **Don't overwrite an existing prompts file blindly.** Real-usage prompts are gold. Merge, don't replace.
- **Don't pretend the audit is complete when parsing failed.** If the existing agent's structure is ambiguous (e.g., no headers at all), surface that explicitly: "I couldn't reliably detect X — treating as missing. Confirm or override."
- **Don't paper over project-coupling.** If dimension 10 fires hard (multiple code-level references, "Operating Persona" subtitle, missing Comparables, lead-with-product description), the agent is structurally a project agent — refit alone won't fix it. Tell the user: "This needs a substantive reframe, not a patch. Re-answer the Phase 2 domain-framing screen (parts 1–5: domain sentence + reference implementation + comparable peers) — I'll regenerate the body around the new framing instead of patching the old one."

---

## Pattern library (reference)

When a user picks an override or `custom`, these are the empirical patterns observed in production. Described by structural shape only.

| Pattern | Shape |
|---|---|
| 5-part decision | Decision · Why · Risks · Alternative · Impact |
| 7-step advisory | Clarification · Options · Trade-offs · Implications · Risks · Recommendation · Follow-ups |
| 3-block decision | Bottom-line · Why · Action |
| BLUF + 5 sections | Bottom line · Context · Analysis · Trade-offs · Next steps · Open questions |
| 8-section CI report | Executive Summary · Mode/Date/Confidence · [domain sections] · Unknowns |
| Severity-marker review | 🔴 Blockers · 🟡 Friction · 🟢 Wins · ❓ Open questions · 🚏 Routed |
| Verdict + conditional fields | Verdict + Confirm-Before-Ship / Reframed-Requirement / Questions-Before-Build |
| 3-tier competitor | Direct · Indirect · Substitute |
| 5-part educational | Definition · Why-matters · Example · Mistake · Application |
| 6-part handoff brief | Question · Receiver-context · Constraints · NOT-to-prescribe · Good-shape · Open-questions |
| 3-state confidence | `[VERIFIED]` · `[UNVERIFIED]` · `[NEEDS-RESEARCH]` |
| 5-state confidence | `confirmed` · `reported` · `estimated` · `uncertain` · `not knowable` |
| Source-tier labels | `Tier 1 (official)` · `Tier 2 (analysis)` · `Tier 3 (synthesis)` |
| Experience-rooted vocab | `from direct experience` · `from readings` · `from general context` · `from official source` |
| Two-source rule | Every empirical claim needs ≥2 independent credible sources |

## Output assembly

Both modes produce the same file set using the same templates — only the destination paths and overwrite behavior differ.

| File | Create mode destination | Refit mode destination |
|---|---|---|
| `<slug>.md` | `agents/<slug>.md` (new) | `<existing_path>` (overwrite) |
| `<slug>-knowledge/INDEX.md` | `agents/<slug>-knowledge/INDEX.md` (new) | same path (create only if missing — `domain-capture` then maintains it) |
| `<slug>-knowledge/README.md` | `agents/<slug>-knowledge/README.md` (new) | same path next to existing agent (create only if missing) |
| `<slug>-knowledge/<cat>/<stub>.md` | seed-stub per category that has a template under `templates/kb/<cat>/` | same path (create only if missing) |
| `<slug>-starter-prompts.yaml` | `examples/<slug>-starter-prompts.yaml` (new) | same path (merge if exists) |

Read `references/agent-template.md` AND `domain-experts/spine/SPINE.md` once before
generating. The agent file is **compiled** from two layers: the template carries the
**delta** (this agent's identity, domain, peers, user, out-of-scope, KB, persona) and
`{{spine:<name>}}` references; the spine carries the **invariant** prose every agent
shares (operating principles, anti-fabrication floor, citation discipline,
peers/reference framing, memory + bilingual mechanics, persona tribute contract, and
the schema catalog). Fill template placeholders from captured answers; resolve
`{{spine:*}}` markers per the spine's "Composition rules". Stamp the spine's
`spine_version` into the agent frontmatter.

Why this split: the shared rules live in **one** file. Fix the spine once and every
agent picks up the fix on its next recompile — no drift across the portfolio's many
agents. (Recompiling existing agents onto a newer spine is a refit concern, out of
scope for create mode.)

For sections that depend on Phase 4 choices (e.g., the agent only includes a "Decision schema" section if it claimed `decision_support`), conditionally include or omit those sections.

For starter prompts in `examples/<slug>-starter-prompts.yaml`, generate 5–12 prompts: 1–2 per claimed canonical category, plus 2–3 adversarial prompts that test refusal rules. Format:

```yaml
slug: <slug>
prompts:
  - id: <category>-001
    category: <canonical_id>
    consumer: for_human    # or for_agent
    text: |
      <a realistic prompt the user would bring>
  - id: refusal-001
    category: refusal_test
    consumer: for_human
    expects_refusal: true
    text: |
      <a prompt that should be refused per the agent's hard rules>
    notes: |
      <why this should be refused>
```

### Persona starter prompts *(when `persona_kind` is not `abstract`)*

Add **two persona tests** to `examples/<slug>-starter-prompts.yaml`:

```yaml
  - id: persona-fidelity-001
    category: persona_fidelity
    consumer: for_human
    text: |
      <a NEW in-domain question the figure never addressed — checks the agent
       reasons in their voice and school without breaking character>
  - id: refusal-persona-001
    category: refusal_test
    consumer: for_human
    expects_refusal: true
    text: |
      Give me the exact words <figure> used about <topic> in their book/talk.
    notes: |
      Baits a fabricated quote. The agent must decline to invent a specific
      quote/stat/date and present it as the figure's actual record — homage,
      not impersonation-for-deception (the "one line you never cross").
```

## Anti-patterns

- **Ask only what determines quality and can't be inferred.** A field earns an
  interview turn only when its answer (a) varies meaningfully across agents AND (b) the
  system can't infer it well. Everything else is **derived** (and surfaced in the Phase
  9 review for one-line correction) or **inherited from the spine** (silent). The only
  genuinely asked turns are: **domain framing** (Phase 2), **categories** (Phase 4), and
  the **persona pick** (Phase 2.5). Identity, primary user, KB categories, out-of-scope,
  live-source, memory scope, pressure-test posture, and all output schemas are derived
  or spine — never blank questions. Target: **~2–3 forced turns + one consolidated Phase
  9 review**, not a 10-question march.
- **Don't take a PRD's product name as the domain.** A PRD describes one product; the agent's domain is the wider *category* that product lives in. The product is always the Reference Implementation, never the agent's identity. The auto-checks in Phase 0.5 enforce this — don't bypass them.
- **Don't reference source agents by name.** Patterns are named by shape, not author.
- **Don't force defaults that don't fit.** Defaults are recommended, not imposed.
- **Don't write code or run benchmarks.** Evaluation is `domain-eval`'s job.
- **Don't impose canonical categories.** If the user's work doesn't map, capture as agent-specific.
- **Don't auto-save.** Wait for `save`.
- **Don't write long sentences.** One idea per sentence. Simple verbs.
