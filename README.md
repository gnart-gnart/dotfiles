# dotfiles

One setup for Fedora (KDE Plasma) and macOS (Apple Silicon): **WezTerm + zsh + tmux + Neovim**, Tokyo Night colors, Maple Mono font. Symlinked into place with [GNU Stow](https://www.gnu.org/software/stow/).

## What's in here

```
dotfiles/
├── wezterm/.config/wezterm/wezterm.lua   terminal: borderless, 0.9 opacity + blur, no tab bar
├── tmux/.config/tmux/tmux.conf           prefix Ctrl-a, mouse, TPM plugins, Tokyo Night status bar
├── zsh/.zshrc .zshenv .zprofile          shell: history, completion, fzf, zoxide, plugins, aliases
├── starship/.config/starship.toml        prompt
├── nvim/.config/nvim/                    Neovim (lazy.nvim, LSP, completion, telescope, ...)
├── git/.gitconfig                        shared git settings (name/email go in ~/.gitconfig.local)
├── bat/.config/bat/config                bat theme
├── packages/Brewfile                     macOS packages
├── packages/fedora.txt                   Fedora packages
└── install.sh                            installs packages + font, backs up old configs, runs stow
```

Each top-level folder is a Stow "package" whose contents mirror `$HOME`. `stow nvim` makes `~/.config/nvim` a symlink to `dotfiles/nvim/.config/nvim`, so editing either path edits the repo.

## Install (either machine)

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

Then log out and back in (zsh becomes the login shell) and open WezTerm. The first Neovim launch downloads plugins and language servers; the first tmux launch installs its plugins.

`./install.sh --link-only` just re-runs the symlinking.

## Requirements worth knowing

- **Neovim 0.11+.** Fedora 43 ships 0.11 and Fedora 44+ ships 0.12; Homebrew has the latest. The config detects the version and picks the right nvim-treesitter branch.
- **Neovim 0.12+ also needs `tree-sitter` CLI 0.26.1+** (`tree-sitter-cli` in the package lists). Check with `tree-sitter --version`.
- **A Nerd Font** for icons: the installer gets Maple Mono NF (`brew install --cask font-maple-mono-nf` on macOS).

## Daily-use cheat sheet

**tmux** (prefix is `Ctrl-a`; press it, release, then the key)

| Keys | Action |
|---|---|
| `prefix` `c` | new window |
| `prefix` `\|` / `prefix` `-` | split right / split down |
| `Ctrl-h/j/k/l` | move between panes (and Neovim splits) |
| `prefix` `H/J/K/L` | resize pane |
| `prefix` `1`..`9` | jump to window |
| `prefix` `d` | detach (session keeps running) |
| `prefix` `r` | reload config |
| `prefix` `I` | install TPM plugins |
| `prefix` `Ctrl-l` | clear screen |
| `prefix` `Ctrl-a` | send a literal Ctrl-a (jump to start of line in zsh) |

**Neovim** (leader is `Space`; press it and wait to see every option via which-key)

| Keys | Action |
|---|---|
| `<leader>ff` / `fg` / `fb` / `fr` | find files / grep / buffers / recent |
| `-` or `<leader>e` | file explorer (oil) |
| `gd`, `K`, `grr` | definition, hover docs, references |
| `<leader>rn`, `<leader>ca` | rename, code action |
| `<leader>cf` | format (also runs on save) |
| `[d` / `]d` | previous / next diagnostic |
| `:Mason`, `:Lazy` | manage language servers / plugins |

## Customizing

- **Solid window instead of translucent:** set `window_background_opacity = 1.0` in `wezterm.lua` and `transparent = false` in `nvim/.config/nvim/lua/plugins/colorscheme.lua`.
- **Go back to Ctrl-b for tmux:** in `tmux.conf` replace `C-a` with `C-b` in the three prefix lines (or delete them).
- **Stop auto-starting tmux in WezTerm:** `touch ~/.config/tmux/.disable-autostart` (delete the file to turn it back on).
- **Machine-specific shell settings:** put them in `~/.zshrc.local`; it's sourced if present and never committed.
- **Git name/email/credentials:** live in `~/.gitconfig.local`.

## Keeping both machines in sync

- Commit `nvim/.config/nvim/lazy-lock.json` after the first Neovim launch and after any `:Lazy update`; it pins exact plugin versions so both machines match.
- Edit configs in place (they're symlinks), then `git add -A && git commit && git push`. On the other machine: `git pull`.
- New config file for an existing package: just add it to the package folder and run `./install.sh --link-only`. New package: add the folder, add its name to `PACKAGES` in `install.sh`.

## Troubleshooting

- **Icons look like boxes:** Maple Mono NF isn't installed or WezTerm hasn't been restarted. Check with `fc-list | grep -i maple`.
- **No blur on KDE:** needs the WezTerm *nightly* build (the installer uses the nightly COPR). If it still doesn't blur, try `enable_wayland = false` in `wezterm.lua`.
- **`stow` reports a conflict:** a real file exists where a link should go. Move it away and re-run. `install.sh` does this automatically and tells you where the backup went.
- **Treesitter warning about `tree-sitter` CLI (Neovim 0.12+):** install `tree-sitter-cli`, or `cargo install tree-sitter-cli` if your distro's is older than 0.26.1.
- **Ctrl-l doesn't clear the screen:** it's taken by pane navigation; use `prefix` `Ctrl-l`.
