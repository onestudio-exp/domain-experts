/**
 * Sync URL normalization for dedupe. Domain-agnostic copy -- no studio refs.
 * Order: lowercase scheme+host -> strip tracking params -> sort params ->
 * drop trailing '/' and '#fragment' -> re-serialize. Unparseable -> input.
 */
const TRACKING = [
  /^utm_/i, /^ref$/i, /^ref_src$/i, /^ref_url$/i, /^fbclid$/i,
  /^gclid$/i, /^igshid$/i, /^mc_cid$/i, /^mc_eid$/i,
  /^__twitter_impression$/i, /^si$/i,
];

export function normalizeUrl(input: string): string {
  let u: URL;
  try {
    u = new URL(input);
  } catch {
    return input;
  }
  u.protocol = u.protocol.toLowerCase();
  u.hostname = u.hostname.toLowerCase();
  u.hash = "";
  const kept: [string, string][] = [];
  for (const [k, v] of u.searchParams.entries()) {
    if (!TRACKING.some((re) => re.test(k))) kept.push([k, v]);
  }
  kept.sort(([a], [b]) => a.localeCompare(b));
  u.search = "";
  for (const [k, v] of kept) u.searchParams.append(k, v);
  let out = u.toString();
  if (out.endsWith("/") && u.pathname !== "/") out = out.slice(0, -1);
  out = out.replace(/^(https?:\/\/[^/]+)\/$/, "$1");
  return out;
}
