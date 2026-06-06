#!/usr/bin/env bash
# scripts/dev-sync.sh
#
# Dev-mode helper for the domain-experts monorepo when consumed as a git
# submodule inside a venture project. Bash equivalent of dev-sync.ps1.
#
# Commands:
#   ./scripts/dev-sync.sh sync     -> reload plugin from submodule into Claude Code
#   ./scripts/dev-sync.sh pull     -> git pull in submodule then sync
#   ./scripts/dev-sync.sh status   -> show submodule commit + local changes
#   ./scripts/dev-sync.sh help     -> show this header
#
# See dev-sync.ps1 for the full daily-workflow documentation.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULE_ROOT="$(dirname "$SCRIPT_DIR")"

if [ ! -f "$SUBMODULE_ROOT/.claude-plugin/marketplace.json" ]; then
    echo "ERROR: this script must live inside the domain-experts monorepo." >&2
    echo "Expected manifest at: $SUBMODULE_ROOT/.claude-plugin/marketplace.json" >&2
    exit 1
fi

cmd_sync() {
    echo "[1/2] uninstalling current plugin..."
    claude plugin uninstall domain-experts@domain-experts 2>&1 | head -1 || true

    echo "[2/2] installing from submodule..."
    claude plugin install domain-experts@domain-experts 2>&1 | head -1

    echo ""
    echo "OK - sync complete. Claude Code now uses the current submodule state."
}

cmd_pull() {
    echo "pulling latest from upstream..."
    (cd "$SUBMODULE_ROOT" && git pull origin main)
    echo ""
    cmd_sync
}

cmd_status() {
    cd "$SUBMODULE_ROOT"
    echo "=== submodule state ==="
    echo "path:   $SUBMODULE_ROOT"
    echo "remote: $(git config --get remote.origin.url)"
    echo "branch: $(git rev-parse --abbrev-ref HEAD)"
    echo "commit: $(git log -1 --oneline)"
    echo ""
    echo "=== local changes ==="
    changes=$(git status --short)
    if [ -n "$changes" ]; then
        echo "$changes"
    else
        echo "(clean - no local edits)"
    fi
    echo ""
    echo "=== commits ahead of origin/main ==="
    ahead=$(git log origin/main..HEAD --oneline 2>/dev/null || true)
    if [ -n "$ahead" ]; then
        echo "$ahead"
        echo ""
        echo "TIP: run 'git push' inside $SUBMODULE_ROOT to share with the team."
    else
        echo "(up to date with origin/main)"
    fi
}

cmd_help() {
    sed -n '1,15p' "${BASH_SOURCE[0]}"
}

case "${1:-help}" in
    sync)   cmd_sync ;;
    pull)   cmd_pull ;;
    status) cmd_status ;;
    help)   cmd_help ;;
    *)      echo "Unknown command: $1" >&2; cmd_help; exit 1 ;;
esac
