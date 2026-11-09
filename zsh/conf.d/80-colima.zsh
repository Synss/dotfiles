command -v colima >/dev/null || return 0
colima status &>/dev/null && return 0

() {
  local out
  out=$(colima start 2>&1) || print -ru2 -- "$out"
}
