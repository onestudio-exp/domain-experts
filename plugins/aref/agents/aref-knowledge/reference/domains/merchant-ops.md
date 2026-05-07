---
title: Merchant Network Operations
domain: merchant-ops
last_updated: 2026-04-29
---

# Merchant Network Operations

## Summary

A merchant-funded loyalty platform's economics live or die by the merchant network: density, margin matrix, onboarding velocity, and cost-to-serve. Below 100 merchants the program feels empty; above 500 merchants the operations team becomes the bottleneck unless the support model scales differently.

## Onboarding workflow

Standard contract → POS / payment integration → staff training → category / margin setup → soft-launch test transactions → go-live.

Best-in-class onboarding completes in 5 working days. Amos's standardised participation agreement + video training materials is the right shape for this.

## Margin matrix

| Category | Min margin floor | Notes |
|---|---|---|
| F&B (casual + fine dining) | 12% | Highest take, most volume |
| Wellness / fitness | 15% | Strong take, lower frequency |
| Travel & attractions | 8–12% | Operator may share with supply partner (e.g., PrioHub) |
| Electronics retail | 6% | Low margin, high TPV |
| Telecom top-up | 1–3% | High frequency, low take, useful for engagement |
| Groceries (non-promo) | 1–3% | Use carefully — may train low-rate behaviour |

Below 12% is acceptable for selected categories that drive frequency; below 6% rarely justifies the operational overhead.

## Cost-to-serve baseline

Industry: **1 CSM (Customer Success Manager) per 25 merchants** at AED 7K/mo loaded cost. At 200 merchants that is 6–8 CSMs ≈ AED 600K/yr before management overhead.

## AI displacement of merchant support

Most merchant queries are repetitive: PIN retrieval, transaction lookup, settlement status, cashback balance. A WhatsApp-fronted agentic AI (Amos's pattern) resolves 80%+ at fixed cost.

Amos numbers: ~$2K/mo at launch volumes vs ~$15K headcount equivalent at 200 merchants = **7x cost reduction**. Same architecture supports 500+ merchants on the same service tier — per-merchant cost continues to fall.

Security model required (Amos's four-layer):

1. Phone number whitelist
2. OTP verification per session
3. API session scoping (merchant only sees own data)
4. Prompt-level data isolation

## Settlement & reconciliation

- Cashback obligations accrue at transaction time.
- Operator settles with merchant on agreed cadence (T+30 typical).
- Reconciliation requires merchant TPV reports vs PSP transaction feed. Disputes are the #1 manual workload after PIN retrieval.

## Common mistakes

- Onboarding merchants whose unit economics don't justify it ("just to fill the map"). They become churn risks quickly.
- Failing to enforce minimum margin floor under sales pressure.
- Manual reconciliation without automation — scales linearly with merchant count.

## Related files

- [loyalty-economics.md](loyalty-economics.md) · [embedded-fintech.md](embedded-fintech.md) · `case-studies/amos/merchant-network.md` · `case-studies/amos/ai-support-economics.md`
