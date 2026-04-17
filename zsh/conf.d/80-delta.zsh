command -v delta >/dev/null || return 0

delta() {
  local theme="${DARK_THEME}"
  if [[ -n "${NVIM}" && -f "${NVIM}.theme" ]]; then
    [[ "$(< "${NVIM}.theme")" == "light" ]] && theme="${LIGHT_THEME}"
  fi
  command delta --features="$theme" "$@"
}
