---
title: Amos — Platform & Technology
domain: case-study
last_updated: 2026-04-29
sources:
  - AMOS Stakeholder Update March 2026 (section 05)
---

# Amos Tech Stack

## Core platform

- **Architecture:** multi-tenant SaaS with API-first design
- **Backend:** Spring Boot on Java 17
- **Database:** MySQL
- **Hosting (current):** AWS, with staging complete
- **Hosting (planned production):** Alibaba Cloud — to meet UAE data sovereignty requirements for banking clients (most immediately FAB Bank's PayIT)

## Why this stack matters

- **Java 17 + Spring Boot** = mature enterprise-grade backend that banks and developers' security teams accept in due diligence.
- **MySQL** = familiar, well-understood; not the highest-scale option but adequate for early-stage volumes.
- **AWS → Alibaba Cloud migration** = the structural compromise of MENA banking-grade SaaS: international cloud is preferred for tooling, in-region cloud is required for data sovereignty.

## Licensed AI Operations Layer

A licensed agentic AI platform deployed as Amos's primary merchant support channel — a **WhatsApp-based agent** that handles the full range of merchant queries:

- Transaction lookups
- PIN retrieval (the highest-volume support category)
- Cashback balances
- Settlement status
- General operational guidance

### Four-layer security model

Merchants authenticate before any commercial data is surfaced:

1. **Phone number whitelist**
2. **OTP verification** per session
3. **API session scoping** (merchant only sees own data)
4. **Prompt-level data isolation** in the AI agent

This stack meets the standard required to handle merchant financial information at scale.

## PrioHub integration architecture

The PrioHub merchant supply integration is built as a **standalone Progressive Web App** rather than embedded into the core platform. This is deliberate:

- The core platform is insulated if supply relationships change.
- PrioHub's fundamentally different booking, payment, and UX flow doesn't pollute the core.
- Variable pricing logic, cashback matrix, and reservation flows live in the PWA.

## Implications

- Multi-anchor multi-tenant boundary is the privacy contract — DAMAC's data not queryable by FAB Bank's stack.
- Banking anchors require in-region hosting — plan Alibaba Cloud migration before FAB Bank go-live.
- AI-first ops layer is the cost-to-serve disruption (see [ai-support-economics.md](ai-support-economics.md)).

## Related files

- [ai-support-economics.md](ai-support-economics.md) · [merchant-network.md](merchant-network.md) · `domains/embedded-fintech.md` · `regulatory/cbuae-svf.md`
