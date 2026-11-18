# Keyboard shortcuts

This reference covers shortcuts configured by these dotfiles and the Ghostty,
Herdr, and Neovim defaults most likely to conflict. Key notation means **press
keys in sequence** unless written as a chord. For example, `Ctrl+B`, then `C`
is a Herdr prefix binding; `Ctrl+Option+H` is one chord.

For Spanish ISO layout guidance, see [Spanish ISO keyboard shortcuts](../README.md#spanish-iso-keyboard-shortcuts).
Bracketed letters in labels are mnemonics, not keys to type.

## Ghostty

### Dotfiles bindings

| Shortcut | Action |
| --- | --- |
| `Shift+Insert` | Paste from clipboard |
| `Ctrl+Insert` | Copy to clipboard |
| `Shift+Enter` | Send modified Enter (`CSI-u`) to terminal app |

### Common macOS defaults

| Shortcut | Action |
| --- | --- |
| `⌘C` / `⌘V` | Copy / paste |
| `⌘T` / `⌘N` | New tab / new window |
| `⌘W` / `⌘Shift+W` | Close surface / close window |
| `⌘D` / `⌘Shift+D` | Split right / split down |
| `⌘Shift+Enter` | Zoom split |
| `⌘1`–`⌘8` / `⌘9` | Select tab 1–8 / last tab |
| `⌘Shift+[` / `⌘Shift+]` | Previous / next tab |
| `⌘Option+Arrow` | Focus Ghostty split |
| `⌘Ctrl+Arrow` | Resize Ghostty split |

Ghostty defaults keep these `⌘` shortcuts. Herdr uses separate `Ctrl+Option`
shortcuts, so Ghostty keeps control of its own tabs and splits.

Run `ghostty +list-keybinds --default` to inspect defaults for your installed
Ghostty version.

## Herdr

**Prefix:** `Ctrl+B`, then an action key. Run `prefix+?` inside Herdr to see
active bindings.

| Shortcut | Action |
| --- | --- |
| `prefix+c` | New tab |
| `prefix+p` / `prefix+n` | Previous / next tab |
| `prefix+1..9` | Switch tab |
| `prefix+h/j/k/l` | Focus pane left / down / up / right |
| `prefix+v` / `prefix+-` | Split right / split down |
| `prefix+z` / `prefix+x` | Zoom / close pane |
| `prefix+shift+x` | Close tab |
| `prefix+w` | Workspace picker |
| `prefix+shift+n` / `prefix+shift+d` | New / close workspace |
| `prefix+q` | Detach; keep session running |

Direct shortcuts use `Ctrl+Option` on macOS (`alt` in Herdr config):

| Shortcut | Action |
| --- | --- |
| `Ctrl+Option+H/J/K/L` | Focus pane left / down / up / right |
| `Ctrl+Option+P/N` | Previous / next tab |
| `Ctrl+Option+C` | New tab |
| `Ctrl+Option+D` / `Ctrl+Option+Shift+D` | Split right / split down |
| `Ctrl+Option+Z` | Zoom pane |

## Zsh

When `zsh-vi-mode` is enabled, `Esc` enters command mode and `i` returns to
insert mode.

| Shortcut | Action |
| --- | --- |
| `Up` / `Down` | Search command history by the text already typed |
| `Ctrl+Left` / `Ctrl+Right` | Move one word backward / forward |
| `Ctrl+F` | Open the FZF file picker |
| `Ctrl+\` | Toggle autosuggestions |

`Ctrl+\` may be hard to type on Spanish ISO layouts. Consider remapping it to
a letter-based binding if it is inconvenient.

## Neovim

**Leader:** `Space`. For example, `<Space>sf` means press Space, then S,
then F. Which-key shows available leader groups after you press Space.

### Core

| Shortcut | Action |
| --- | --- |
| `Ctrl+H/J/K/L` | Focus split left / down / up / right |
| `Esc` | Clear search highlight in Normal mode |
| `Esc Esc` | Leave Terminal mode; press `i` to resume terminal input (press Esc twice quickly) |
| `<Space>e` | `[E]xplorer`: open Neo-tree and reveal current file |
| `<Space>q` | Put diagnostics in the location list |
| `<Space>f` | `[F]ormat` current buffer |
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
| `[c` / `]c` | Previous / next changed hunk |
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

The Neo-tree window has its own mappings. Press `?` there to see its active help.

| Shortcut | Action |
| --- | --- |
| `<Enter>` / `<Space>` | Open item / expand or collapse node |
| `a` / `A` | [a]dd file/path / [A]dd directory |
| `r` / `d` | [r]ename / [d]elete |
| `T` / `u` / `U` | Trash / undo trash / restore |
| `c` / `m` | [c]opy / [m]ove to path |
| `y` / `x` / `p` | Copy / cut / paste with Neo-tree clipboard |
| `H` / `/` / `f` | Toggle hidden / fuzzy find / filter |
| `P` / `l` | Preview / focus preview |
| `C` / `z` / `R` | Close node / collapse all / refresh |
| `.` / `Backspace` | Set root / navigate up |
| `S` / `s` / `t` | Open split / vertical split / new tab |
| `q` | Close Neo-tree window |

Neo-tree mappings are available after `vim.pack` installs the plugin. Built-in
Neovim motions and commands are not listed here.
