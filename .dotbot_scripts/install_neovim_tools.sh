#!/usr/bin/env bash
set -euo pipefail

# Programs to install
LAZYGIT_BIN="lazygit"
TREESITTER_BIN="tree-sitter"
LUAROCKS_BIN="luarocks"

# Local bin directory
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Ensure PATH hints (optional; you may want to add this to your shell profile)
if ! echo "$PATH" | grep -q "$LOCAL_BIN"; then
  echo "Note: Consider adding $LOCAL_BIN to your PATH in your shell profile."
fi

# Detect distro family
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
      arch)       echo "arch" ;;
      ubuntu|debian) echo "debian" ;;
      fedora)     echo "fedora" ;;
      *)          echo "unknown" ;;
    esac
  else
    echo "unknown"
  fi
}

# Install a tool via system package manager if available
install_via_pkgmgr() {
  local distro="$1"
  local tool="$2"
  local pkg=""

  case "$tool" in
    lazygit)
      pkg_lazygit="lazygit"
      ;;
    tree-sitter)
      pkg_treesitter="tree-sitter-cli"  # Arch uses tree-sitter-cli; Ubuntu/Fedora often tree-sitter
      ;;
    luarocks)
      pkg_luarocks="luarocks"
      ;;
  esac

  case "$distro" in
    arch)
      if command -v pacman >/dev/null 2>&1; then
        case "$tool" in
          lazygit)      sudo pacman -S --noconfirm lazygit ;;
          tree-sitter)  sudo pacman -S --noconfirm tree-sitter-cli ;;
          luarocks)     sudo pacman -S --noconfirm luarocks ;;
        esac
        return 0
      fi
      ;;
    debian)
      if command -v apt-get >/dev/null 2>&1; then
        case "$tool" in
          lazygit)      sudo apt-get update -y && sudo apt-get install -y lazygit ;;
          tree-sitter)  sudo apt-get update -y && sudo apt-get install -y tree-sitter ;;
          luarocks)     sudo apt-get update -y && sudo apt-get install -y luarocks ;;
        esac
        return 0
      fi
      ;;
    fedora)
      if command -v dnf >/dev/null 2>&1; then
        case "$tool" in
          lazygit)
            # Enable copr if needed; on some systems lazygit is in standard repos
            if ! dnf repo list | grep -q copr; then
              sudo dnf copr enable atim/lazygit -y || true
            fi
            sudo dnf install -y lazygit
            ;;
          tree-sitter)  sudo dnf install -y tree-sitter tree-sitter-devel ;;
          luarocks)     sudo dnf install -y luarocks ;;
        esac
        return 0
      fi
      ;;
    *)
      return 1
      ;;
  esac
  return 1
}

# Fallback: install lazygit from GitHub releases into ~/.local/bin
install_lazygit_local() {
  echo "Installing lazygit (local)..."
  local arch
  arch=$(uname -m)
  local gh_arch
  case "$arch" in
    x86_64)  gh_arch="x86_64" ;;
    aarch64) gh_arch="arm64" ;;
    arm64)   gh_arch="arm64" ;;
    *)       echo "Unsupported architecture for lazygit: $arch"; return 1 ;;
  esac

  local version
  version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
            | grep -oP '"tag_name": "\K[^"]+')
  if [ -z "$version" ]; then
    echo "Failed to fetch latest lazygit version"
    return 1
  fi

  local url="https://github.com/jesseduffield/lazygit/releases/download/${version}/lazygit_${version#v}_Linux_${gh_arch}.tar.gz"
  local tmpdir
  tmpdir=$(mktemp -d)

  curl -fsSL "$url" -o "$tmpdir/lazygit.tar.gz"
  tar -xzf "$tmpdir/lazygit.tar.gz" -C "$tmpdir" lazygit
  install -m 0755 "$tmpdir/lazygit" "$LOCAL_BIN/lazygit"
  rm -rf "$tmpdir"

  echo "lazygit installed to $LOCAL_BIN/lazygit"
}

# Fallback: install tree-sitter CLI from GitHub releases into ~/.local/bin
install_tree_sitter_local() {
  echo "Installing tree-sitter CLI (local)..."
  local arch
  arch=$(uname -m)
  local gh_arch
  case "$arch" in
    x86_64)  gh_arch="x86_64" ;;
    aarch64) gh_arch="arm64" ;;
    arm64)   gh_arch="arm64" ;;
    *)       echo "Unsupported architecture for tree-sitter: $arch"; return 1 ;;
  esac

  local version
  version=$(curl -s "https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest" \
            | grep -oP '"tag_name": "\K[^"]+')
  if [ -z "$version" ]; then
    echo "Failed to fetch latest tree-sitter version"
    return 1
  fi

  local url="https://github.com/tree-sitter/tree-sitter/releases/download/${version}/tree-sitter-linux-${gh_arch}.gz"
  local tmpbin
  tmpbin=$(mktemp)
  curl -fsSL "$url" -o "$tmpbin.gz"
  gunzip -c "$tmpbin.gz" > "$tmpbin"
  install -m 0755 "$tmpbin" "$LOCAL_BIN/tree-sitter"
  rm -f "$tmpbin" "$tmpbin.gz"

  echo "tree-sitter installed to $LOCAL_BIN/tree-sitter"
}

# Fallback: install luarocks via official installer or local script
install_luarocks_local() {
  echo "Installing luarocks (local)..."
  # Option 1: use luarocks GitHub installer script if available
  if command -v curl >/dev/null 2>&1; then
    local tmpdir
    tmpdir=$(mktemp -d)
    curl -fsSL https://raw.githubusercontent.com/luarocks/luarocks/master/tools/install.sh \
      -o "$tmpdir/install.sh"
    cd "$tmpdir"
    PREFIX="$LOCAL_BIN/../luarocks" ./install.sh --prefix="$PREFIX" || {
      echo "Luarocks local install failed; you may need to install manually."
      cd - >/dev/null
      rm -rf "$tmpdir"
      return 1
    }
    cd - >/dev/null
    rm -rf "$tmpdir"
    # Create wrapper in LOCAL_BIN
    ln -sf "$PREFIX/bin/luarocks" "$LOCAL_BIN/luarocks"
    echo "luarocks installed under $PREFIX, wrapper in $LOCAL_BIN/luarocks"
  else
    echo "curl not found; cannot install luarocks automatically."
    return 1
  fi
}

maybe_install_local() {
  local tool="$1"
  case "$tool" in
    lazygit)      install_lazygit_local ;;
    tree-sitter)  install_tree_sitter_local ;;
    luarocks)     install_luarocks_local ;;
  esac
}

main() {
  local distro
  distro=$(detect_distro)
  echo "Detected distro: $distro"

  for tool in lazygit tree-sitter luarocks; do
    echo "Attempting to install $tool..."
    if install_via_pkgmgr "$distro" "$tool" 2>/dev/null; then
      echo "$tool installed via package manager."
      continue
    fi

    echo "Package manager install failed or not available for $tool. Trying local install..."
    if command -v "$tool" >/dev/null 2>&1; then
      echo "$tool already available in PATH."
      continue
    fi

    if ! maybe_install_local "$tool"; then
      echo "Could not install $tool automatically. You may need to install it manually."
    fi
  done

  echo "Done. Check '$LAZYGIT_BIN --version', '$TREESITTER_BIN --version', and '$LUAROCKS_BIN --version'."
}

main "$@"
