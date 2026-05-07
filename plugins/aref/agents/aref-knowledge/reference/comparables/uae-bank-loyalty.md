---
title: UAE Bank Loyalty Programmes
domain: comparable
tier: Indirect
geography: United Arab Emirates
last_updated: 2026-05-06
last_verified: 2026-05-06
research_method: WebSearch (Exa/Firecrawl MCPs not loaded in session — substitution noted)
sources:
  - mashreq.com — Mashreq Vantage / Salaam Rewards programme pages
  - bankfab.com — FAB Rewards programme structure
  - adcb.com — TouchPoints redemption FAQ + Corporate TouchPoints announcement (2024-11)
  - emiratesnbd.com / emirates.com — Emirates NBD × Skywards partnership
  - rakbank.ae — RAKBank World / Titanium / Elevate cashback cards
  - adib.ae — ADIB Etihad Guest Visa Infinite Covered Card (2026-01)
  - emirates.com/skywards — Skywards Mashreq partner page
  - ubyemaar.com / khaleejtimes.com — Emaar NBD co-brand context (cross-reference)
  - paisabazaar.ae / kredit.ae / cardsmatcher.com / khaleej2uae.com — UAE card aggregator data
  - mondaq.com / Pinsent Masons — CBUAE PSP regulatory framing
---

# UAE Bank Loyalty Programmes

## Tier classification: **Indirect**

Same loyalty outcome (consumer earns value on retail spend) via a structurally different model from this venture's merchant-funded B2B2C cashback infrastructure:

- **Funding source:** Bank P&L (interchange + acquirer share + bank-issued reward liability) — NOT merchant MDR-share.
- **Distribution:** Bank's own app + bank's own credit-card products. Closed to that bank's customers.
- **Anchor licensability:** **None of the programmes profiled here are licensable to a third-party enterprise anchor.** They are bank-proprietary.
- **Layer placement (per `knowledge/my-venture/docs/01-discovery/05-competitive-analysis.md` §5):** Layer D — bank loyalty + bank-channel global infra.

**Why none of these can be embedded inside an enterprise anchor's app:**
1. They are bank P&L instruments — pricing them outside the bank's own customer relationship breaks the interchange / cardholder economics.
2. They are competitive products to other banks — a developer or retailer anchor that embedded one bank's programme would lock out cardholders of every other bank.
3. The redemption catalogue is curated to bank-acquirer scope; cross-acquirer extensibility is not architected.

This is the gap the venture's merchant-funded model exploits at the anchor pitch.

---

## Programme snapshots

### Mashreq Vantage / Salaam Rewards

| Field | Value | Confidence | Source |
|---|---|---|---|
| Programme name | Mashreq Vantage (rebrand of Salaam Rewards) | `[VERIFIED]` | mashreq.com/Vantage page |
| Funding model | Bank P&L + interchange share — points earned per card transaction; **no merchant-MDR-share funding model disclosed** | `[INFERRED]` from card-issuer programme structure | mashreq.com FAQ, pointcheckout.com guide |
| Earn structure | Auto-enrolment for eligible Mashreq products; points on credit-card spend (debit-card earn discontinued from 2024-09-01) | `[VERIFIED]` | mashreq.com FAQ |
| Distribution | Mashreq Mobile App + 1,000+ partner merchants UAE | `[VERIFIED]` | mashreq.com Vantage page |
| Member count | Not publicly disclosed | `[NEEDS-RESEARCH]` | — |
| Co-brand layer | Emirates Skywards co-brand (Mashreq Skywards card) | `[VERIFIED]` | emirates.com/skywards/partners/mashreq-bank |
| **Licensable to enterprise anchor?** | **No** — Mashreq-proprietary instrument | — | — |

### FAB Rewards

