command -v bazel >/dev/null || return 0

alias bzllock="bazel mod deps --lockfile_mode=update"
command -v jq >/dev/null && alias jqresults="jq '.. | objects | select(has(\"results\") and (.results | length > 0)) | .results'"

alias -g XB="':(exclude)MODULE.bazel.lock'"
