command -v glow >/dev/null || return 0

DOTFILES_DOC="${DOTFILES_ZSH:h}/docs"

doc() {
	local theme="${DARK_THEME}"
	if [[ -n "${NVIM}" && -f "${NVIM}.theme" ]]; then
		[[ "$(<"${NVIM}.theme")" == "light" ]] && theme="${LIGHT_THEME}"
	fi
	GLOW_STYLE="${DOTFILES_ZSH}/glow-styles/${theme}.json" "${DOTFILES_ZSH:h}/bin/doc.pl" "$DOTFILES_DOC" "$@"
}
