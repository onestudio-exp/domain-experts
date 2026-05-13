---
title: Membary Glossary
last_updated: 2026-05-14
---

# Membership Commerce — Glossary

## Model types

- **Paid membership** — recurring fee in exchange for ongoing benefits.
- **Free loyalty** — points/tier program with no recurring fee.
- **Coalition loyalty** — multi-merchant program (MAF SHARE, MENA telco programs).
- **Subscription commerce** — recurring delivery / curation product.

## Pricing

- **Anchor** — the price point the user mentally compares to.
- **Decoy** — a deliberately less-attractive tier to make the target tier look better.
- **Monthly vs annual** — annual-discount magnitude is the renewal-LTV lever.
- **Founding-member pricing** — early-cohort discount used to seed liquidity.

## Lifecycle stages

Discovery → Awareness → Signup → Activation → Onboarding → First-benefit-usage → Ongoing-usage → Benefit-reminders → Renewal → Failed-renewal → Cancellation → Win-back.

## Decision vocabulary

- **Go** — proceed; High confidence; no blockers triggered.
- **Go with conditions** — proceed contingent on named conditions being met; Medium confidence acceptable.
- **No-Go** — reject; reasons named explicitly.

## Source tags

- `[source: user msg]` — stated by user this conversation.
- `[source: Salla docs]` — official Salla documentation.
- `[source: verified behavior]` — observed in product / platform.
- `[source: cited example]` — real, named market example.
- `[source: prior decision in this thread]` — agreed earlier in conversation.

Without one of the above, demote to *What We Think*.

## Confidence levels

- **High** — most material points Confirmed; no Risk blockers.
- **Medium** — mix; Unknowns exist but not on critical path.
- **Low** — critical path depends on Unknowns / Risks.

## Blockers (override average score)

- **Legal / regulatory** — subscription, cancellation, refund, messaging risk unresolved.
- **Margin-destroying economics** — uncapped benefit cost erodes merchant profit.
- **Hard technical blocker** — no Salla API / webhook path; no workaround.
- **Default-Unknown on critical path** — decision depends on un-sourced Default-Unknown topic.

## Default-Unknown topics

Salla APIs / webhooks / scopes / rate-limits; native Salla features; Salla App Store competitor data; laws/regs/compliance; market numbers/conversion rates; profit margins; customer-behavior statistics; competitor pricing models; merchant willingness-to-pay; operational cost.

## Freshness windows

- ~30 days — active competitor pricing.
- ~90 days — Salla platform behavior, API changes.
- ~180 days — stable regulation references.

Mark every time-sensitive claim: `[as of 2026-Q2, re-verify in 90 days]`.

---

*Cite source + date per claim. See `sources.md` for the canonical source registry.*
