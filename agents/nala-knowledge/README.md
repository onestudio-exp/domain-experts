# Nala's Knowledge Base

Domain knowledge for Nala — VB expert for MENA/KSA focused Venture Builders.

This KB holds knowledge that is NOT in code or live external sources — i.e., reference material that lives outside any specific repo. Live sources (portfolio dashboards, decision logs, fund docs) are read by Nala at runtime via Read/Grep/Glob, not duplicated here.

## Structure

```
agents/nala-knowledge/
├── README.md                       ← this file
├── regulations/                    ← DIFC, ADGM, SAMA, ZATCA, MENA fund regs
├── frameworks/                     ← Lean Startup, JTBD, Atomic playbook, fund structures
├── market-data/                    ← MENA/KSA venture data, fund performance, exit comps
├── cultural-context/               ← GCC procurement, Hijri calendar, Arabic register
└── vendor-playbooks/               ← Atomic, Antler, Pioneer Square Labs, Rocket Internet, others
```

## How to add knowledge

Use the `domain-capture` skill — it validates new claims against Nala's current understanding, requires evidence, and writes captured knowledge to the right subdirectory with citation and timestamp.

## Anti-pattern (don't do this)

Don't dump live source content here. If your VB has portfolio dashboards or decision memos updated weekly, those are LIVE sources — Nala reads them at runtime. Putting snapshots here means they go stale within hours.

## File conventions

Each file should:
- Begin with `Last updated: YYYY-MM-DD`
- Include source / citation for every factual claim
- Be tagged by topic in its filename (e.g., `regulations/difc-fund-vehicle-types.md`)

## Initial state

Subdirectories are empty at creation. Populate via `domain-capture` as the team teaches Nala.
