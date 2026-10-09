# ~/.zshenv — read by every zsh (keep it light)

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

: "${LANG:=en_US.UTF-8}"
export LANG

export EDITOR="nvim"
export VISUAL="nvim"

# De-duplicate PATH and put user bins first
typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/.dotnet/tools" $path)
export PATH