| Field | Value | Confidence | Source |
|---|---|---|---|
| Funding model | Bank P&L + interchange — points on credit/debit card spend, current account balances, deposits, loans | `[INFERRED]` from programme construction | bankfab.com/rewards/program |
| Earn structure (post 2023-06-01 reset) | 0.5 FAB Rewards per AED 1 in low-interchange categories (supermarket, telecom, fuel, education, government, charities, transport, rental, insurance, fast food); up to 5 FAB Rewards per AED 1 on other UAE/abroad spend | `[VERIFIED]` | bankfab.com — FAB explicitly differentiates earn rates by **interchange category**, which confirms interchange-funded structure |
| Distribution | FAB app + FAB Rewards Shop + utility bill payments + cashback + Skywards / Etihad Guest / Shukrans conversion | `[VERIFIED]` | bankfab.com |
| Member count | Not publicly disclosed | `[NEEDS-RESEARCH]` | — |
| **Licensable to enterprise anchor?** | **No** — FAB-proprietary. Note: FAB is in Amos's MSA-stage pipeline as ANCHOR not competitor [`knowledge/reference/case-studies/amos/pipeline.md`] | — | — |

**Critical citation point:** FAB's published earn-rate differentiation explicitly maps to merchant interchange categories (low-interchange categories earn 0.5; high-interchange earn up to 5). This is direct evidence of an **interchange-funded** rather than merchant-MDR-funded model.

### ADCB TouchPoints

