#!/bin/sh
set -e

clone_or_update() {
    repo_dir="$1"
    repo_url="$2"

    if [ -d "$repo_dir/.git" ]; then
        echo "Updating $(basename "$repo_dir")..."
        git -C "$repo_dir" pull --ff-only
    else
        echo "Cloning $(basename "$repo_dir")..."
        git clone --depth=1 "$repo_url" "$repo_dir"
    fi
}

clone_or_update "${ZDOTDIR:-$HOME}/.antidote" "https://github.com/mattmc3/antidote.git"
clone_or_update "$HOME/.tmux/plugins/tpm" "https://github.com/tmux-plugins/tpm.git"
