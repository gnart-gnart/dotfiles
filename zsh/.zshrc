# ~/.zshrc — interactive shells

# ── tmux auto-start (only inside WezTerm) ──────────────────────────────
# Attaches to (or creates) a tmux session called "main".
# Turn it off with:   touch ~/.config/tmux/.disable-autostart
if [[ -o interactive && -z "$TMUX" && "$TERM_PROGRAM" == "WezTerm" \
      && ! -e "$HOME/.config/tmux/.disable-autostart" ]] \
   && command -v tmux >/dev/null 2>&1; then
  exec tmux new-session -A -s main
fi

# ── History ────────────────────────────────────────────────────────────
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt SHARE_HISTORY EXTENDED_HISTORY

# ── Shell options ──────────────────────────────────────────────────────
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS INTERACTIVE_COMMENTS
setopt COMPLETE_IN_WORD NO_BEEP
bindkey -e   # emacs-style line editing (Ctrl-a / Ctrl-e etc.)

# Up/Down arrows search history by what you've already typed
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

# ── Helper: source the first readable file from a list ─────────────────
_source_first() {
  local f
  for f in "$@"; do
    [[ -r "$f" ]] && { source "$f"; return 0; }
  done
  return 1
}

# ── Completion ─────────────────────────────────────────────────────────
[[ -n "${HOMEBREW_PREFIX:-}" ]] && FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── fzf (Ctrl-r history, Ctrl-t files, Alt-c cd) ───────────────────────
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded \
--color=fg:#c0caf5,bg:-1,hl:#bb9af7 \
--color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff \
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a,border:#3b4261"
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
  if command -v bat >/dev/null 2>&1; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
  fi
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  else
    _source_first /usr/share/fzf/shell/key-bindings.zsh \
                  "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf/shell/key-bindings.zsh"
    _source_first /usr/share/fzf/shell/completion.zsh \
                  "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf/shell/completion.zsh"
  fi
fi

# ── zoxide: smarter cd  (z <partial-name>, zi for interactive) ─────────
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# ── Aliases ────────────────────────────────────────────────────────────
alias v='nvim'
alias vim='nvim'
alias g='git'
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate -20'
alias ..='cd ..'
alias ...='cd ../..'
alias ta='tmux new-session -A -s'   # ta <name>: attach or create a named session

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lah --icons --group-directories-first --git'
  alias lt='eza --tree --level=2 --icons'
elif [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -G'
  alias ll='ls -lah'
else
  alias ls='ls --color=auto'
  alias ll='ls -lah'
fi

# ── Functions ──────────────────────────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1"; }

# Pipe anything to the system clipboard:  echo hi | clip
clip() {
  if command -v pbcopy >/dev/null 2>&1; then pbcopy
  elif command -v wl-copy >/dev/null 2>&1; then wl-copy
  elif command -v xclip >/dev/null 2>&1; then xclip -selection clipboard
  else echo "clip: no clipboard tool found (install wl-clipboard or xclip)" >&2; return 1
  fi
}

# ── Autosuggestions (grey "ghost text" from history) ───────────────────
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#565f89'
_source_first /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
              "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# ── Prompt ─────────────────────────────────────────────────────────────
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# ── Machine-specific / private settings (not in the repo) ──────────────
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ── Syntax highlighting — must be sourced LAST ─────────────────────────
_source_first /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
              "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
