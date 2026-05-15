---
name: harvester-browser
description: Browser escalation for blocked/empty fetches during triage. Stealth chain (patchright -> nodriver -> camoufox), per-domain cookie store, persistent session. Generic fork scoped to read-for-triage.
---

# Harvester Browser (Read-for-Triage)

Escalation layer for URLs that the cheap fetch ladder cannot retrieve. Scope is strictly "fetch one page for triage" -- no multi-step automation, no form fills, no login flows.

Invoke this skill only when `harvester-fetch` has already attempted native HTTP and Jina Reader and both returned empty content or a bot-detection block.

## Engine decision tree

```
URL to fetch
   |
   v
Is it LinkedIn / Facebook / Instagram / TikTok?
   |
   +-- YES -> ensure domain cookies are fresh (see Cookie Store below)
   |          invoke browser router: camoufox + injected cookies
   |
   v
Is it a known protected site (Cloudflare, DataDome, Kasada)?
   |
   +-- YES -> invoke browser router; router auto-escalates:
   |          patchright -> nodriver -> camoufox
   |
   v
Is it a news site, paywall, or article?
   |
   +-- YES -> try Jina Reader first: curl https://r.jina.ai/URL
   |          escalate to browser router only if Jina returns empty or blocked
   |
   v
Default: Jina Reader, then browser router if blocked
```

## Anti-bot protection summary

| Site class              | Level   | Default engine | Notes                              |
| ----------------------- | ------- | -------------- | ---------------------------------- |
| LinkedIn                | HEAVY   | camoufox       | Requires `li_at` + supporting cookies |
| Facebook / Instagram    | HEAVY   | camoufox       | Login session required             |
| TikTok                  | HEAVY   | camoufox       | Aggressive fingerprint detection   |
| DataDome / Akamai       | HEAVY   | camoufox       | Fingerprint spoofing needed        |
| Twitter / X             | MEDIUM  | patchright     | JS render recovers embedded media  |
| Cloudflare-protected    | MEDIUM  | patchright     | CDP-level bypass                   |
| General news / articles | PAYWALL | jina           | Bypasses many soft paywalls        |
| GitHub / Reddit / SO    | NONE    | jina           | Public; no protection              |

## Stealth fallback chain

If an engine is blocked or returns empty content, escalate to the next level:

```
Level 1: patchright     (medium stealth; handles Cloudflare and Kasada)
           |
           v  if blocked
Level 2: nodriver       (medium-high; real Chrome without webdriver flag)
           |
           v  if blocked
Level 3: camoufox       (heavy -- C++ fingerprint spoofing; last resort)
```

Camoufox uses approximately 500 MB RAM per instance. Only invoke it when patchright and nodriver both fail, or when the site is on the HEAVY list.

## Cookie store

The browser skill maintains a per-domain cookie store. You log in once in a real Chrome session, extract all cookies for the domain, and store them. The stealth engine auto-injects stored cookies on every request to that domain.

Default location: `.harvester/cookies.json` (chmod 600, gitignored, never committed).

The location is configurable -- any path outside the repo root works. Treat the file as equivalent to a password store; never share or commit it.

To populate domain cookies: extract them from a logged-in Chrome session using the cookie extractor tool bundled with the browser skill. The extractor auto-scans Chrome profiles and picks the one with the most cookies for the target domain.

Cookies typically last 6-12 months depending on the site. If a site that previously worked starts returning logged-out pages, re-extract the cookies from Chrome.

## Scope constraints

This skill is read-only and single-step:
- Fetch the page at the given URL
- Return the rendered HTML or extracted text
- Do not fill forms, click buttons, follow redirects to login flows, or maintain state across multiple pages

If the target URL requires a multi-step login before it is readable, that is outside the scope of triage fetch. Accept the partial or empty result and pass `content_is_partial: true` to `harvester-triage`.

## Determining content quality

After the browser returns HTML, extract:
- `og:title` or `<title>` for `title`
- `og:image` for `ogImageUrl`
- Main body text (article tag, main tag, or largest text block) for `content`

If the rendered page is a bot-detection wall (CAPTCHA page, "verify you are human", blank body), treat the fetch as failed and return empty content.

## Handoff

Return the same struct as `harvester-fetch`:

```json
{
  "content":    "<extracted text>",
  "title":      "<title or null>",
  "sourceType": "<sourceType from calling skill>",
  "ogImageUrl": "<og:image URL or null>"
}
```

Pass this struct directly to `harvester-triage`.
