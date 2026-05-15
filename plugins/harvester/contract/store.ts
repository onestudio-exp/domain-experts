/**
 * Harvester store contract. The only persistence seam.
 * Implemented by FileStore (default, ships here) and HubStore (in the hub app).
 * Domain-agnostic: no OneStudio concepts leak into these types.
 */

export type ItemStatus = "new" | "fetched" | "triaged" | "failed" | "archived";

export interface Followup {
  owner: string | null;
  status: "claimed" | "in-progress" | "completed" | "abandoned";
}

export interface HarvesterItem {
  /** Stable id (store assigns on putItem if empty). */
  id: string;
  /** Normalized URL -- also the dedupe key. */
  url: string;
  /** Raw URL exactly as submitted. */
  urlOriginal: string;
  status: ItemStatus;
  topic: string | null;
  title: string | null;
  summary: string | null;
  whyItMatters: string | null;
  nextMoves: string[];
  tags: string[];
  /** Routing suggestions from classify (generic, store interprets). */
  routing: { topic: string | null; owner: string | null };
  followup: Followup | null;
  createdAt: string; // ISO
  updatedAt: string; // ISO
}

export interface ListFilter {
  topic?: string;
  since?: string; // ISO
}

export interface Store {
  putItem(item: HarvesterItem): Promise<string>;
  getItem(id: string): Promise<HarvesterItem | null>;
  listItems(filter?: ListFilter): Promise<HarvesterItem[]>;
  findByUrl(normalizedUrl: string): Promise<HarvesterItem | null>;
  setFollowup(id: string, f: Followup): Promise<void>;
  /** Surface a new/updated item. Default impls may no-op. */
  announce(item: HarvesterItem): Promise<void>;
}

export function emptyItem(url: string, urlOriginal?: string): HarvesterItem {
  const now = new Date().toISOString();
  return {
    id: "",
    url,
    urlOriginal: urlOriginal ?? url,
    status: "new",
    topic: null,
    title: null,
    summary: null,
    whyItMatters: null,
    nextMoves: [],
    tags: [],
    routing: { topic: null, owner: null },
    followup: null,
    createdAt: now,
    updatedAt: now,
  };
}
