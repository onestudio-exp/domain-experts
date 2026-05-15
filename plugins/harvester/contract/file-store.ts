import {
  mkdirSync, readdirSync, readFileSync, writeFileSync, existsSync,
} from "node:fs";
import { join } from "node:path";
import { randomUUID } from "node:crypto";
import type { Store, HarvesterItem, Followup, ListFilter } from "./store";
import { normalizeUrl } from "./url-normalize";

/**
 * Default store. Writes one JSON file per item under
 * <root>/.harvester/knowledge/<topic|_inbox>/items/<id>.json
 * Markdown index/digest are the agent's job (curate skill); FileStore
 * only owns the structured JSON of record so the contract is testable.
 */
export class FileStore implements Store {
  constructor(private root: string) {}

  private base() {
    return join(this.root, ".harvester", "knowledge");
  }
  private topicDir(topic: string | null) {
    return join(this.base(), topic && topic.trim() ? topic : "_inbox", "items");
  }

  async putItem(item: HarvesterItem): Promise<string> {
    const id = item.id || randomUUID();
    const rec: HarvesterItem = {
      ...item,
      id,
      url: normalizeUrl(item.url),
      updatedAt: new Date().toISOString(),
    };
    const dir = this.topicDir(rec.topic);
    mkdirSync(dir, { recursive: true });
    writeFileSync(join(dir, `${id}.json`), JSON.stringify(rec, null, 2));
    return id;
  }

  private *all(): Generator<HarvesterItem> {
    const base = this.base();
    if (!existsSync(base)) return;
    for (const topic of readdirSync(base)) {
      const itemsDir = join(base, topic, "items");
      if (!existsSync(itemsDir)) continue;
      for (const f of readdirSync(itemsDir)) {
        if (!f.endsWith(".json")) continue;
        const path = join(itemsDir, f);
        let parsed: HarvesterItem;
        try {
          parsed = JSON.parse(readFileSync(path, "utf8"));
        } catch {
          console.warn(`FileStore: skipping unreadable item file ${path}`);
          continue;
        }
        yield parsed;
      }
    }
  }

  async getItem(id: string): Promise<HarvesterItem | null> {
    for (const it of this.all()) if (it.id === id) return it;
    return null;
  }

  async listItems(filter?: ListFilter): Promise<HarvesterItem[]> {
    const out: HarvesterItem[] = [];
    for (const it of this.all()) {
      if (filter?.topic && it.topic !== filter.topic) continue;
      if (filter?.since && it.createdAt < filter.since) continue;
      out.push(it);
    }
    return out.sort((a, b) => a.createdAt.localeCompare(b.createdAt));
  }

  async findByUrl(url: string): Promise<HarvesterItem | null> {
    const norm = normalizeUrl(url);
    for (const it of this.all()) if (it.url === norm) return it;
    return null;
  }

  // Invariant: an item's topic only changes via putItem; setFollowup writes back to the item's current topic dir.
  async setFollowup(id: string, f: Followup): Promise<void> {
    const it = await this.getItem(id);
    if (!it) throw new Error(`unknown item ${id}`);
    it.followup = f;
    it.updatedAt = new Date().toISOString();
    const dir = this.topicDir(it.topic);
    writeFileSync(join(dir, `${id}.json`), JSON.stringify(it, null, 2));
  }

  async announce(_item: HarvesterItem): Promise<void> {
    // Default: no-op. Standalone users read the KB files directly.
  }
}
