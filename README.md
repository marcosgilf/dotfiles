# macOS dotfiles

Opinionated macOS development environment with one shared Tokyo Night theme.

Application configs live in top-level directories (`zsh/`, `nvim/`, `ghostty/`,
`herdr/`, `superfile/`, and `pi/`). Setup scripts, tests, and shared theme data
stay separate. Installer handles app-specific paths and backs up existing
configs before it links them.

## Included tools

<!-- BEGIN GENERATED PROGRAM CATALOG -->
### Core tools
- [bat](https://github.com/sharkdp/bat) — Cat replacement with syntax highlighting.
- [eza](https://github.com/eza-community/eza) — Modern replacement for ls.
- [fd](https://github.com/sharkdp/fd) — Fast, user-friendly file finder.
- [fzf](https://github.com/junegunn/fzf) — Fuzzy finder for files and command history.
- [Neovim](https://neovim.io/) — Extensible text editor.
- [nvm](https://github.com/nvm-sh/nvm) — Node.js version manager.
- [ripgrep](https://github.com/BurntSushi/ripgrep) — Fast recursive text search.
- [Starship](https://starship.rs/) — Cross-shell prompt.
- [Superfile](https://superfile.dev/) — Terminal file manager with custom hotkeys and Tokyo Night theme.
- [zoxide](https://github.com/ajeetdsouza/zoxide) — Frecency-based directory navigation.
- [Zsh](https://www.zsh.org/) — Interactive shell.

### Optional tools
- [Bun](https://bun.sh/) — JavaScript runtime, package manager, test runner, and bundler.
- [Herdr](https://github.com/herdrdev/herdr) — Terminal multiplexer for persistent workspaces and coding agents.
- [Ghostty](https://ghostty.org/) — GPU-accelerated terminal.
- [Handy](https://github.com/cjpais/Handy) — Offline speech-to-text app; first launch needs microphone and accessibility permissions.

### Installed with Ghostty
- [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts) — Nerd Font installed with Ghostty.

### Zsh plugins
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) — Suggests commands from history as you type.
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) — Searches history by typed text with Up/Down.
- [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode) — Adds Vim-style command-line editing modes.
- [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) — Highlights shell syntax while editing commands.

### Runtime-managed tools
- [Node.js](https://nodejs.org/) — JavaScript runtime; fresh installs use version 22, and Pi needs version 22.19 or newer.
- [Pi](https://github.com/earendil-works/pi) — Terminal coding agent installed with its managed installer.

### Neovim plugins
- [LazyVim](https://www.lazyvim.org/) — Opinionated Neovim setup and plugin collection.
- [lazy.nvim](https://github.com/folke/lazy.nvim) — Plugin manager used by LazyVim.
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) — Neovim language server configurations.
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) — Treesitter parsing and highlighting for Neovim.
- [blink.cmp](https://github.com/Saghen/blink.cmp) — Completion engine for Neovim.
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) — Git change indicators for Neovim.

### Superfile integrations
- [Vim-like Superfile hotkeys](https://superfile.dev/configure/custom-hotkeys/) — Uses h/j/k/l, / search, and familiar copy/paste keys.
- [Superfile Zoxide plugin](https://superfile.dev/list/plugin-list/) — Enables frequent-directory navigation with z.
- [Superfile Tokyo Night theme](https://superfile.dev/configure/custom-theme/) — Uses colors from the shared theme configuration.

### Theme
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) — Shared dark palette used by Ghostty, Herdr, Neovim, Superfile, and Starship.
<!-- END GENERATED PROGRAM CATALOG -->

Program metadata lives in `config/programs.zsh`. Add a supported Homebrew
formula or cask there; installer, uninstaller, `Brewfile`, and this inventory
use that data. Zsh plugins also use the same records for prompts and loading.
Theme colors and metadata live in `theme/tokyo-night.sh`. Run
`scripts/render-configs.sh` to regenerate `Brewfile`, this inventory, and app
configuration files.

## Install

Requirements: macOS 13+. Install Apple Command Line Tools first if missing;
Git may open the installer prompt on a new Mac:

```sh
xcode-select --install
```

Wait for installation to finish, then clone and run setup. Installer installs
Homebrew if missing.

```sh
git clone https://github.com/marcosgilf/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

Installer:

- installs configured core programs; offers configured optional programs and
  Zsh plugins; preserves saved plugin choices and detects existing plugin
  checkouts on updates
- preserves an existing nvm default/active version; sets Node.js 22 as default
  when no nvm Node is selected
- installs or migrates Pi with its managed installer when needed, then runs
  `pi update --all` when Node.js is 22.19+; warns and skips Pi otherwise
- prints dependency progress and first-install launch steps; reruns report
  `Update completed.`
- renders configuration files from the shared theme
- links managed files into standard macOS config paths
- preserves existing configs as timestamped backups
- preserves untracked local zsh functions under `zsh/functions/local/`
- is safe to run again; it never pulls or overwrites managed repositories

Keep this repository at a stable path because managed symlinks point into it.

## Use

```sh
open -a Ghostty
open -a Handy
herdr
pi
spf
nvim
```

Start a new shell after installation. Neovim plugins install on first launch;
`nvim/lazy-lock.json` records their versions.

## Update

```sh
cd ~/dotfiles
git pull
./install.sh
```

Run `:Lazy sync` inside Neovim when intentionally updating plugins, then commit
`nvim/lazy-lock.json`.

## Test

```sh
./scripts/test-install.sh
```

Smoke test stubs Homebrew, NVM, npm, Pi installer, and Zsh plugins; uses
temporary home directories.

## Privacy boundary

Only portable configuration belongs here. Never add shell history, cloud or
Git credentials, Herdr sessions/logs, local environment files, private keys,
or work-specific commands. Put machine-only functions in
`zsh/functions/local/`; that directory is ignored.
