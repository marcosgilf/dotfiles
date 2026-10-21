#!/bin/zsh
set -euo pipefail

readonly ROOT=${0:A:h}
source "$ROOT/config/programs.zsh"
readonly CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
readonly ZSH_DIR="$CONFIG_HOME/zsh"
readonly NVIM_DIR="$CONFIG_HOME/nvim"
readonly PLUGIN_SELECTION="$CONFIG_HOME/mac-setup/zsh-plugins"
typeset -ga selected_zsh_plugins=()
is_update=0
[[ -L "$ZSH_DIR" && "$(readlink "$ZSH_DIR")" == "$ROOT/zsh" ]] && is_update=1

backup_target() {
  local target=$1
  [[ -e "$target" || -L "$target" ]] || return 0
  local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
  mv "$target" "$backup"
  print "backup: $target -> $backup"
}

link_config() {
  local source=$1 target=$2
  mkdir -p "${target:h}"
  [[ -L "$target" && "$(readlink "$target")" == "$source" ]] && return 0
  backup_target "$target"
  ln -s "$source" "$target"
  print "linked: $target"
}

preserve_local_zsh() {
  local source="$ZSH_DIR" file relative
  [[ -d "$source" && ! -L "$source" ]] || return 0

  for file in "$source"/functions/*.zsh; do
    [[ -f "$file" ]] || continue
    relative=${file#$source/}
    git -C "$source" ls-files --error-unmatch "$relative" >/dev/null 2>&1 && continue
    mkdir -p "$ROOT/zsh/functions/local"
    cp -p "$file" "$ROOT/zsh/functions/local/${file:t}"
    print "preserved local function: ${file:t}"
  done
}

if ! xcode-select -p >/dev/null 2>&1; then
  print 'Install Command Line Tools, then rerun this script.'
  xcode-select --install || true
  exit 1
fi

if [[ -n "${BREW_BIN:-}" ]]; then
  [[ -x "$BREW_BIN" ]] || { print -u2 "Invalid BREW_BIN: $BREW_BIN"; exit 1; }
  brew() { "$BREW_BIN" "$@"; }
  eval "$("$BREW_BIN" shellenv)"
else
  if ! command -v brew >/dev/null 2>&1; then
    print 'Installing Homebrew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
  else
    print -u2 'Homebrew installation failed'
    exit 1
  fi
fi

"$ROOT/scripts/render-configs.sh"

trace() {
  print -P "%F{green}✔︎%f $1"
}

ask() {
  local reply
  read -r "reply?$1 [Y/n] " || { print -u2 'Input closed; aborting.'; exit 1; }
  [[ -z "$reply" || "$reply" == [Yy]* ]]
}

brew_flag() {
  case "$1" in
    brew_formula) print -r -- --formula ;;
    brew_cask) print -r -- --cask ;;
    *) print -u2 -- "Unsupported Homebrew dependency type: $1"; return 2 ;;
  esac
}

dependency_installed() {
  local type=$1 package=$2 detect_path=$3 flag
  [[ "$detect_path" != '-' && -x "$HOME/$detect_path" ]] && return 0
  flag=$(brew_flag "$type")
  brew list "$flag" "$package" >/dev/null 2>&1
}

install_if_missing() {
  local type=$1 package=$2 detect_path=$3 flag
  dependency_installed "$type" "$package" "$detect_path" && return 0
  flag=$(brew_flag "$type")
  brew install "$flag" "$package"
}

ask_optional_program() {
  local type=$1 package=$2 name=$3 description=$4 docs_url=$5 detect_path=$6
  if dependency_installed "$type" "$package" "$detect_path"; then
    print "Using $name"
    return 0
  fi
  print "$name — $description"
  print "Docs: $docs_url"
  ask "Install $name?"
}

ask_zsh_plugin() {
  local name=$1 description=$2 docs_url=$3
  print "  $name — $description"
  print "  Docs: $docs_url"
  if ask "Enable $name?"; then
    selected_zsh_plugins+=("$name")
  fi
  return 0
}

select_zsh_plugins() {
  if [[ -f "$PLUGIN_SELECTION" ]]; then
    print "Using saved Zsh plugin choices: $PLUGIN_SELECTION"
    return 0
  fi

  local record plugin
  for record in "${PROGRAMS[@]}"; do
    read_program "$record"
    [[ "$PROGRAM_TYPE" == zsh_plugin ]] || continue
    plugin=${PROGRAM_PACKAGE##*/}
    [[ -f "$ZSH_DIR/plugins/$plugin/$plugin.plugin.zsh" ]] && selected_zsh_plugins+=("$plugin")
  done
  if (( ${#selected_zsh_plugins[@]} )); then
    print 'Detected installed Zsh plugins; preserving selection.'
    return 0
  fi

  print 'Choose Zsh plugins (Enter accepts each default: yes):'
  for record in "${PROGRAMS[@]}"; do
    read_program "$record"
    [[ "$PROGRAM_TYPE" == zsh_plugin ]] || continue
    ask_zsh_plugin "$PROGRAM_NAME" "$PROGRAM_DESCRIPTION" "$PROGRAM_DOCS_URL"
  done
}

typeset -gA selected_programs
selected_programs=()
program_selected() {
  [[ "${selected_programs[$1]:-0}" == 1 ]]
}
for record in "${PROGRAMS[@]}"; do
  read_program "$record"
  [[ "$PROGRAM_SCOPE" == optional && ( "$PROGRAM_TYPE" == brew_formula || "$PROGRAM_TYPE" == brew_cask ) ]] || continue
  if ask_optional_program "$PROGRAM_TYPE" "$PROGRAM_PACKAGE" "$PROGRAM_NAME" \
    "$PROGRAM_DESCRIPTION" "$PROGRAM_DOCS_URL" "$PROGRAM_DETECT_PATH"; then
    selected_programs[$PROGRAM_PACKAGE]=1
  fi
done
select_zsh_plugins

for record in "${PROGRAMS[@]}"; do
  read_program "$record"
  [[ "$PROGRAM_SCOPE" == optional && ( "$PROGRAM_TYPE" == brew_formula || "$PROGRAM_TYPE" == brew_cask ) ]] || continue
  [[ "${selected_programs[$PROGRAM_PACKAGE]:-0}" == 1 ]] || continue
  install_if_missing "$PROGRAM_TYPE" "$PROGRAM_PACKAGE" "$PROGRAM_DETECT_PATH"
done
if [[ "${selected_programs[ghostty]:-0}" == 1 ]]; then
  for record in "${PROGRAMS[@]}"; do
    read_program "$record"
    [[ "$PROGRAM_SCOPE" == ghostty ]] || continue
    install_if_missing "$PROGRAM_TYPE" "$PROGRAM_PACKAGE" "$PROGRAM_DETECT_PATH"
  done
fi
trace 'Optional dependencies updated'

HOMEBREW_COLOR=1 brew bundle --file="$ROOT/Brewfile" 2>&1 | awk '
  {
    line = tolower($0)
    gsub(/\033\[[0-9;]*m/, "", line)
    if (line !~ /brew bundle.*complete!/) print
  }
'
trace 'Brewfile dependencies updated'

node_version=''
for record in "${PROGRAMS[@]}"; do
  read_program "$record"
  [[ "$PROGRAM_TYPE" == nvm_runtime ]] || continue
  node_version=$PROGRAM_PACKAGE
  break
done
[[ -n "$node_version" ]] || { print -u2 'No nvm runtime configured in config/programs.zsh'; exit 1; }

mkdir -p "$HOME/.nvm"
export NVM_DIR="$HOME/.nvm"
set +u # nvm.sh reads optional unset variables.
source "$(brew --prefix nvm)/nvm.sh"
current_node=$(nvm current)
if [[ "$current_node" == system || "$current_node" == none ]]; then
  if [[ -s "$NVM_DIR/alias/default" ]]; then
    nvm use default
  else
    nvm install "$node_version"
    nvm alias default "$node_version"
  fi
else
  print "Using existing Node $current_node; leaving NVM default unchanged"
fi
current_node=$(nvm current)
pi_min_node_version=''
for record in "${PROGRAMS[@]}"; do
  read_program "$record"
  [[ "$PROGRAM_TYPE" == managed_app && "$PROGRAM_PACKAGE" == pi ]] || continue
  pi_min_node_version=$PROGRAM_SETTING
  break
done
[[ -n "$pi_min_node_version" && "$pi_min_node_version" != '-' ]] || {
  print -u2 'Pi minimum Node.js version missing from config/programs.zsh'
  exit 1
}
pi_supported=1
if ! PI_MIN_NODE_VERSION="$pi_min_node_version" node -e 'const [requiredMajor, requiredMinor] = process.env.PI_MIN_NODE_VERSION.split(".").map(Number); const [major, minor] = process.versions.node.split(".").map(Number); process.exit(major > requiredMajor || (major === requiredMajor && minor >= requiredMinor) ? 0 : 1)'; then
  print -u2 "Warning: Pi requires Node.js $pi_min_node_version or newer; active Node is $current_node. Pi install/update skipped. Run 'nvm install $node_version && nvm use $node_version', then rerun ./install.sh; NVM default stays unchanged."
  pi_supported=0
fi
if (( pi_supported )); then
  if npm list --global --depth=0 @mariozechner/pi-coding-agent >/dev/null 2>&1; then
    npm uninstall --global @mariozechner/pi-coding-agent
  fi
  # NPM Pi can live outside active NVM prefix; detect its bin symlink too.
  pi_path=$(command -v pi || true)
  while [[ -n "$pi_path" && -L "$pi_path" ]]; do
    pi_target=$(readlink "$pi_path")
    if [[ "$pi_target" == /* ]]; then
      pi_path=$pi_target
    else
      pi_path="${pi_path:h}/$pi_target"
    fi
  done
  if npm list --global --depth=0 @earendil-works/pi-coding-agent >/dev/null 2>&1 ||
    [[ -z "$pi_path" ||
      "$pi_path" == */node_modules/@earendil-works/pi-coding-agent/* ||
      "$pi_path" == */node_modules/@mariozechner/pi-coding-agent/* ]]; then
    # Keep upstream installer from auto-launching Pi; setup prints launch steps.
    curl -fsSL https://pi.dev/install.sh | sh | tee
    rehash
  fi
  npm_config_fund=false pi update --all
fi

preserve_local_zsh

link_config "$ROOT/zsh" "$ZSH_DIR"
if [[ ! -f "$PLUGIN_SELECTION" ]]; then
  mkdir -p "${PLUGIN_SELECTION:h}"
  : > "$PLUGIN_SELECTION"
  for plugin in "${selected_zsh_plugins[@]}"; do
    print -r -- "$plugin" >> "$PLUGIN_SELECTION"
  done
  print "Saved Zsh plugin choices: $PLUGIN_SELECTION"
fi
program_selected ghostty && link_config "$ROOT/ghostty/config.ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
program_selected herdr && link_config "$ROOT/herdr/config.toml" "$CONFIG_HOME/herdr/config.toml"
link_config "$ROOT/nvim" "$NVIM_DIR"
link_config "$ROOT/superfile/config.toml" "$CONFIG_HOME/superfile/config.toml"
link_config "$ROOT/superfile/hotkeys.toml" "$CONFIG_HOME/superfile/hotkeys.toml"
link_config "$ROOT/superfile/themes/tokyo-night.toml" \
  "$CONFIG_HOME/superfile/theme/tokyo-night.toml"
link_config "$ROOT/bootstrap/zshenv" "$HOME/.zshenv"

if (( is_update )); then
  if (( pi_supported )); then
    trace 'Update completed. Have fun!'
  else
    trace 'Update completed; Pi update skipped.'
  fi
else
  trace 'Install complete.'
  if (( pi_supported == 0 )); then
    print "Next: run nvm install $node_version && nvm use $node_version, then rerun ./install.sh to install Pi."
  elif program_selected ghostty && program_selected herdr; then
    print 'Next: open Ghostty, run herdr, then start a Pi session in Herdr.'
  elif program_selected ghostty; then
    print 'Next: open Ghostty, then start a Pi session with pi.'
  elif program_selected herdr; then
    print 'Next: run herdr, then start a Pi session in Herdr.'
  else
    print 'Next: start a Pi session with pi in your terminal.'
  fi
  if program_selected handy; then
    print 'Then: open Handy and grant microphone and accessibility permissions.'
  fi
fi
