command -v jj >/dev/null && command -v gh >/dev/null || return 0

# Usage:
#   jj-pr feature-x --fill
jj-pr() {
  local name=${1:?bookmark name}
  shift
  jj git push --bookmark "$name" && gh pr create --head "$name" "$@"
}
