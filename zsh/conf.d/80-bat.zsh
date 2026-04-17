command -v bat >/dev/null || command -v batcat >/dev/null || return 0

bat() {
  local theme="${DARK_THEME}"
  if [[ -n "${NVIM}" && -f "${NVIM}.theme" ]]; then
    [[ "$(< "${NVIM}.theme")" == "light" ]] && theme="${LIGHT_THEME}"
  fi
  local cmd
  if command -v bat >/dev/null 2>&1; then cmd=bat; else cmd=batcat; fi
  command "$cmd" --theme="$theme" "$@"
}

alias cat="bat --paging=never"
alias nl="bat --number"
alias -g -- -h="-h 2>&1 | bat --language=help --style=plain"
alias -g -- --help="--help 2>&1 | bat --language=help --style=plain"

export MANPAGER="$(command -v bat) -plman"
