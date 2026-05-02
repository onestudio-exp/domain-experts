#!/usr/bin/env python3
# Quick eval runner — companion to the domain-eval skill.
# Reads an agent .md + its starter prompts, invokes the agent via the
# Claude Agent SDK (CC auth, no API key), runs structural checks against
# the agent's declared rubric, classifies each prompt PASS/WEAK/FAIL.
#
# Usage:
#   uv run python scripts/eval_runner.py --slug nala --limit 3
#
# The SKILL.md at skills/domain-eval describes the same logic for in-session
# human-driven eval. This script is the automation companion.

from __future__ import annotations

import argparse
import asyncio
import re
import sys
import time
from pathlib import Path

import yaml
from claude_agent_sdk import (
    AssistantMessage,
    ClaudeAgentOptions,
    ResultMessage,
    TextBlock,
    query,
)

REPO = Path(__file__).resolve().parents[1]


def loud(msg: str) -> None:
    print(f"[eval] {msg}", flush=True)


def fatal(msg: str) -> "NoReturn":  # type: ignore[name-defined]
    print(f"[eval] FATAL: {msg}", file=sys.stderr, flush=True)
    sys.exit(1)


def load_agent(slug: str) -> tuple[Path, str, dict, str]:
    path = REPO / "agents" / f"{slug}.md"
    if not path.exists():
        fatal(f"agent not found: {path}")
    text = path.read_text()
    m = re.match(r"^---\n(.*?)\n---\n(.*)", text, re.DOTALL)
    if not m:
        fatal(f"agent {slug} has no YAML frontmatter")
    fm = yaml.safe_load(m.group(1))
    body = m.group(2).strip()
    return path, text, fm, body


def load_prompts(slug: str) -> list[dict]:
    path = REPO / "examples" / f"{slug}-starter-prompts.yaml"
    if not path.exists():
        fatal(f"prompts not found: {path}")
    data = yaml.safe_load(path.read_text())
    prompts = data.get("prompts") or []
    if not prompts:
        fatal(f"no prompts in {path}")
    return prompts


# Hardcoded rubric for Nala (matches her declared rules in agents/nala.md).
# Future iteration: parse declared rubric from the agent body. For this demo
# the rubric is explicit so checks are unambiguous.
NALA_RUBRIC = {
    "verdict_vocab": ["Invest", "Hold", "Pivot", "Kill"],
    "confidence_vocab": ["[VERIFIED]", "[UNVERIFIED]", "[NEEDS-RESEARCH]"],
    "response_sections_required": ["Verdict", "Why"],
    "review_sections": ["🔴", "🟡", "🟢", "❓", "🚏"],
    "competitor_tiers": ["Direct", "Indirect", "Substitute"],
    "refusal_signals": [
        "out of scope", "outside scope", "outside my scope",
        "defer to", "redirect to", "should consult", "I won't", "I can't",
        "not within my scope", "not in my scope", "this is for",
        "handoff brief", "handoff",
    ],
}


async def invoke_agent(system_prompt: str, prompt: str, model: str = "claude-opus-4-7") -> tuple[str, dict]:
    """Invoke an agent via the Claude Agent SDK with the agent's body as system prompt.

    Allowed tools: empty (we want pure text output for eval — no file reads
    that might pollute the response). The agent's tool list in production
    matters for actual use, but for eval we're testing reasoning + adherence
    to the schema, not tool usage.
    """
    options = ClaudeAgentOptions(
        model=model,
        allowed_tools=[],
        max_turns=1,
        system_prompt=system_prompt,
    )
    text_parts: list[str] = []
    usage = {}
    cost_usd = None
    started = time.monotonic()
    try:
        async for message in query(prompt=prompt, options=options):
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if isinstance(block, TextBlock):
                        text_parts.append(block.text)
            elif isinstance(message, ResultMessage):
                u = getattr(message, "usage", None) or {}
                usage = {
                    "input_tokens": int(u.get("input_tokens", 0) or 0),
                    "output_tokens": int(u.get("output_tokens", 0) or 0),
                }
                cost_usd = getattr(message, "total_cost_usd", None)
    except Exception as e:
        return "", {"error": f"{type(e).__name__}: {e}"}

    elapsed = time.monotonic() - started
    return "".join(text_parts), {
        **usage,
        "cost_usd": cost_usd,
        "elapsed_sec": round(elapsed, 1),
    }


