autoload -U colors && colors

typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# expansions in prompt
setopt prompt_subst

__CURRENT_VCS_INFO=
__CURRENT_VCS_VARS_INVALID=1

_parse_git_branch() {
	local branch
	branch=$(git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	[[ -n "$branch" ]] && echo "git:$branch"
}

_parse_jj_info() {
	local bookmark target info
	bookmark=$(jj log -r @ --no-graph -T 'local_bookmarks' 2>/dev/null)
	target=$(jj config get gerrit.default-remote-branch 2>/dev/null)

	info="jj"
	[[ -n "$bookmark" ]] && info="jj:$bookmark"
	[[ -n "$target" ]] && info="${info}→$target"
	echo "$info"
}

_compute_vcs_vars() {
	if command -v jj >/dev/null && jj root >/dev/null 2>&1; then
		__CURRENT_VCS_INFO="$(_parse_jj_info)"
	elif command -v git >/dev/null; then
		__CURRENT_VCS_INFO="$(_parse_git_branch)"
	else
		__CURRENT_VCS_INFO=
	fi
	__CURRENT_VCS_VARS_INVALID=
}

chpwd_functions+='_vcs_chpwd_update'
_vcs_chpwd_update() {
	__CURRENT_VCS_VARS_INVALID=1
}

preexec_functions+='_vcs_preexec_update'
_vcs_preexec_update() {
	case "$(history $HISTCMD)" in
		*git*|*jj*) __CURRENT_VCS_VARS_INVALID=1 ;;
	esac
}

get_vcs_prompt_info() {
	test -n "$__CURRENT_VCS_VARS_INVALID" && _compute_vcs_vars
	test -n "$__CURRENT_VCS_INFO" && echo " [$__CURRENT_VCS_INFO]"
}

# Now set it
if [ ${EUID} -eq 0 ]; then
	PROMPT="%{$fg[red]%}%T %d [%j]%{$fg[yellow]%} %?  %#%_ %{$reset_color%}"
else
	PROMPT="%T %{$fg[green]%}%~%{$fg[yellow]%}"'$(get_vcs_prompt_info)'" %{$reset_color%}%?
%#%_ "
fi

unset __CURRENT_VCS_INFO
unset __CURRENT_VCS_VARS_INVALID
