#!/bin/sh
set -eu

OUTPUT="${1:-packages_apt.txt}"
{
    printf '# Manually installed apt packages (generated %s)\n' "$(date +%F)"
    apt-mark showmanual | sort
} > "$OUTPUT"

echo "Written to $OUTPUT"
