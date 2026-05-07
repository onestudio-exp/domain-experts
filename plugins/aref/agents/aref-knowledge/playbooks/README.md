---
title: Playbooks — reusable templates
last_updated: 2026-05-05
status: scaffold
---

# `playbooks/` — reusable, venture-agnostic templates

These are operational templates the user adapts for their own venture. They are independent of any single comparable and apply across most merchant-funded loyalty / embedded cashback ventures in MENA.

## Purpose

When the user faces an operational question like *"how do I onboard my first 10 merchants?"* or *"how do I structure the MDR conversation with a bank?"*, Aref pulls the relevant playbook here, applies it to the user's `my-venture/` context, and outputs a tailored answer.

## Files (planned)

| File | Topic | Trigger to write |
|---|---|---|
| `anchor-sales-playbook.md` | Discovery → MOU → MSA → integration → go-live for anchor enterprises | First anchor conversation |
| `merchant-onboarding-playbook.md` | Pipeline → KYC → contract → integration → activation for merchant network | First merchant signed |
| `mdr-design-framework.md` | How to set MDR, cashback rate, settlement timing, take rate per merchant tier | Pricing-design session |
| `regulatory-navigation.md` | Decision tree: do you need a licence? Operate via PSP? Engage which regulator? | Regulatory-strategy session |
| `cashback-economics.md` | Earn/burn ratios, breakage, liability, sensitivity tables | Unit-economics session |
| `cohort-retention-playbook.md` | How to instrument and read cohort retention from day-0 | Post-launch instrumentation |

## Status

All playbooks are SCAFFOLD until the user encounters a specific need. Aref builds each one on first encounter, using:
- The relevant `reference/frameworks/` material
- The relevant `reference/comparables/` data
- The user's `my-venture/` context

This avoids producing speculative playbook content the user may never use.
