command -v jj >/dev/null || return 0

# Load jj's completer now; on first use it would re-run compdef and replace this wrapper.
_jj
_jj_with_pr() {
	if ((CURRENT > 2)) && [[ $words[2] == pr ]]; then
		words=(jj-pr "${(@)words[3,-1]}")
		((CURRENT--))
		_normal
	else
		_clap_dynamic_completer_jj "$@"
	fi
}
compdef _jj_with_pr jj
