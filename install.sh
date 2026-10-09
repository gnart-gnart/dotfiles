#!/usr/bin/env bash
# Dotfiles installer for Fedora and macOS.
#
#   ./install.sh               install packages + font, then symlink the configs
#   ./install.sh --link-only   only (re)symlink the configs with GNU Stow
#
# Safe to re-run. Existing configs that would be overwritten are moved to
# ~/.dotfiles-backup/<timestamp>/ first.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(wezterm nvim tmux zsh starship git bat)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
OS="$(uname -s)"

LINK_ONLY=0
[[ "${1:-}" == "--link-only" ]] && LINK_ONLY=1

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m%s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx \033[0m%s\n' "$*" >&2; exit 1; }

# ── Packages ───────────────────────────────────────────────────────────
install_packages_mac() {
  if ! command -v brew >/dev/null 2>&1 && [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  command -v brew >/dev/null 2>&1 || die "Homebrew not found. Install it from https://brew.sh, then re-run."
  say "Installing Homebrew packages"
  brew bundle --file="$DOTFILES/packages/Brewfile"
}

install_packages_fedora() {
  say "Installing Fedora packages (sudo password needed)"
  local pkgs
  mapfile -t pkgs < <(grep -vE '^\s*(#|$)' "$DOTFILES/packages/fedora.txt" | sed 's/[[:space:]]*#.*//')
  sudo dnf install -y --setopt=strict=0 "${pkgs[@]}" \
    || warn "Some packages failed to install; check the output above."

  if ! command -v wezterm >/dev/null 2>&1; then
    say "Adding the WezTerm nightly COPR and installing WezTerm"
    sudo dnf copr enable -y wezfurlong/wezterm-nightly
    sudo dnf install -y wezterm
  fi
}

install_font_linux() {
  if fc-list 2>/dev/null | grep -qi "Maple Mono NF"; then
    say "Maple Mono NF already installed"
    return 0
  fi
  say "Installing Maple Mono NF into ~/.local/share/fonts"
  local tmp dest="$HOME/.local/share/fonts/MapleMono-NF"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/maple.zip" \
    "https://github.com/subframe7536/maple-font/releases/latest/download/MapleMono-NF-unhinted.zip" \
    || { warn "Font download failed; install Maple Mono NF manually."; rm -rf "$tmp"; return 0; }
  mkdir -p "$dest"
  unzip -oq "$tmp/maple.zip" -d "$dest"
  rm -rf "$tmp"
  fc-cache -f
}

# ── Linking ────────────────────────────────────────────────────────────
link_dotfiles() {
  command -v stow >/dev/null 2>&1 || die "GNU Stow not found (Fedora: sudo dnf install stow, macOS: brew install stow)."
  mkdir -p "$HOME/.config"

  # Move aside anything real that Stow would otherwise refuse to overwrite.
  # Whole directories (~/.config/nvim etc.) are moved so Stow can link the directory itself.
  local pkg entry name target
  for pkg in "${PACKAGES[@]}"; do
    for entry in "$DOTFILES/$pkg"/.[!.]* "$DOTFILES/$pkg"/.config/*; do
      [[ -e "$entry" ]] || continue
      name="$(basename "$entry")"
      if [[ "$entry" == "$DOTFILES/$pkg/.config/"* ]]; then
        target="$HOME/.config/$name"
      elif [[ "$name" == ".config" ]]; then
        continue
      else
        target="$HOME/$name"
      fi
      [[ -e "$target" || -L "$target" ]] || continue
      # Already pointing into this repo? Nothing to do.
      if [[ -L "$target" ]] && [[ "$(readlink -f "$target")" == "$DOTFILES"/* ]]; then
        continue
      fi
      mkdir -p "$BACKUP_DIR"
      mv "$target" "$BACKUP_DIR/$name"
      warn "Backed up existing $target -> $BACKUP_DIR/$name"
    done
  done

  say "Linking configs with Stow: ${PACKAGES[*]}"
  stow -d "$DOTFILES" -t "$HOME" --restow "${PACKAGES[@]}"
}

# ── Git identity (kept out of the repo) ────────────────────────────────
setup_git_identity() {
  local f="$HOME/.gitconfig.local"
  [[ -f "$f" ]] && return 0
  say "Creating ~/.gitconfig.local (your name/email stay out of the repo)"
  local name="" email="" helper
  if [[ -t 0 ]]; then
    read -r -p "  Git name:  " name
    read -r -p "  Git email: " email
  fi
  if [[ "$OS" == "Darwin" ]]; then helper="osxkeychain"; else helper="cache --timeout=7200"; fi
  {
    printf '[user]\n'
    printf '\tname = %s\n' "${name:-Your Name}"
    printf '\temail = %s\n' "${email:-you@example.com}"
    printf '[credential]\n'
    printf '\thelper = %s\n' "$helper"
  } > "$f"
}

# ── bat theme (Tokyo Night) ────────────────────────────────────────────
install_bat_theme() {
  command -v bat >/dev/null 2>&1 || return 0
  local dir
  dir="$(bat --config-dir)/themes"
  [[ -f "$dir/tokyonight_night.tmTheme" ]] && return 0
  say "Installing the Tokyo Night theme for bat"
  mkdir -p "$dir"
  if curl -fsSL -o "$dir/tokyonight_night.tmTheme" \
      "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme"; then
    bat cache --build >/dev/null
  else
    rm -f "$dir/tokyonight_night.tmTheme"
    warn "Could not download the bat theme; bat will show a theme warning until it is installed."
  fi
}

# ── Default shell ──────────────────────────────────────────────────────
set_default_shell() {
  local zsh_path
  zsh_path="$(command -v zsh || true)"
  [[ -n "$zsh_path" ]] || { warn "zsh not found; skipping chsh."; return 0; }
  [[ "$(basename "${SHELL:-}")" == "zsh" ]] && return 0
  say "Setting zsh as your login shell (password prompt)"
  chsh -s "$zsh_path" || warn "chsh failed. Run manually: chsh -s $zsh_path"
}

# ── Main ───────────────────────────────────────────────────────────────
main() {
  say "Dotfiles directory: $DOTFILES"

  if [[ $LINK_ONLY -eq 0 ]]; then
    case "$OS" in
      Darwin)
        install_packages_mac
        ;;
      Linux)
        if grep -qi '^ID=fedora' /etc/os-release 2>/dev/null; then
          install_packages_fedora
        else
          warn "Not Fedora: skipping package install. Install the tools listed in packages/fedora.txt yourself."
        fi
        install_font_linux
        ;;
      *)
        die "Unsupported OS: $OS"
        ;;
    esac
  fi

  link_dotfiles
  setup_git_identity
  install_bat_theme
  [[ $LINK_ONLY -eq 0 ]] && set_default_shell

  say "Done. Log out and back in (so zsh becomes your login shell), then open WezTerm."
  say "First Neovim launch downloads plugins and language servers; give it a minute."
}

main "$@"
