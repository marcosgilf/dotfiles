# Program records: type|scope|package|name|description|documentation URL|home-relative detection path|optional setting
# Brew formulas use core or optional; casks use optional or ghostty. Add entries to extend those flows.
typeset -ga PROGRAMS=(
  'brew_formula|core|bat|bat|Cat replacement with syntax highlighting.|https://github.com/sharkdp/bat|-'
  'brew_formula|core|eza|eza|Modern replacement for ls.|https://github.com/eza-community/eza|-'
  'brew_formula|core|fd|fd|Fast, user-friendly file finder.|https://github.com/sharkdp/fd|-'
  'brew_formula|core|fzf|fzf|Fuzzy finder for files and command history.|https://github.com/junegunn/fzf|-'
  'brew_formula|core|neovim|Neovim|Extensible text editor.|https://neovim.io/|-'
  'brew_formula|core|nvm|nvm|Node.js version manager.|https://github.com/nvm-sh/nvm|-'
  'brew_formula|core|ripgrep|ripgrep|Fast recursive text search.|https://github.com/BurntSushi/ripgrep|-'
  'brew_formula|core|starship|Starship|Cross-shell prompt.|https://starship.rs/|-'
  'brew_formula|core|superfile|Superfile|Terminal file manager with custom hotkeys and Tokyo Night theme.|https://superfile.dev/|-'
  'brew_formula|core|zoxide|zoxide|Frecency-based directory navigation.|https://github.com/ajeetdsouza/zoxide|-'
  'brew_formula|core|zsh|Zsh|Interactive shell.|https://www.zsh.org/|-'
  'brew_formula|optional|bun|Bun|JavaScript runtime, package manager, test runner, and bundler.|https://bun.sh/|.bun/bin/bun'
  'brew_formula|optional|herdr|Herdr|Terminal multiplexer for persistent workspaces and coding agents.|https://github.com/herdrdev/herdr|-'
  'brew_cask|optional|ghostty|Ghostty|GPU-accelerated terminal.|https://ghostty.org/|-'
  'brew_cask|optional|handy|Handy|Offline speech-to-text app; first launch needs microphone and accessibility permissions.|https://github.com/cjpais/Handy|-'
  'brew_cask|ghostty|font-jetbrains-mono-nerd-font|JetBrainsMono Nerd Font|Nerd Font installed with Ghostty.|https://github.com/ryanoasis/nerd-fonts|-'
  'zsh_plugin|plugins|zsh-users/zsh-autosuggestions|zsh-autosuggestions|Suggests commands from history as you type.|https://github.com/zsh-users/zsh-autosuggestions|-'
  'zsh_plugin|plugins|zsh-users/zsh-history-substring-search|zsh-history-substring-search|Searches history by typed text with Up/Down.|https://github.com/zsh-users/zsh-history-substring-search|-'
  'zsh_plugin|plugins|jeffreytse/zsh-vi-mode|zsh-vi-mode|Adds Vim-style command-line editing modes.|https://github.com/jeffreytse/zsh-vi-mode|-'
  'zsh_plugin|plugins|zdharma-continuum/fast-syntax-highlighting|fast-syntax-highlighting|Highlights shell syntax while editing commands.|https://github.com/zdharma-continuum/fast-syntax-highlighting|-'
  'nvm_runtime|runtime|22|Node.js|JavaScript runtime; fresh installs use version 22, and Pi needs version 22.19 or newer.|https://nodejs.org/|-'
  'managed_app|runtime|pi|Pi|Terminal coding agent installed with its managed installer.|https://github.com/earendil-works/pi|-|22.19'
  'catalog|editor|LazyVim|LazyVim|Opinionated Neovim setup and plugin collection.|https://www.lazyvim.org/|-'
  'catalog|editor|lazy.nvim|lazy.nvim|Plugin manager used by LazyVim.|https://github.com/folke/lazy.nvim|-'
  'catalog|editor|nvim-lspconfig|nvim-lspconfig|Neovim language server configurations.|https://github.com/neovim/nvim-lspconfig|-'
  'catalog|editor|nvim-treesitter|nvim-treesitter|Treesitter parsing and highlighting for Neovim.|https://github.com/nvim-treesitter/nvim-treesitter|-'
  'catalog|editor|blink.cmp|blink.cmp|Completion engine for Neovim.|https://github.com/Saghen/blink.cmp|-'
  'catalog|editor|gitsigns.nvim|gitsigns.nvim|Git change indicators for Neovim.|https://github.com/lewis6991/gitsigns.nvim|-'
  'catalog|superfile|superfile-hotkeys|Vim-like Superfile hotkeys|Uses h/j/k/l, / search, and familiar copy/paste keys.|https://superfile.dev/configure/custom-hotkeys/|-'
  'catalog|superfile|superfile-zoxide|Superfile Zoxide plugin|Enables frequent-directory navigation with z.|https://superfile.dev/list/plugin-list/|-'
  'catalog|superfile|superfile-theme|Superfile Tokyo Night theme|Uses colors from the shared theme configuration.|https://superfile.dev/configure/custom-theme/|-'
)

typeset -g PROGRAM_TYPE='' PROGRAM_SCOPE='' PROGRAM_PACKAGE='' PROGRAM_NAME=''
typeset -g PROGRAM_DESCRIPTION='' PROGRAM_DOCS_URL='' PROGRAM_DETECT_PATH='' PROGRAM_SETTING='-'

read_program() {
  PROGRAM_SETTING='-'
  IFS='|' read -r PROGRAM_TYPE PROGRAM_SCOPE PROGRAM_PACKAGE PROGRAM_NAME \
    PROGRAM_DESCRIPTION PROGRAM_DOCS_URL PROGRAM_DETECT_PATH PROGRAM_SETTING <<< "$1"
  [[ -n "$PROGRAM_SETTING" ]] || PROGRAM_SETTING='-'
  [[ -n "$PROGRAM_TYPE" && -n "$PROGRAM_SCOPE" && -n "$PROGRAM_PACKAGE" &&
    -n "$PROGRAM_NAME" && -n "$PROGRAM_DESCRIPTION" && -n "$PROGRAM_DOCS_URL" &&
    -n "$PROGRAM_DETECT_PATH" ]] || {
    print -u2 -- "Invalid program record: $1"
    return 1
  }
  case "$PROGRAM_TYPE:$PROGRAM_SCOPE" in
    brew_formula:core|brew_formula:optional|brew_cask:optional|brew_cask:ghostty|\
      zsh_plugin:plugins|nvm_runtime:runtime|managed_app:runtime|\
      catalog:editor|catalog:superfile) ;;
    *) print -u2 -- "Unsupported program type or scope: $PROGRAM_TYPE:$PROGRAM_SCOPE"; return 1 ;;
  esac
}
