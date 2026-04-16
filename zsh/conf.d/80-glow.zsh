command -v glow >/dev/null || return 0

__GLOW_STYLE_DIR="$(readlink -f "$(dirname "$0")/../../_config/glow/styles/")"

# Pick light or dark themes
if [[ -n "$COLORFGBG" ]] && [[ ${COLORFGBG##*;} -lt 8 ]]; then
    __GLOW_STYLE="$__GLOW_STYLE_DIR/gruvbox-dark.json"
else
    __GLOW_STYLE="$__GLOW_STYLE_DIR/gruvbox-light.json"
fi

alias glow="glow --style \"$__GLOW_STYLE\" --pager"

unset __GLOW_STYLE_DIR
