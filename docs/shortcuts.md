# Keyboard shortcuts

This reference covers shortcuts configured by these dotfiles and the Ghostty,
Herdr, and Neovim defaults most likely to conflict. Key notation means **press
keys in sequence** unless written as a chord. For example, `Ctrl+B`, then `T`
opens a Herdr tab; `Ctrl+Option+H` is one chord.

For Spanish ISO layout guidance, see [Spanish ISO keyboard shortcuts](../README.md#spanish-iso-keyboard-shortcuts).
Bracketed letters in labels are mnemonics, not keys to type.

## Ghostty

### Dotfiles bindings

| Shortcut | Action |
| --- | --- |
| `Shift+Insert` | Paste from clipboard |
| `Ctrl+Insert` | Copy to clipboard |
| `Shift+Enter` | Send modified Enter (`CSI-u`) to terminal app |
| `⌘Option+Shift+Arrow` | Resize Ghostty split (dotfiles binding) |

### Common macOS defaults

| Shortcut | Action |
| --- | --- |
| `⌘c` / `⌘v` | [c]opy / paste |
| `⌘t` / `⌘n` | New [t]ab / new wi[n]dow |
| `⌘w` / `⌘W` | Close surface / close [W]indow |
| `⌘d` / `⌘D` | Split right / split [D]own |
| `⌘Shift+Enter` | Zoom split |
| `⌘1`–`⌘8` / `⌘9` | Select tab 1–8 / last tab |
| `Ctrl+tab` / `Ctrl+Shift+tab` | Previous [tab] / next [TAB] |
| `⌘Option+Arrow` | Focus Ghostty split |
| `⌘Ctrl+Arrow` | Default split resize (overridden by dotfiles) |

Other Ghostty defaults that can capture direct `⌘` proposals:

| Shortcut | Default action |
| --- | --- |
| `⌘↑` / `⌘↓` / `⌘Shift+↑` / `⌘Shift+↓` | Jump to prompt |
| `⌘[` / `⌘]` | Previous / next Ghostty split |
| `⌘Option+W` / `⌘Option+Shift+W` | Close tab / close all windows |
| `⌘Shift+P` | Command palette |
| `⌘F` / `⌘G` / `⌘Shift+G` | Search / next / previous search result |
| `⌘Q` / `⌘K` | Quit Ghostty / clear screen |
| `⌘Shift+T` / `⌘Z` / `⌘Shift+Z` | Undo / undo / redo |
| `⌘A` / `⌘Option+I` | Select all / inspector |
| `⌘Ctrl+F` / `⌘Shift+V` | Full screen / paste from selection |

Dotfiles unbind the default `⌘Ctrl+Arrow` resize keys and replace them with
`⌘Option+Shift+Arrow`. Herdr uses separate `Ctrl+Option` shortcuts, so Ghostty
keeps control of its own tabs and splits.

Run `ghostty +list-keybinds --default` to inspect defaults for your installed
Ghostty version.

## Herdr

**Prefix:** `Ctrl+B`, then an action key. Run `prefix+?` inside Herdr to see
active bindings.

| Shortcut | Action |
| --- | --- |
| `prefix+t` | New [t]ab |
| `prefix+shift+t` | Close [t]ab |
| `prefix+p` / `prefix+n` | [p]revious / [n]ext tab |
| `prefix+1..9` | Switch tab |
| `prefix+h/j/k/l` | Focus pane left / down / up / right |
| `prefix+d` / `prefix+shift+d` | Split right / split [d]own |
| `prefix+z` / `prefix+x` | Zoom / close pane |
| `prefix+shift+p` | Workspace [p]icker |
| `prefix+w` / `prefix+shift+w` | New / close workspace |
| `prefix+shift+e` / `prefix+shift+a` / `prefix+shift+x` | Rename tab / workspace / pane |
| `prefix+q` | Detach; keep session running |

Direct shortcuts use `Ctrl+Option` on macOS (`alt` in Herdr config):

| Shortcut | Action |
| --- | --- |
| `Ctrl+Option+h/j/k/l` | Focus pane left / down / up / right |
| `Ctrl+Option+p/n` | [p]revious / [n]ext tab |
| `Ctrl+Option+t` | New [t]ab |
| `Ctrl+Option+d` / `Ctrl+Option+Shift+d` | Split right / split down |
| `Ctrl+Option+z` | [z]oom pane |

These assignments replace conflicting Herdr defaults: new tab moves from
`prefix+c` to `prefix+t`; split right/down move from `prefix+v` / `prefix+minus`
to `prefix+d` / `prefix+shift+d`; and close tab moves to `prefix+shift+t`.
Workspace picker, new workspace, and close workspace use `prefix+shift+p`,
`prefix+w`, and `prefix+shift+w`. Rename tab, workspace, and pane move to
`prefix+shift+e/a/x` to free the reused default bindings.

## Zsh

When `zsh-vi-mode` is enabled, `Esc` enters command mode and `i` returns to
insert mode.

| Shortcut | Action |
| --- | --- |
| `Up` / `Down` | Search command history by the text already typed |
| `Ctrl+Left` / `Ctrl+Right` | Move one word backward / forward |
| `Ctrl+f` | Open the FZF [f]ile picker |
| `Ctrl+s` | Toggle auto[s]uggestions |

The Zsh hook disables XON/XOFF so `Ctrl+s` reaches ZLE instead of pausing
terminal output. `Ctrl+q` no longer resumes XON/XOFF-paused output.

## Neovim

**Leader:** `Space`. For example, `<Space>sf` means press Space, then s,
then f. Which-key shows available leader groups after you press Space.

### Core

| Shortcut | Action |
| --- | --- |
| `Ctrl+h/j/k/l` | Focus split left / down / up / right |
| `Esc` | Clear search highlight in Normal mode |
| `Esc Esc` | Leave Terminal mode; press `i` to resume terminal input (press Esc twice quickly) |
| `<Space>e` | `[e]xplorer`: open Neo-tree and reveal current file |
| `<Space>q` | Put diagnostics in the location list |
| `<Space>f` | `[f]ormat` current buffer |
| `y` / `p` | Yank / paste using the system clipboard |

### Telescope

`<Space>s` starts the search group:

| Shortcut | Action |
| --- | --- |
| `<Space><Space>` | Find buffers |
| `<Space>sh` / `<Space>sk` | [S]earch [H]elp / [K]eymaps |
| `<Space>sf` / `<Space>sg` | [S]earch [F]iles / [G]rep |
| `<Space>sw` / `<Space>sd` | Search current [W]ord / [D]iagnostics |
| `<Space>sr` / `<Space>s.` | [R]esume picker / recent files |
| `<Space>sc` / `<Space>ss` | [S]earch [C]ommands / [S]elect picker |
| `<Space>s/` / `<Space>/` | Grep open files / fuzzy-search current buffer |
| `<Space>sn` | [S]earch [N]eovim config files |

### Git (when Gitsigns attaches)

| Shortcut | Action |
| --- | --- |
| `<Space>hn` / `<Space>hP` | Next / previous changed hunk |
| `<Space>hs` / `<Space>hr` | Stage / reset hunk |
| `<Space>hS` / `<Space>hR` | Stage / reset buffer |
| `<Space>hp` / `<Space>hi` | Preview hunk / inline preview |
| `<Space>hb` | Blame line |
| `<Space>hd` / `<Space>hD` | Diff against index / last commit |
| `<Space>hQ` / `<Space>hq` | Hunk list for repo / current file |
| `<Space>tb` / `<Space>tw` | Toggle blame / word diff |
| `ih` | Select inside hunk in operator or Visual mode |

### LSP and completion

LSP shortcuts are available after an LSP client attaches to the buffer:

| Shortcut | Action |
| --- | --- |
| `grn` / `gra` | Rename / code action |
| `grD` / `grr` | Declaration / references |
| `gri` / `grd` / `grt` | Implementation / definition / type definition |
| `gO` / `gW` | Document / workspace symbols |
| `<Space>th` | Toggle inlay hints when supported |

In Blink completion menus: `Ctrl+Y` accepts, `Ctrl+N/P` moves, `Ctrl+Space`
shows docs, `Ctrl+E` dismisses, and `Ctrl+K` shows signature help. `Tab` and
`Shift+Tab` move through snippet placeholders.

### Neo-tree

The Neo-tree window has its own mappings. Use `gh` for help; symbol-key defaults
are disabled in favor of letter sequences for Spanish ISO layouts.

| Shortcut | Action |
| --- | --- |
| `<Enter>` / `<Space>` | Open item / expand or collapse node |
| `a` / `A` | [a]dd file/path / [A]dd directory |
| `r` / `d` | [r]ename / [d]elete |
| `T` / `u` / `U` | Trash / undo trash / restore |
| `c` / `m` | [c]opy / [m]ove to path |
| `y` / `x` / `p` | Copy / cut / paste with Neo-tree clipboard |
| `H` / `f` | Toggle hidden / filter |
| `gf` / `gs` | Fuzzy find / fuzzy sort |
| `gp` / `gn` | Previous / next Git-modified file |
| `gr` | Set root |
| `gP` / `gN` | Previous / next Neo-tree source |
| `P` / `l` | Preview / focus preview |
| `C` / `z` / `R` | Close node / collapse all / refresh |
| `Backspace` | Navigate up |
| `S` / `s` / `t` | Open split / vertical split / new tab |
| `q` | Close Neo-tree window |

Neo-tree mappings are available after `vim.pack` installs the plugin. Built-in
Neovim motions and commands are not listed here.
