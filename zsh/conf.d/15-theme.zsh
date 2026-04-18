if command -v jq >/dev/null && [[ -f "${DOTFILES_ZSH}/../vim/theme-config.json" ]]; then
	export LIGHT_THEME=$(jq -r '.light' "${DOTFILES_ZSH}/../vim/theme-config.json")
	export DARK_THEME=$(jq -r '.dark' "${DOTFILES_ZSH}/../vim/theme-config.json")
fi
