#!/bin/zsh
set -euo pipefail

readonly ROOT=${0:A:h:h}
source "$ROOT/theme/tokyo-night.sh"
source "$ROOT/config/programs.zsh"

render() {
  input=$1
  output=$2
  mkdir -p "$(dirname -- "$output")"
  sed \
    -e "s|@THEME_NAME@|$THEME_NAME|g" \
    -e "s|@HERDR_THEME@|$HERDR_THEME|g" \
    -e "s|@NVIM_COLORSCHEME@|$NVIM_COLORSCHEME|g" \
    -e "s|@BACKGROUND@|$BACKGROUND|g" \
    -e "s|@DARK_BACKGROUND@|$DARK_BACKGROUND|g" \
    -e "s|@DARKER_BACKGROUND@|$DARKER_BACKGROUND|g" \
    -e "s|@LIGHTER_BACKGROUND@|$LIGHTER_BACKGROUND|g" \
    -e "s|@FOREGROUND@|$FOREGROUND|g" \
    -e "s|@DARK_FOREGROUND@|$DARK_FOREGROUND|g" \
    -e "s|@LIGHT_FOREGROUND@|$LIGHT_FOREGROUND|g" \
    -e "s|@BRIGHT_FOREGROUND@|$BRIGHT_FOREGROUND|g" \
    -e "s|@MUTED@|$MUTED|g" \
    -e "s|@RED@|$RED|g" \
    -e "s|@YELLOW@|$YELLOW|g" \
    -e "s|@ORANGE@|$ORANGE|g" \
    -e "s|@GREEN@|$GREEN|g" \
    -e "s|@CYAN@|$CYAN|g" \
    -e "s|@BLUE@|$BLUE|g" \
    -e "s|@MAGENTA@|$MAGENTA|g" \
    -e "s|@BROWN@|$BROWN|g" \
    -e "s|@BRIGHT_RED@|$BRIGHT_RED|g" \
    -e "s|@BRIGHT_YELLOW@|$BRIGHT_YELLOW|g" \
    -e "s|@BRIGHT_GREEN@|$BRIGHT_GREEN|g" \
    -e "s|@BRIGHT_CYAN@|$BRIGHT_CYAN|g" \
    -e "s|@BRIGHT_BLUE@|$BRIGHT_BLUE|g" \
    -e "s|@BRIGHT_MAGENTA@|$BRIGHT_MAGENTA|g" \
    -e "s|@SELECTION@|$SELECTION|g" \
    -e "s|@SELECTION_FOREGROUND@|$SELECTION_FOREGROUND|g" \
    -e "s|@SELECTION_BACKGROUND@|$SELECTION_BACKGROUND|g" \
    -e "s|@ACCENT@|$ACCENT|g" \
    "$input" > "$output"
}

render "$ROOT/ghostty/config.ghostty.tmpl" "$ROOT/ghostty/config.ghostty"
render "$ROOT/herdr/config.toml.tmpl" "$ROOT/herdr/config.toml"
render "$ROOT/nvim/lua/plugins/tokyo-night.lua.tmpl" "$ROOT/nvim/lua/plugins/tokyo-night.lua"
render "$ROOT/superfile/config.toml.tmpl" "$ROOT/superfile/config.toml"
render "$ROOT/superfile/themes/tokyo-night.toml.tmpl" "$ROOT/superfile/themes/tokyo-night.toml"
render "$ROOT/zsh/starship.toml.tmpl" "$ROOT/zsh/starship.toml"

render_brewfile() {
  {
    print '# Generated from config/programs.zsh. Do not edit.'
    for record in "${PROGRAMS[@]}"; do
      read_program "$record"
      if [[ "$PROGRAM_TYPE" == brew_formula && "$PROGRAM_SCOPE" == core ]]; then
        print "brew \"$PROGRAM_PACKAGE\""
      fi
    done
  } > "$ROOT/Brewfile"
}

render_catalog() {
  local catalog_tmp readme_tmp scope heading record found
  catalog_tmp=$(mktemp "${TMPDIR:-/tmp}/dotfiles-catalog.XXXXXX")
  readme_tmp=$(mktemp "$ROOT/README.md.XXXXXX")
  {
    for scope in core optional ghostty plugins runtime editor superfile; do
      case "$scope" in
        core) heading='Core tools' ;;
        optional) heading='Optional tools' ;;
        ghostty) heading='Installed with Ghostty' ;;
        plugins) heading='Zsh plugins' ;;
        runtime) heading='Runtime-managed tools' ;;
        editor) heading='Neovim plugins' ;;
        superfile) heading='Superfile integrations' ;;
      esac
      found=0
      for record in "${PROGRAMS[@]}"; do
        read_program "$record"
        [[ "$PROGRAM_SCOPE" == "$scope" ]] && found=1
      done
      (( found )) || continue
      print "### $heading"
      for record in "${PROGRAMS[@]}"; do
        read_program "$record"
        [[ "$PROGRAM_SCOPE" == "$scope" ]] || continue
        print -- "- [$PROGRAM_NAME]($PROGRAM_DOCS_URL) — $PROGRAM_DESCRIPTION"
      done
      print
    done
    print '### Theme'
    print -- "- [$THEME_LABEL]($THEME_DOCS_URL) — $THEME_DESCRIPTION"
  } > "$catalog_tmp"
  awk -v catalog="$catalog_tmp" '
    $0 == "<!-- BEGIN GENERATED PROGRAM CATALOG -->" {
      print
      while ((getline line < catalog) > 0) print line
      close(catalog)
      started = 1
      skipping = 1
      next
    }
    $0 == "<!-- END GENERATED PROGRAM CATALOG -->" {
      skipping = 0
      ended = 1
      print
      next
    }
    !skipping { print }
    END { if (!started || !ended) exit 1 }
  ' "$ROOT/README.md" > "$readme_tmp"
  chmod 644 "$readme_tmp"
  mv "$readme_tmp" "$ROOT/README.md"
  rm -f "$catalog_tmp"
}

render_brewfile
render_catalog
