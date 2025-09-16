#!/bin/bash

# Directories
NVIM_OPT="$HOME/.local/opt"
NVIM_BIN="$HOME/.local/bin"
NVIM_TAR="nvim-linux-x86_64.tar.gz"
NVIM_SYMLINK="$NVIM_BIN/nvim"
SHELL_CFG=".zshrc_local"

# Ensure directories exist
mkdir -p "$NVIM_OPT" "$NVIM_BIN"

# Download latest nvim build
curl -LO "https://github.com/neovim/neovim/releases/latest/download/$NVIM_TAR"

# Extract directly to ~/.local/opt
rm -rf "$NVIM_OPT/nvim-linux-x86_64"
tar -C "$NVIM_OPT" -xzf "$NVIM_TAR"
rm "$NVIM_TAR"

# Symlink binary into ~/.local/bin as nvim (force replace)
ln -sf "$NVIM_OPT/nvim-linux-x86_64/bin/nvim" "$NVIM_SYMLINK"

# Add ~/.local/bin to PATH and prioritize it
if ! echo ":$PATH:" | grep -q ":$HOME/.local/bin:"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/$SHELL_CFG"
    export PATH="$HOME/.local/bin:$PATH"
fi
