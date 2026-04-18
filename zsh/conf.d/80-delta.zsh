command -v delta >/dev/null || return 0

delta() {
  local theme="${DARK_THEME}"
  local mode="--dark"
  if [[ -n "${NVIM}" && -f "${NVIM}.theme" ]]; then
    if [[ "$(< "${NVIM}.theme")" == "light" ]]; then
      theme="${LIGHT_THEME}"
      mode="--light"
    fi
  fi
  command delta --syntax-theme="$theme" "$mode" "$@"
}
