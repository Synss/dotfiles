#!/usr/bin/env bash

set -euo pipefail

if command -v just >/dev/null 2>&1; then
    just "$@"
    exit 0
fi

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

curl --proto '=https' --tlsv1.2 -sSf -L https://just.systems/install.sh \
    | bash -s -- --to "$tmp_dir" >/dev/null
"$tmp_dir/just" "$@"
