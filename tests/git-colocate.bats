#!/usr/bin/env bats

# Run with `nix develop --command bats ./tests/git-colocate.bats`.

setup() {
	bats_load_library 'bats-assert'
	bats_load_library 'bats-file'
	bats_load_library 'bats-support'
	load 'bats/namespace'

	export GIT_CONFIG_GLOBAL=/dev/null
	export JJ_CONFIG=/dev/null

	DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"

	binroot="$(mktemp -d)"
	colocate="$binroot/git-colocate"
	_mk_colocate "$colocate"

	gitroot="$(mktemp -d)"
	cd "$gitroot" || exit 1
	_git_init "$colocate"
}

teardown() {
	rm -rf "$binroot"
	rm -rf "$gitroot"
}

_mk_colocate() {
	local colocate=$1

	echo '#!/usr/bin/env ruby' >"$colocate"
	cat "$DIR/../nix/scripts/git_colocate.rb" >>"$colocate"
	chmod +x "$colocate"
}

_git_init() {
	local colocate="$1"

	git init 2>/dev/null
	git config --local user.name x
	git config --local user.email x@example.com
	git config --local alias.colocate "!$colocate"
	git commit --allow-empty -m'root commit'
}

@test 'colocate is executable' {
	assert_file_executable "$colocate"
}

@test 'colocate basic logic' {
	assert_not_exists '_untracked'
	assert_not_exists '.jj'
	assert_dir_exists '.git'

	run git colocate
	assert_success

	assert_dir_exists '_untracked'
	assert_dir_exists '.git'
	assert_dir_exists '.jj'

	assert_file_contains '.git/info/exclude' '^_untracked$'
}

@test 'colocate moves uncommitted files' {
	touch 'a file'
	mkdir -p 'a directory'
	touch 'a directory/a nested file'

	run git colocate
	assert_success

	assert_file_not_exists 'a file'
	assert_file_not_exists 'a directory/a nested file'

	assert_file_exists '_untracked/a file'
	assert_file_exists '_untracked/a directory/a nested file'
}

@test 'colocate leaves committed files' {
	echo 'hello world' >'a file'
	git add 'a file'
	git commit -m'commit one file'

	assert_file_exists 'a file'

	run git colocate
	assert_success

	assert_file_exists 'a file'
	assert_file_not_exists '_untracked/a file'
}

@test 'colocate leaves gitignored files' {
	echo 'hello world' >'a file'
	echo 'a file' >.gitignore
	git add .gitignore
	git commit -m 'ignore one file'

	assert_file_exists 'a file'

	run git colocate
	assert_success

	assert_file_exists 'a file'
	assert_file_not_exists '_untracked/a file'
}

@test 'colocate from a subdirectory' {
	touch 'a file'
	mkdir -p 'a directory'
	touch 'a directory/a nested file'

	pushd 'a directory' || exit 1
	run git colocate
	assert_success
	popd || exit 1

	assert_file_not_exists 'a file'
	assert_file_not_exists 'a directory/a nested file'

	assert_file_exists '_untracked/a file'
	assert_file_exists '_untracked/a directory/a nested file'
}

@test 'colocate creates the exclude file if missing' {
	rm '.git/info/exclude'
	assert_file_not_exists '.git/info/exclude'

	run git colocate
	assert_success

	assert_file_exists '.git/info/exclude'
	assert_file_contains '.git/info/exclude' '^_untracked$'
}

@test 'colocate twice is an error' {
	run git colocate
	assert_success

	run git colocate
	assert_failure
	assert_output --partial 'already colocated'
}

@test 'colocate bails out instead of overwriting files' {
	mkdir '_untracked'
	touch '_untracked/a file'
	touch 'a file'

	run git colocate
	assert_failure
	assert_output --partial 'a file'

	assert_file_exists 'a file'
}
