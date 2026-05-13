---
title: Rushd Knowledge Index
last_updated: 2026-05-14
---

# Rushd Knowledge Base Index

```
rushd-knowledge/
├── playbooks/          ← earn / burn / expiry / fraud / refund design
├── reference/
│   ├── regulatory/     ← KSA SAMA, ZATCA, PDPL applied to wallets
│   ├── frameworks/     ← wallet liability accounting, breakage, fraud vectors
│   └── comparables/    ← Rakuten, Honey, TopCashback, Bilt, Amos, MENA programs
├── decisions/
├── glossary.md
├── sources.md
└── INDEX.md
```

## `playbooks/`

| File | Purpose | Status |
|---|---|---|
| `playbooks/earn-rules.md` | Designing when cashback earns (placed / fulfilled / paid / delivered) | scaffold |
| `playbooks/burn-rules.md` | Designing when cashback burns (next order, eligible products, min cart) | scaffold |
| `playbooks/expiry-clawback.md` | Expiry windows; clawback on refund | scaffold |
| `playbooks/fraud-rules.md` | Per-account limits, velocity checks, multi-account detection | scaffold |
| `playbooks/refund-handling.md` | Partial refund / full refund / chargeback handling for earned cashback | scaffold |
| `playbooks/edge-case-walkthrough.md` | Systematic walk-through (partial refund, cross-currency, expired returns, account merging) | scaffold |

## `reference/regulatory/`

| File | Topic | Status |
|---|---|---|
| `reference/regulatory/ksa-sama-wallet.md` | KSA SAMA rules applicable to wallet-balance products | scaffold |
| `reference/regulatory/zatca-cashback.md` | ZATCA Phase 2 e-invoicing implications for cashback as a discount vs payment | scaffold |
| `reference/regulatory/pdpl-customer-balances.md` | KSA PDPL on customer-balance data residency, lawful basis | scaffold |

## `reference/frameworks/`

| File | Topic | Status |
|---|---|---|
| `reference/frameworks/wallet-liability.md` | Wallet liability accounting basics | scaffold |
| `reference/frameworks/breakage-modeling.md` | Breakage estimation and revenue recognition timing | scaffold |
| `reference/frameworks/fraud-vector-taxonomy.md` | Categorization of common cashback fraud vectors | scaffold |
| `reference/frameworks/mdr-cashback-margin-matrix.md` | MDR-vs-cashback margin matrix for merchants | scaffold |

## `reference/comparables/`

| File | Comparable | Tier |
|---|---|---|
| `reference/comparables/rakuten.md` | Rakuten Cashback | Indirect |
| `reference/comparables/honey-paypal.md` | Honey / PayPal | Indirect |
| `reference/comparables/topcashback.md` | TopCashback (UK) | Indirect |
| `reference/comparables/bilt-rewards.md` | Bilt Rewards | Indirect |
| `reference/comparables/amos.md` | Amos (UAE) | Direct (MENA peer) |
| `reference/comparables/mena-regional.md` | Bonat, MAF SHARE, e& Smiles, Careem Plus, stc Qitaf | Substitute |
| `reference/comparables/salla-cashback-apps.md` | Salla App Store cashback/wallet apps | Direct |

## `decisions/`

Plugin default empty.
