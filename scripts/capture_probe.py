#!/usr/bin/env python3
# One-shot helper to surface a target agent's current view on a topic
# during a domain-capture flow. Used when invoking the agent through the
# regular Claude Code Agent tool isn't available in this session.
#
# Usage:
#   uv run python scripts/capture_probe.py --slug <slug> --question "<text>"

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


def load_agent(slug: str) -> tuple[dict, str]:
    path = REPO / "agents" / f"{slug}.md"
    text = path.read_text()
    m = re.match(r"^---\n(.*?)\n---\n(.*)", text, re.DOTALL)
    fm = yaml.safe_load(m.group(1))
    body = m.group(2).strip()
    return fm, body


async def probe(slug: str, question: str) -> None:
    fm, body = load_agent(slug)
    model = fm.get("model", "claude-opus-4-7")
    if model == "opus":
        model = "claude-opus-4-7"
    elif model == "sonnet":
        model = "claude-sonnet-4-6"

    tools_raw = fm.get("tools", "")
    if isinstance(tools_raw, str):
        allowed_tools = [t.strip() for t in tools_raw.split(",") if t.strip()]
    else:
        allowed_tools = list(tools_raw) if tools_raw else []

    options = ClaudeAgentOptions(
        model=model,
        allowed_tools=allowed_tools,
        max_turns=10,
        system_prompt=body,
    )

    text_parts: list[str] = []
    started = time.monotonic()
    cost_usd = None
    async for message in query(prompt=question, options=options):
        if isinstance(message, AssistantMessage):
            for block in message.content:
                if isinstance(block, TextBlock):
                    text_parts.append(block.text)
        elif isinstance(message, ResultMessage):
            cost_usd = getattr(message, "total_cost_usd", None)

    elapsed = time.monotonic() - started
    response = "".join(text_parts)
    print("─" * 60)
    print(f"agent: {slug} · model: {model} · {elapsed:.1f}s · ${cost_usd:.3f}")
    print("─" * 60)
    print(response)


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--slug", required=True)
    p.add_argument("--question", required=True)
    args = p.parse_args()
    asyncio.run(probe(args.slug, args.question))
    return 0


if __name__ == "__main__":
    sys.exit(main())
