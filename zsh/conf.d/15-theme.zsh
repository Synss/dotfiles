_theme_config="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/theme-config.json"
if command -v jq >/dev/null && [[ -f "${_theme_config}" ]]; then
	export LIGHT_THEME=$(jq -r '.light' "${_theme_config}")
	export DARK_THEME=$(jq -r '.dark' "${_theme_config}")
fi
unset _theme_config
