---
name: harvester-fetch
description: Use to fetch the content + metadata of a URL for triage. Cheap->expensive ladder; returns plain {content, title, sourceType, ogImageUrl}. Domain-agnostic -- no hub/DB coupling.
---

# Harvester URL Fetch

Fetches content and metadata for any submitted URL. Always pick the cheapest engine that returns usable content; escalate only on failure. The result -- a plain JSON struct -- is handed directly to `harvester-triage`.

## Output struct

```json
{
  "content":    "<full body text, markdown preferred; empty string if unavailable>",
  "title":      "<page title from og:title or <title>; null if unavailable>",
  "sourceType": "<youtube | linkedin | twitter | article | unknown>",
  "ogImageUrl": "<og:image URL; null if unavailable>"
}
```

`content_is_partial` should be set to `true` in the triage handoff when the body is truncated or blank.

## Fetch ladder -- pick the cheapest engine that works

```
1. Native HTTP fetch   (cheapest -- always try first)
   |
   +-- youtube   -> oEmbed JSON endpoint (no auth needed)
   +-- linkedin  -> HTTP OG scrape with browser UA (auth-gated posts return nothing)
   +-- article   -> HTTP OG scrape with browser UA
   |
   v  if ogImageUrl is null AND content is partial or empty
2. Jina Reader         curl https://r.jina.ai/<URL>
                       (good for paywalled articles and news; zero setup)
   |
   v  if blocked (403, captcha, or empty response)
3. Browser (rendered)  escalate to harvester-browser skill
                       (JS-rendered DOM; recovers embedded media URLs)
   |
   v  if still blocked (DataDome, Kasada, Cloudflare)
4. Browser + cookies   harvester-browser with injected domain cookies (last resort)
```

Levels 3 and 4 are handled by the `harvester-browser` skill. Call that skill if levels 1-2 fail.

## Per-platform notes

### YouTube -- reliable

Use the oEmbed endpoint:

```
https://www.youtube.com/oembed?url=<URL>&format=json
```

Returns `thumbnail_url` (typically `https://i.ytimg.com/vi/<ID>/hqdefault.jpg`). No API key, no auth. Always works for public videos.

Fallback: `https://img.youtube.com/vi/<ID>/maxresdefault.jpg` (may be missing if no custom thumbnail was uploaded).

Set `sourceType = "youtube"`.

### LinkedIn -- partial

Regular `linkedin.com/posts/...` URLs: HTTP OG scrape retrieves the post image from `media.licdn.com`. Works without auth.

ugcPost variants are auth-gated. The OG fetch falls back to a generic LinkedIn logo or returns nothing. There is no public bypass without a session cookie. Accept the fallback or let the card render with a placeholder.

Set `sourceType = "linkedin"`.

### X / Twitter -- needs rendering

Server-rendered X returns no `og:image` for unauthenticated requests. The oEmbed endpoint at `https://publish.twitter.com/oembed?url=...` returns author and text but no image URL.

Working path: render with the browser skill (patchright level). The embedded media appears as `pbs.twimg.com/media/<id>.jpg` in the JS-rendered DOM. That URL is publicly cacheable -- use it as `ogImageUrl`.

Tweets with no embedded media return no match. Accept the placeholder.

Set `sourceType = "twitter"`.

### DataDome and hard-paywalled sites (NYT, Bloomberg, Reuters)

These return 403 to every server-side fetch regardless of user-agent. Jina Reader also hits the same wall. Patchright alone triggers the DataDome captcha page.

Working path: escalate to `harvester-browser` with injected cookies from a real logged-in browser session. See that skill for the cookie extraction procedure.

Set `sourceType = "article"`.

### Regular articles -- usually works

HTTP fetch with a browser user-agent string (e.g. `Mozilla/5.0 ... Chrome/131.0.0.0`). Read `meta[property="og:image"]` for the cover image.

Do NOT use a bot-looking user-agent. Several publishers refuse non-browser UAs with 403.

Set `sourceType = "article"`.

## Sites that will not yield a cover image

- Hard-paywalled publishers without a matching logged-in session cookie
- X/Twitter posts that contain only text (no embedded media)
- LinkedIn ugcPost variants when not authenticated
- Some Substack private posts

For these, pass `ogImageUrl: null` to the triage step. The caller decides on a placeholder. Do not invent fake cover URLs.

## When to stop escalating

A failed fetch is acceptable -- the triage step can still work from `title` and the URL alone. Set `content = ""` and `content_is_partial = true` and proceed. Do not block the pipeline on a missing cover image.

## Adding new platform recipes

When you solve a new platform not listed above, add a subsection under "Per-platform notes" with:
- The working fetch method
- One line explaining why the cheap path failed
- The `sourceType` value to assign
