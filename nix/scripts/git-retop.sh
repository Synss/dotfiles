# shellcheck shell=sh
set -eu
if [ $# -eq 0 ]; then
  echo "usage: git retop <base-branch>" >&2
  exit 1
fi
branch="$1"
git fetch origin "$branch:$branch"
git rebase "$branch"
