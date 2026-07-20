#!/usr/bin/env bash
set -euo pipefail

# Directories
NVIM_BIN="$HOME/.local/bin"
TMP_DIR="$(mktemp -d)"
URL="https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.11/tree-sitter-linux-x64.gz"
BIN_NAME="tree-sitter"
TARGET="$NVIM_BIN/$BIN_NAME"

mkdir -p "$NVIM_BIN"
cd "$TMP_DIR"

echo "Downloading tree-sitter..."
curl -L "$URL" -o "$BIN_NAME.gz"

echo "Extracting..."
gunzip -f "$BIN_NAME.gz"

echo "Installing to $TARGET..."
chmod +x "$BIN_NAME"
mv -f "$BIN_NAME" "$TARGET"

echo "Done: installed $TARGET"
echo "Run: $TARGET --version"
