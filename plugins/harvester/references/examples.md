# Harvester  --  Worked Examples

These examples use placeholder values only. No real company or product names appear here.

---

## Example 1  --  Single-link intake, topic auto-detected

**Input:** User says: "Please ingest this for the `<Topic>` knowledge base: `https://example.com/article/new-regulation-2024`"

**Fetch:** `WebFetch` retrieves the article successfully.

**Triage output:**

```json
{
  "id": "hrv_01jt1a2b3c4d5e6f",
  "url": "https://example.com/article/new-regulation-2024",
  "urlOriginal": "https://example.com/article/new-regulation-2024",
  "status": "triaged",
  "topic": "<topic>",
  "title": "New 2024 Regulation Imposes Reporting Requirements on <Topic> Sector",
  "summary": "The article describes a 2024 regulatory update that introduces quarterly reporting obligations for organizations operating in the <Topic> sector. Compliance deadlines begin in Q3 2024. Non-compliance penalties are outlined in Section 4.",
  "whyItMatters": "This regulation directly affects <Topic> operations and requires action before the Q3 deadline; ignoring it exposes the team to financial penalties.",
  "nextMoves": [
    "Review Section 4 for penalty thresholds and confirm applicability",
    "Assign a compliance owner before the Q3 deadline",
    "Draft an internal checklist of required quarterly disclosures"
  ],
  "tags": ["regulation", "compliance", "reporting", "<topic>", "2024"],
  "routing": { "topic": "<topic>", "owner": "<Owner>" },
  "followup": null,
  "createdAt": "2024-06-01T09:00:00Z",
  "updatedAt": "2024-06-01T09:00:00Z"
}
```

**Filed at:** `.harvester/knowledge/<topic>/items/hrv_01jt1a2b3c4d5e6f.json`

---

## Example 2  --  Batch intake, two links

**Input:** User pastes two URLs with no further context.

```
https://example.com/report/market-sizing-q2
https://example.com/blog/competitor-launch
```

**Batch summary:**

| Title | Topic | Status | Next moves |
|---|---|---|---|
| Q2 Market Sizing Report for <Topic> | `<topic>` | triaged | 3 |
| Competitor Launches New Feature in <Topic> Space | `<topic>` | triaged | 2 |

**Triaged item (second link):**

```json
{
  "id": "hrv_02ab3c4d5e6f7g8h",
  "url": "https://example.com/blog/competitor-launch",
  "urlOriginal": "https://example.com/blog/competitor-launch",
  "status": "triaged",
  "topic": "<topic>",
  "title": "Competitor Launches New Feature in <Topic> Space",
  "summary": "A competing provider announced a new workflow automation feature targeting the same user segment as <Topic>. The feature is in public beta with general availability planned for Q4 2024.",
  "whyItMatters": "The competitor is moving into territory currently differentiated by <Topic>; the Q4 GA timeline gives the team one quarter to respond or counter-position.",
  "nextMoves": [
    "Test the competitor beta and document capability gaps",
    "Assess whether <Topic> roadmap already addresses this use case"
  ],
  "tags": ["competitor", "feature-launch", "automation", "<topic>", "q4"],
  "routing": { "topic": "<topic>", "owner": null },
  "followup": null,
  "createdAt": "2024-06-01T09:05:00Z",
  "updatedAt": "2024-06-01T09:05:00Z"
}
```

**Filed at:** `.harvester/knowledge/<topic>/items/hrv_02ab3c4d5e6f7g8h.json`

---

## Example 3  --  Digest refresh (no new links)

**Input:** User says: "Refresh the digest for `<topic>`."

**Process:** Mode 3  --  no fetch or triage. Harvester reads existing items from the store for topic `<topic>` and regenerates `digest.md`.

**Output digest (`.harvester/knowledge/<topic>/digest.md`):**

```
# <Topic> Knowledge Base Digest

Last updated: 2024-06-01
Items: 7

## Recent items

- **New 2024 Regulation Imposes Reporting Requirements on <Topic> Sector**
  Quarterly reporting obligations begin Q3 2024; compliance owner needed.

- **Q2 Market Sizing Report for <Topic>**
  Market grew 18% YoY; three underserved segments identified for targeting.

- **Competitor Launches New Feature in <Topic> Space**
  Competitor enters automation territory; Q4 GA gives one quarter to respond.

[... 4 more items ...]
```

Harvester confirms: "Digest refreshed. 7 items included. Filed at `.harvester/knowledge/<topic>/digest.md`."
