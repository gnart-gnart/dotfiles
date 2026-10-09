# ~/.zprofile — login shells (macOS terminals and tmux panes are login shells)

# Homebrew (Apple Silicon: /opt/homebrew)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Homebrew's openjdk is keg-only; expose it for Java tooling (jdtls etc.)
if [[ -n "${HOMEBREW_PREFIX:-}" && -d "$HOMEBREW_PREFIX/opt/openjdk" ]]; then
  export JAVA_HOME="$HOMEBREW_PREFIX/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
  path=("$HOMEBREW_PREFIX/opt/openjdk/bin" $path)
fi