| Field | Value | Confidence | Source |
|---|---|---|---|
| Funding model | Bank P&L + interchange — points on debit/credit spend, savings, financing, investing, online banking activity | `[INFERRED]` | adcb.com/touchpoints |
| Earn structure | Multi-touchpoint earn (cards + accounts + loans + bill-pay + online banking) | `[VERIFIED]` | adcb.com FAQ |
| Distribution | ADCB app, dedicated TouchPoints app (Google Play), 660+ merchant partners accepting TouchPoints as **digital payment method** at POS — ADCB markets TouchPoints as a redemption mechanism, not as an anchor-licensable platform | `[VERIFIED]` | adcb.com/news/2024/november/corporate-touchpoints-credit-card |
| Co-brand layer | Emirates Skywards co-brand | `[VERIFIED]` | emirates.com/skywards/partners/adcb |
| Member count | Not publicly disclosed | `[NEEDS-RESEARCH]` | — |
| Award context | "Award winning loyalty programme" per ADCB marketing | `[UNVERIFIED]` (single source — bank's own marketing) | adcb.com |
| **Licensable to enterprise anchor?** | **No** — ADCB-proprietary; the 660+ "merchant partner" network is a redemption acceptance footprint, not an anchor-licensable B2B2C infrastructure. Note: ADCB is in Amos's Advanced pipeline [`knowledge/reference/case-studies/amos/pipeline.md`] | — | — |

### Emirates NBD Skywards / DubaiFirst

| Field | Value | Confidence | Source |
|---|---|---|---|
| Programme structure | Emirates NBD acts as a **co-brand card issuer** for Emirates Skywards (the airline's loyalty programme); not a standalone bank loyalty programme of equivalent scale | `[VERIFIED]` | emirates.com — "Emirates Skywards renews partnership with Emirates NBD" |
| Funding model | Bank P&L + interchange share + airline points-purchase fee paid to Emirates Skywards | `[INFERRED]` | Standard airline co-brand card structure |
| Earn structure | Up to 2 Skywards Miles per USD 1; Silver Tier status on Infinite card; partner-spend acceleration (Dubai Mall, Skywards Miles Mall, Skywards Everyday, Skywards Hotels) | `[VERIFIED]` | emiratesnbd.com/cards/skywards |
| DubaiFirst | DubaiFirst was Emirates NBD's premium credit-card sub-brand; no current 2026 standalone DubaiFirst loyalty programme surfaced in search | `[NEEDS-RESEARCH]` | — |
| **Licensable to enterprise anchor?** | **No** — Emirates Skywards is the licensable layer (airline-owned), and it is already exclusively co-branded into Emirates NBD on the bank side | — | — |

### RAKBank Rewards

| Field | Value | Confidence | Source |
|---|---|---|---|
| Funding model | Bank P&L + interchange — direct cashback (not points-based) on category-tagged spend | `[INFERRED]` | rakbank.ae/credit-cards |
| Flagship earn structure | RAKBank World Card: 10% cashback on travel, supermarket, dining (with min monthly spend AED 10K, salary AED 20K+); 1% other retail; 3% e-wallet (Apple Pay / Samsung Pay / Google Pay) | `[VERIFIED]` | rakbank.ae/world-credit-card |
| Tiered cashback caps | Elevate World Elite: Prime tier AED 50/cycle, Plus AED 100, Privilege AED 200 on streaming-platform spend | `[VERIFIED]` | rakbank.ae/elevate-partner-streaming-cashback |
| Member count | Not publicly disclosed | `[NEEDS-RESEARCH]` | — |
| **Licensable to enterprise anchor?** | **No** — RAKBank-proprietary | — | — |

### ADIB × Etihad Guest co-brand

| Field | Value | Confidence | Source |
|---|---|---|---|
| Latest launch | ADIB Etihad Guest Visa Infinite Covered Card — January 2026, in partnership with Etihad Guest + Visa; Gold / Platinum / Infinite variants; Sharia-compliant covered-card construct | `[VERIFIED]` | adib.ae/news/2026/jan; zawya.com (2 sources) |
| Funding model | Bank P&L (Sharia-compliant covered card) + interchange + airline points-purchase fee to Etihad Guest | `[INFERRED]` from co-brand card structure |
| Earn structure | Up to 2.2 Etihad Guest Miles per AED 4 local; up to 3 Miles per AED 4 equivalent international; up to 225,000 sign-up bonus miles | `[VERIFIED]` | adib.ae/news/2026/jan |
| Lifestyle layer | Unlimited airport lounge access; intercity airport transfers; golf benefits; companion ticket vouchers; Etihad Guest upgrade vouchers | `[VERIFIED]` | adib.ae |
| **Licensable to enterprise anchor?** | **No** — ADIB-proprietary on the issuer side; Etihad Guest licensable only to airlines / OTAs / select banks (already locked) | — | — |

---

## Why the venture's anchor pitch handles Layer D

When a bank-loyalty programme appears as the apparent competitor in an anchor's procurement comparison, the differentiation is structural, not feature-level:

1. **Funding asymmetry.** Layer D programmes are funded by interchange and the bank's own balance sheet. The venture is funded by merchants from their margin. **The anchor's customer earns regardless of which bank issued their card.** Cross-acquirer reach is the gap.
2. **Licensability.** None of these programmes can be embedded inside an enterprise anchor's app — they are bank-proprietary instruments. The venture's white-label B2B2C model **is** the embedded option.
3. **Anchor balance-sheet exposure.** A bank-loyalty programme costs the bank P&L. The venture costs the anchor zero balance-sheet exposure.
4. **Co-brand alternative.** The closest analogue — Entertainer × HSBC bank co-brand [`entertainer.md` — VERIFIED] — confirms banks pay third parties for loyalty merchant networks they cannot recreate internally. This is the precedent at bank-anchor pitches.

**Cross-reference:** `knowledge/my-venture/docs/01-discovery/05-competitive-analysis.md` §5 (Layer D) is the canonical write-up using these snapshots.

---

## Open questions / `[NEEDS-RESEARCH]`

- Member counts are not publicly disclosed for any of the six programmes profiled. Bank annual reports may have aggregate disclosures.
- ADCB TouchPoints "660+ merchant network" — is this an acceptance network at POS (likely) or an embedded B2B platform (unlikely)? Confirmation that it is acceptance-only would solidify the Layer D structural framing.
- DubaiFirst current 2026 status — appears to have been folded into Emirates NBD's broader card portfolio; confirm.
- Mashreq Salaam → Vantage rebrand timing.

Run `/aref-update "UAE bank loyalty member counts annual reports 2025-2026"` for the next refresh.

---

## Related files

- `knowledge/reference/comparables/ksa-bank-loyalty.md` — companion file for KSA programmes
- `knowledge/reference/comparables/entertainer.md` — for the bank co-brand precedent (HSBC × Entertainer)
- `knowledge/reference/comparables/collinson.md` — for institutional B2B2C bank-channel precedent
- `knowledge/reference/case-studies/amos/pipeline.md` — for FAB/ADCB position as Amos anchor pipeline (not competitor)
- `knowledge/my-venture/docs/01-discovery/05-competitive-analysis.md` §5
