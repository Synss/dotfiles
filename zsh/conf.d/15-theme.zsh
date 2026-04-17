if command -v jq >/dev/null && [[ -f "${ZDOTDIR}/../vim/theme-config.json" ]]; then
	export LIGHT_THEME=$(jq -r '.light' "${ZDOTDIR}/../vim/theme-config.json")
	export DARK_THEME=$(jq -r '.dark' "${ZDOTDIR}/../vim/theme-config.json")
fi
