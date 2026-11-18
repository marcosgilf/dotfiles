# Neovim

`init.lua` combines a generated prefix from `init.lua.tmpl` with Kickstart
configuration below `-- BEGIN LOCAL CONFIG (preserved)`. The renderer regenerates
the prefix and preserves the local section. Put shared settings in the template
above the marker; keep local experiments below it.

The template overrides Kickstart's Section 1 Nerd Font setting and Section 4
Colorscheme setup. It enables Nerd Font icons and uses native highlights from
`../theme/tokyo-night.sh`, instead of installing a theme plugin.

## Language support

Mason installs LSP servers for JavaScript/TypeScript (`ts_ls`), Rust
(`rust_analyzer`), Python (`pyright`), Java (`jdtls`), Lua (`lua_ls`), HTML
(`html`), CSS (`cssls`), and Sass/SCSS (`somesass_ls`). `stylua` installs as a
formatter tool, not an LSP server.

Tree-sitter installs parsers for JavaScript, TypeScript, TSX, Rust, Python,
Java, Lua, HTML, CSS, and SCSS. Upstream `nvim-treesitter` has no parser for
indented `.sass` files; those files still get Sass LSP support.

`jdtls` provides basic Java LSP features. Advanced Java-specific integration
may need `nvim-jdtls` later.
