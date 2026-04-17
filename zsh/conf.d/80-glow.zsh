command -v glow >/dev/null || return 0

glow() {
  local theme="${DARK_THEME}"
  if [[ -n "${NVIM}" && -f "${NVIM}.theme" ]]; then
    [[ "$(< "${NVIM}.theme")" == "light" ]] && theme="${LIGHT_THEME}"
  fi
  local style="${ZDOTDIR}/../_config/glow/styles/${theme}.json"
  command glow --style "$style" --pager "$@"
}
