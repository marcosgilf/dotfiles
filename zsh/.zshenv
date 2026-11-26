# Runs for every Zsh process. Keep this file fast and non-interactive.

# XDG base directories. XDG_CONFIG_HOME and ZDOTDIR come from bootstrap/zshenv.
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Defaults used by interactive and login-shell setup.
export EDITOR="nvim"
export VISUAL="nvim"
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

# Optional project root for the Pi shim; export it to child processes.
[[ -r "$ZDOTDIR/pi.local.zsh" ]] && source "$ZDOTDIR/pi.local.zsh"
[[ -n "${PI_WORK_ROOT:-}" ]] && export PI_WORK_ROOT
