# shellcheck shell=sh
set -eu

is_merged() {
  branch="$1" base="$2"
  if git merge-base --is-ancestor "$branch" "$base" 2>/dev/null; then
    return 0
  fi
  count=$(git rev-list --count "$base..$branch" 2>/dev/null || echo 0)
  cherry=$(git cherry "$base" "$branch" 2>/dev/null)
  [ "$count" -le 30 ] && ! echo "$cherry" | grep -q '^+'
}

parse_args() {
  dry_run=0
  base=""
  for arg in "$@"; do
    case "$arg" in
      --dry-run | -n) dry_run=1 ;;
      *) base="$arg" ;;
    esac
  done
  if [ -z "$base" ]; then
    echo "usage: git sweep [-n|--dry-run] <base-branch>" >&2
    exit 1
  fi
}

main() {
  parse_args "$@"

  tmp=$(mktemp)
  trap 'rm -f "$tmp"' EXIT
  git for-each-ref --format='%(refname:short)' refs/heads/ | grep -v "^$base$" > "$tmp" || true
  while read -r branch; do
    is_merged "$branch" "$base" || continue
    if [ "$dry_run" -eq 1 ]; then
      echo "$branch"
    else
      git branch -D "$branch"
    fi
  done < "$tmp"
}

main "$@"
