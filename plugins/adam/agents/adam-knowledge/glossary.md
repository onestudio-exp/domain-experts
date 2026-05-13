---
title: Adam Glossary
last_updated: 2026-05-14
---

# Competitive Intelligence — Glossary

## Modes

- **Mode A** — Idea Validation (no shipping product yet; validate the concept).
- **Mode B** — Competitor Discovery (given a product URL/name; map the landscape).
- **Mode C** — Competitor Monitoring (track moves of named competitors over time).

## Report structure (mandatory 8 sections)

1. Executive Summary (2-3 sentences)
2. Product or Idea Understanding (category, ICP, problem, pricing, features)
3. Competitor Landscape (Direct / Indirect / Substitute tables)
4. Comparison Matrix (feature × product grid)
5. Market Gaps and Opportunities (tied to findings from §3-4)
6. Risks and Threats (rated High / Medium / Low)
7. Recommendations (numbered; each links to a specific finding)
8. Confidence Level and Unknowns (overall confidence + explicit unknowns; empty = bug)

## Claim labels

- **`[CONFIRMED]`** — sourced from a document Adam retrieved; URL or doc traceable.
- **`[INFERRED]`** — reasoned from context; not directly sourced.

## Confidence levels

- **High** — most claims confirmed; sourcing thorough.
- **Medium** — mix; some inference; key unknowns flagged.
- **Low** — heavy inference; critical unknowns on the path.

**Drop rule:** if >30% of competitor data is `[INFERRED]`, drop confidence one level.

## Competitor tiers

- **Direct** — same core problem, similar audience, similar way; real head-to-head overlap.
- **Indirect** — similar problem via different model / workflow / category.
- **Substitute** — different category but can replace in practice (spreadsheets, manual work, bundled features).

A name appears in **exactly one tier**. The `validate-report.sh` hook enforces this.

## Customer Voice (Mode B requirement)

For each Direct competitor in Mode B reports: ≥3 verbatim customer quotes.

Allowed sources: **G2, Capterra, Trustpilot, Reddit, App Stores**.
Rejected sources: vendor testimonials, vendor case studies, marketing pages.

Quote mix: 1 praise, 1 complaint, 1 about depth/UX.

If recurring complaints surface across competitors → market-wide gap → cite in §5.
At least one §7 recommendation must anchor in a specific quote.

## Domain Awareness

Top-5 supported profiles: **SaaS, E-commerce, B2B Sales/GTM, HR & Talent, EdTech**. Anything else → **Custom Domain — \<name\>** with explicit assumptions + one-level confidence drop.

## Placeholders (Independence test)

Real product names belong only in `examples.md`, `reports/`, `.adam/knowledge/<product-slug>/`. In contract files (agent / templates / skills), use placeholders:

- `<Product>` — user's product
- `<Competitor>`, `<CompetitorA>`, `<CompetitorB>` — competitors
- `<region/segment>` — geography, vertical, audience
- `<YYYY-MM-DD>` — dates in templates

---

*See `sources.md` for the canonical source registry.*
