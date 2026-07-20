#!/bin/sh
# Script for cleaning merged git branches
# Usage: ./git-clean-branches.sh [-f]
#   -f  Force delete branches (uses -D instead of -d)

set -e

FORCE=0
while getopts "f" opt; do
    case "$opt" in
        f) FORCE=1 ;;
        *) echo "Usage: $0 [-f]" >&2; exit 1 ;;
    esac
done

# Verify we're inside a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: not inside a git repository." >&2
    exit 1
fi

# Verify fzf is available
if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is not installed." >&2
    exit 1
fi

# Prune stale remote-tracking refs
echo "Pruning stale remote refs..."
git remote prune origin

# Collect merged branches, excluding protected ones and the current branch
MERGED=$(git branch --merged \
    | grep -v -E '^\*|^[[:space:]]*(main|master|develop|staging)[[:space:]]*$')

if [ -z "$MERGED" ]; then
    echo "No merged branches to clean up."
    exit 0
fi

# Let the user pick branches interactively with fzf
SELECTED=$(echo "$MERGED" \
    | sed 's/^[[:space:]]*//' \
    | fzf --multi \
        --bind "ctrl-a:select-all,ctrl-d:deselect-all" \
        --prompt "Select branches to delete: " \
        --header "CTRL-A/D (de)select all | TAB select | ENTER confirm | ESC abort" \
        --preview "git log --oneline --color=always -10 {} --" \
        --preview-window "right:60%")

if [ -z "$SELECTED" ]; then
    echo "No branches selected. Aborting."
    exit 0
fi

# Delete selected branches
DELETE_FLAG="-d"
[ "$FORCE" -eq 1 ] && DELETE_FLAG="-D"

DELETED=0
FAILED=0
while IFS= read -r branch; do
    [ -z "$branch" ] && continue
    if git branch "$DELETE_FLAG" "$branch" 2>/dev/null; then
        echo "  Deleted: $branch"
        DELETED=$((DELETED + 1))
    else
        echo "  Failed:  $branch (not fully merged? use -f to force)" >&2
        FAILED=$((FAILED + 1))
    fi
done <<EOF
$SELECTED
EOF

echo "Done. Deleted: $DELETED, Failed: $FAILED"
