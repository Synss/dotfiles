command -v delta >/dev/null || return 0

# Help delta picking light or dark themes
if [[ -n "$COLORFGBG" ]] && [[ ${COLORFGBG##*;} -lt 8 ]]; then
	export DELTA_FEATURES=dark
else
	export DELTA_FEATURES=light
fi
