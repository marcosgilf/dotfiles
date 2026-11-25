#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TMP=$(mktemp -d "${TMPDIR:-/tmp}/pi-wrapper-test.XXXXXX")
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

mkdir -p "$TMP/home/.pi/agent/bin" "$TMP/work/repo" "$TMP/work-sibling" "$TMP/zsh-config"
cat > "$TMP/home/.pi/agent/bin/pi" <<'EOF'
#!/bin/sh
printf 'cwd=%s\n' "$PWD"
printf 'profile=%s\n' "$PI_CODING_AGENT_DIR"
printf 'openai=%s\n' "${OPENAI_API_KEY-unset}"
printf 'openrouter=%s\n' "${OPENROUTER_API_KEY-unset}"
printf 'copilot=%s\n' "${COPILOT_GITHUB_TOKEN-unset}"
printf 'radius=%s\n' "${RADIUS_API_KEY-unset}"
printf 'session=%s\n' "${PI_CODING_AGENT_SESSION_DIR-unset}"
printf 'arg=<%s>\n' "$@"
EOF
chmod +x "$TMP/home/.pi/agent/bin/pi"
work_root=$(CDPATH= cd -P "$TMP/work" && pwd -P)
work_repo=$(CDPATH= cd -P "$TMP/work/repo" && pwd -P)
work_sibling=$(CDPATH= cd -P "$TMP/work-sibling" && pwd -P)

assert_contains() {
  printf '%s\n' "$1" | grep -F "$2" >/dev/null || {
    printf 'Missing wrapper output: %s\n' "$2" >&2
    return 1
  }
}

work_output=$(cd -P "$TMP/work/repo" && \
  HOME="$TMP/home" PI_WORK_ROOT="$TMP/work" \
  OPENAI_API_KEY=secret OPENROUTER_API_KEY=secret RADIUS_API_KEY=secret \
  PI_CODING_AGENT_SESSION_DIR=/tmp/other-session COPILOT_GITHUB_TOKEN=kept \
  "$ROOT/zsh/bin/pi" 'arg with spaces')
assert_contains "$work_output" "cwd=$work_repo"
assert_contains "$work_output" "profile=$work_root/.pi/agent"
assert_contains "$work_output" 'openai=unset'
assert_contains "$work_output" 'openrouter=unset'
assert_contains "$work_output" 'radius=unset'
assert_contains "$work_output" 'session=unset'
assert_contains "$work_output" 'copilot=kept'
assert_contains "$work_output" 'arg=<arg with spaces>'

personal_output=$(cd -P "$TMP/work-sibling" && \
  HOME="$TMP/home" PI_WORK_ROOT="$TMP/work" \
  COPILOT_GITHUB_TOKEN=secret RADIUS_API_KEY=secret \
  PI_CODING_AGENT_SESSION_DIR=/tmp/other-session \
  "$ROOT/zsh/bin/pi")
assert_contains "$personal_output" "cwd=$work_sibling"
assert_contains "$personal_output" "profile=$TMP/home/.pi/agent"
assert_contains "$personal_output" 'copilot=unset'
assert_contains "$personal_output" 'radius=unset'
assert_contains "$personal_output" 'session=unset'

printf 'PI_WORK_ROOT="%s"\n' "$TMP/work" > "$TMP/zsh-config/pi.local.zsh"
loaded_root=$(env -i HOME="$TMP/home" ZDOTDIR="$TMP/zsh-config" ROOT="$ROOT" \
  PATH=/usr/bin:/bin \
  /bin/zsh -f -c 'source "$ROOT/zsh/.zshenv"; [[ "${path[1]}" == "$HOME/.local/bin" ]] || exit 1; /usr/bin/env' \
  | grep '^PI_WORK_ROOT=')
[ "$loaded_root" = "PI_WORK_ROOT=$TMP/work" ]

printf 'Pi wrapper tests passed.\n'
