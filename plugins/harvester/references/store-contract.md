# Store Contract

This document is a prose mirror of `../contract/store.ts`. It describes the persistence seam that all Harvester logic must use. No Harvester code or agent prompt should read or write state except through these methods.

---

## Store methods

### `putItem(item: HarvesterItem): Promise<string>`

Persist a `HarvesterItem`. If `item.id` is empty, the store generates and assigns a stable ID. Returns the assigned ID. If an item with the same normalized URL already exists, this is an upsert  --  update in place, preserve `createdAt`.

### `getItem(id: string): Promise<HarvesterItem | null>`

Retrieve a single item by its stable ID. Returns `null` if not found.

### `listItems(filter?: ListFilter): Promise<HarvesterItem[]>`

Return all items matching the optional filter. `filter.topic` constrains to a single topic slug. `filter.since` (ISO timestamp) constrains to items with `updatedAt` at or after that time. Returns items in reverse-chronological order by `updatedAt`.

### `findByUrl(normalizedUrl: string): Promise<HarvesterItem | null>`

Look up an item by its normalized URL. This is the dedupe check  --  call before `putItem` to avoid creating duplicates. Returns `null` if no match exists.

### `setFollowup(id: string, f: Followup): Promise<void>`

Attach or replace the `followup` record on an existing item. Used to track ownership and progress on action items surfaced by triage.

### `announce(item: HarvesterItem): Promise<void>`

Notify any registered listeners that an item was created or updated. The default `FileStore` implementation is a no-op. Integrations (e.g., a hub app) override this to push notifications, post feed entries, etc.

---

## HarvesterItem fields

| Field | Type | Description |
|---|---|---|
| `id` | `string` | Stable unique identifier, assigned by the store on first write. |
| `url` | `string` | Normalized URL  --  the dedupe key. |
| `urlOriginal` | `string` | Raw URL exactly as submitted by the user. |
| `status` | `ItemStatus` | Processing state: `new`, `fetched`, `triaged`, `failed`, or `archived`. |
| `topic` | `string | null` | Topic slug for filing (e.g., `"climate-policy"`). `null` means inbox. |
| `title` | `string | null` | Concise factual title, <=12 words. Null until triage. |
| `summary` | `string | null` | 2-4 sentence plain-language summary. Null until triage. |
| `whyItMatters` | `string | null` | 1-3 sentences on relevance to this team. Null until triage. |
| `nextMoves` | `string[]` | Imperative action items from triage. Empty array until triage. |
| `tags` | `string[]` | Lowercase keyword tags. Empty array until triage. |
| `routing` | `{ topic: string | null; owner: string | null }` | Filing suggestion from classify step. |
| `followup` | `Followup | null` | Optional ownership/progress record. |
| `createdAt` | `string` | ISO timestamp, set on first write, never updated. |
| `updatedAt` | `string` | ISO timestamp, updated on every write. |

### Followup fields

| Field | Type | Description |
|---|---|---|
| `owner` | `string | null` | Handle or name of the person who claimed this item's action. |
| `status` | `string` | One of: `claimed`, `in-progress`, `completed`, `abandoned`. |

---

## File convention (FileStore default)

```
.harvester/
  knowledge/
    <topic>/
      items/
        <id>.json        -- one HarvesterItem per file
      index.json         -- array of item IDs, reverse-chronological
      digest.md          -- rolling human-readable summary, regenerated on curate
    _inbox/
      items/
        <id>.json        -- items whose topic is null
```

`<topic>` is the slugified `routing.topic` value (lowercase, hyphens, no spaces).

The `.harvester/` directory is gitignored and local to each workspace. It must never be committed.

---

## Dedupe key

The dedupe key is the **normalized URL** stored in `item.url`. Normalization is performed by `../contract/url-normalize.ts`. Two submissions with URLs that normalize to the same string are treated as the same item  --  `putItem` updates the existing record rather than creating a second one.

---

## announce() behavior

`announce()` is a hook for integrations. In the default `FileStore`, it is a no-op  --  calling it has no effect. Implementations that integrate with external systems (message queues, webhooks, feed databases) override this method to push the item outward. Harvester always calls `announce()` after a successful `putItem`; the store decides what to do with it.
