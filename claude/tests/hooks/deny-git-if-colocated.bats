#!/usr/bin/env bats

# Run with `nix develop --command bats deny-git-if-colocated.bats`.

setup_file() {
	repos_root=$(mktemp -d)
	export repos_root

	export gitroot="$repos_root/git"
	mkdir -p "$gitroot"
	pushd "$gitroot" || exit 1
	_git_init
	popd || exit 1

	export colocated="$repos_root/jj-colocated"
	mkdir -p "$colocated"
	pushd "$colocated" || exit 1
	_git_init
	_jj_colocate
	popd || exit 1
}

teardown_file() {
	rm -rf "$repos_root"
}

_git_init() {
	git init
	git config --local user.name x
	git config --local user.email x@example.com
	for msg in $(seq 0 3); do git commit --allow-empty -m "$msg"; done
}

_jj_colocate() {
	jj git init --colocate
}

setup() {
	bats_load_library 'bats-assert'
	bats_load_library 'bats-file'
	bats_load_library 'bats-support'

	DIR="$( cd "$BATS_TEST_DIRNAME" >/dev/null 2>&1 && pwd )"
	hook="$DIR/../../hooks/deny-git-if-colocated.pl"
}

run_hook() {
	run "$hook" < <(_payload "$1")
}

_payload() {
	jq -n --arg command "$1" '{tool_input: {command: $command}}'
}

assert_allow() {
	refute_output
}

assert_deny() {
	local decision
	decision=$(jq -r '.hookSpecificOutput.permissionDecision // empty' <<<"$output")
	[ "$decision" = "deny" ]
}

@test 'hook is executable' {
	assert_file_executable "$hook"
}

# --- git ---

@test 'git: allow \"git status\"' {
	cd "$gitroot" && run_hook "git status"
	assert_allow
}

@test 'git: allow \"git add\"' {
	cd "$gitroot" && run_hook "git add"
	assert_allow
}

@test 'git: allow \"git -C ... add\"' {
	cd "$gitroot" && run_hook "git -C /some/repo add asdf"
	assert_allow
}

@test 'git: allow \"git -c ... commit\"' {
	cd "$gitroot" && run_hook "git -c user.name=x commit"
	assert_allow
}

# --- colocated ---

@test 'colocated: allow \"git status\"' {
	cd "$colocated" && run_hook "git status"
	assert_allow
}

@test 'colocated: deny \"git add\"' {
	cd "$colocated" && run_hook "git add"
	assert_deny
}

@test 'colocated: deny \"git -C ... add\"' {
	cd "$colocated" && run_hook "git -C /some/repo add asdf"
	assert_deny
}

@test 'colocated: deny \"git -c ... commit\"' {
	cd "$colocated" && run_hook "git -c user.name=x commit"
	assert_deny
}
