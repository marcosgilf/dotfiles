# Login shells only. macOS /etc/zprofile runs path_helper before this file.

# Homebrew, installed on Apple Silicon or Intel macOS.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Runtime and package-manager paths.
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
case ":$PATH:" in
  *":$BUN_INSTALL/bin:"*) ;;
  *) export PATH="$BUN_INSTALL/bin:$PATH" ;;
esac
if [[ -n "${HOMEBREW_PREFIX:-}" && -d "$NVM_DIR" && -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]]; then
  source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
fi
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Keep personal shims ahead of paths from path_helper and Homebrew.
export PATH="$HOME/.local/bin:$PATH"