def check_prompt(prompt: dict, response: str, rubric: dict) -> tuple[str, list[str], list[str]]:
    """Returns (verdict, passed_checks, failed_checks)."""
    category = prompt.get("category", "")
    expects_refusal = prompt.get("expects_refusal", False)
    passed: list[str] = []
    failed: list[str] = []

    if not response.strip():
        return "FAIL", [], ["empty response from agent"]

    text_lower = response.lower()

    if category == "decision_support":
        # Verdict vocab keyword present?
        verdict_hits = [v for v in rubric["verdict_vocab"] if v.lower() in text_lower]
        if verdict_hits:
            passed.append(f"verdict vocab present: {verdict_hits[0]}")
        else:
            failed.append(f"no verdict from {rubric['verdict_vocab']}")

        # Required adaptive sections (Verdict + Why)
        for section in rubric["response_sections_required"]:
            if section.lower() in text_lower:
                passed.append(f"{section} section present")
            else:
                failed.append(f"missing required section: {section}")

    elif category == "reference_lookup":
        # Confidence vocab tags present?
        conf_hits = [c for c in rubric["confidence_vocab"] if c in response]
        if conf_hits:
            passed.append(f"confidence vocab used: {len(conf_hits)} tags")
        else:
            failed.append("no confidence vocab tags")

        # Cited sources?
        if re.search(r"https?://|\bsource[s]?:|\[\d+\]|\b\d{4}\b", response, re.IGNORECASE):
            passed.append("citations present")
        else:
            failed.append("no citations / source references")

    elif category == "structured_review":
        for marker in rubric["review_sections"]:
            if marker in response:
                passed.append(f"review marker {marker} present")
            else:
                failed.append(f"missing review marker {marker}")

    elif category == "competitive_intelligence":
        tier_hits = [t for t in rubric["competitor_tiers"] if t in response]
        if len(tier_hits) >= 2:
            passed.append(f"competitor tiers used: {tier_hits}")
        else:
            failed.append("competitor tiers underused (need ≥2 distinct tiers)")

    elif category == "regulatory_compliance":
        if re.search(r"\barticle\b|\b\d{4}\b", response, re.IGNORECASE):
            passed.append("article/year reference present")
        else:
            failed.append("no article-level regulation citation")

    elif category == "handoff_partner":
        # Wafaa-style 6-part brief
        for part in ["question", "context", "constraint", "prescribe", "good", "open"]:
            if part in text_lower:
                passed.append(f"handoff part '{part}' present")
            else:
                failed.append(f"missing handoff part: {part}")

    elif category == "refusal_test":
        is_refusal = any(sig in text_lower for sig in rubric["refusal_signals"])
        if expects_refusal:
            if is_refusal:
                passed.append("refused as expected")
            else:
                failed.append("did NOT refuse — answered substantively (CRITICAL)")
        else:
            if is_refusal:
                failed.append("refused incorrectly — should have answered")
            else:
                passed.append("answered as expected (no refusal)")

    # Classify
    critical_fail = any("CRITICAL" in f for f in failed)
    if critical_fail:
        verdict = "FAIL"
    elif failed:
        verdict = "WEAK" if len(passed) > len(failed) else "FAIL"
    else:
        verdict = "PASS"
    return verdict, passed, failed


async def run_eval(slug: str, limit: int | None) -> int:
    path, _, fm, body = load_agent(slug)
    prompts = load_prompts(slug)
    if limit:
        prompts = prompts[:limit]

    # System prompt = the agent's body (without frontmatter).
    # SDK injects this so the agent behaves per its declaration.
    system_prompt = body
    model = fm.get("model", "claude-opus-4-7")
    if model == "opus":
        model = "claude-opus-4-7"
    elif model == "sonnet":
        model = "claude-sonnet-4-6"

    # Pick the right rubric. For now we have Nala only — extend as needed.
    rubric = NALA_RUBRIC if slug == "nala" else NALA_RUBRIC

    loud(f"agent: {slug} ({path.name}) · model: {model}")
    loud(f"prompts to run: {len(prompts)}")
    loud("─" * 60)

    results = []
    total_cost = 0.0
    for i, p in enumerate(prompts, 1):
        pid = p.get("id", f"prompt-{i}")
        cat = p.get("category", "?")
        loud(f"[{i}/{len(prompts)}] {pid} ({cat}) → invoking nala...")
        response, meta = await invoke_agent(system_prompt, p.get("text", ""), model=model)
        if "error" in meta:
            loud(f"  ✗ ERROR: {meta['error']}")
            results.append({"id": pid, "verdict": "ERROR", "error": meta["error"]})
            continue

        cost = meta.get("cost_usd") or 0
        total_cost += cost
        verdict, passed, failed = check_prompt(p, response, rubric)
        loud(
            f"  → {verdict} · {meta.get('output_tokens', 0)} tok · "
            f"${cost:.3f} · {meta.get('elapsed_sec', 0)}s"
        )
        for ok in passed:
            loud(f"     ✓ {ok}")
        for nope in failed:
            loud(f"     ✗ {nope}")
        results.append({
            "id": pid,
            "category": cat,
            "verdict": verdict,
            "passed": passed,
            "failed": failed,
            "response_excerpt": response[:300],
            "cost_usd": cost,
        })

    # Summary
    loud("─" * 60)
    by_verdict: dict[str, int] = {}
    for r in results:
        by_verdict[r["verdict"]] = by_verdict.get(r["verdict"], 0) + 1
    loud(f"summary: {dict(sorted(by_verdict.items()))}")
    loud(f"total cost: ${total_cost:.3f}")
    loud(f"results: {len(results)} prompts")

    # Save full report
    out_path = REPO / "agents" / f"{slug}-eval-runs"
    out_path.mkdir(parents=True, exist_ok=True)
    stamp = time.strftime("%Y-%m-%dT%H%M")
    out_file = out_path / f"{stamp}.yaml"
    with out_file.open("w") as f:
        yaml.dump(
            {
                "agent_id": slug,
                "ran_at": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
                "n_prompts": len(results),
                "summary": dict(sorted(by_verdict.items())),
                "total_cost_usd": round(total_cost, 4),
                "results": results,
            },
            f,
            default_flow_style=False,
            sort_keys=False,
            allow_unicode=True,
        )
    loud(f"wrote {out_file.relative_to(REPO)}")

    # Exit code: non-zero if any FAIL
    return 1 if by_verdict.get("FAIL", 0) > 0 else 0


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--slug", default="nala", help="agent slug (default: nala)")
    p.add_argument("--limit", type=int, default=None, help="run only first N prompts")
    args = p.parse_args()
    return asyncio.run(run_eval(args.slug, args.limit))


if __name__ == "__main__":
    sys.exit(main())
