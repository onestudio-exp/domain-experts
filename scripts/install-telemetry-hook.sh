#!/usr/bin/env bash
# scripts/install-telemetry-hook.sh
#
# Bash equivalent of install-telemetry-hook.ps1.
# Install the post-commit telemetry hook into the venture's git repo.
#
# Usage:
#   ./install-telemetry-hook.sh             # install
#   ./install-telemetry-hook.sh --uninstall # remove
#   ./install-telemetry-hook.sh --status    # check

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK_SOURCE="$SCRIPT_DIR/hooks/post-commit"

VENTURE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$VENTURE_ROOT" ]; then
    echo "ERROR: not inside a git repository. cd into your venture first." >&2
    exit 1
fi

HOOK_TARGET="$VENTURE_ROOT/.git/hooks/post-commit"
TELEMETRY_DIR="$VENTURE_ROOT/.telemetry"
GITIGNORE_PATH="$VENTURE_ROOT/.gitignore"

case "${1:-install}" in
    --status|-s|status)
        echo "=== Telemetry hook status ==="
        echo "Venture root:   $VENTURE_ROOT"
        if [ -f "$HOOK_TARGET" ]; then
            echo "Hook installed: YES"
        else
            echo "Hook installed: NO"
        fi
        if [ -d "$TELEMETRY_DIR" ]; then
            echo "Telemetry dir:  EXISTS"
            if [ -f "$TELEMETRY_DIR/edits.jsonl" ]; then
                count=$(wc -l < "$TELEMETRY_DIR/edits.jsonl")
                echo "Edits captured: $count"
            fi
        else
            echo "Telemetry dir:  NOT YET"
        fi
        exit 0
        ;;
    --uninstall|-u|uninstall)
        if [ -f "$HOOK_TARGET" ]; then
            rm "$HOOK_TARGET"
            echo "OK - removed: $HOOK_TARGET"
        else
            echo "(no hook installed)"
        fi
        echo "Note: .telemetry/ directory preserved (delete manually if desired)."
        exit 0
        ;;
esac

# Install
if [ ! -f "$HOOK_SOURCE" ]; then
    echo "ERROR: hook source not found at $HOOK_SOURCE" >&2
    exit 1
fi

cp "$HOOK_SOURCE" "$HOOK_TARGET"
chmod +x "$HOOK_TARGET"
echo "OK - installed hook: $HOOK_TARGET"

if [ ! -d "$TELEMETRY_DIR" ]; then
    mkdir -p "$TELEMETRY_DIR"
    echo "OK - created: $TELEMETRY_DIR"
fi

if ! grep -q '^\.telemetry/' "$GITIGNORE_PATH" 2>/dev/null; then
    printf "\n# Agent Edit Telemetry (do not commit)\n.telemetry/\n" >> "$GITIGNORE_PATH"
    echo "OK - added .telemetry/ to .gitignore"
else
    echo "(.gitignore already excludes .telemetry/)"
fi

echo ""
echo "Done. Every future commit that touches agent files will be captured."
echo "Run with --status to inspect, --uninstall to remove."
