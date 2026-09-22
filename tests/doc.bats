#!/usr/bin/env bats

# Run with `nix develop --command bats ./tests/doc.bats`.

setup() {
	bats_load_library 'bats-assert'
	bats_load_library 'bats-file'
	bats_load_library 'bats-support'

	DIR="$(cd "$BATS_TEST_DIRNAME" >/dev/null 2>&1 && pwd)"
	PATH="$DIR/..:$PATH"
	DOC="./bin/doc.pl $DIR/../docs/"
}

assert_same_output() {
	run $1
	local first_output="$output"

	run $2
	assert_equal "$output" "$first_output"
}

_mock_glow() {
	local tmp_bin="$BATS_TEST_TMPDIR/bin"
	mkdir -p "$tmp_bin"
	cat >"$tmp_bin/glow" <<-'EOF'
		#!/usr/bin/env bash
		#
		# Glow requires a TTY.
		cat "${@: -1}"
	EOF
	chmod +x "$tmp_bin/glow"
	PATH="$tmp_bin:$PATH"
}

@test 'doc.pl is executable' {
	assert_file_executable ./bin/doc.pl
}

@test '-h and --help show the help' {
	run $DOC --help
	assert_success
	assert_output --partial 'usage: '

	run $DOC -h
	assert_success
	assert_same_output "$DOC --help" "$DOC -h"
}

@test '-l and no argument shows the available docs' {
	run $DOC -l
	assert_success
	assert_output --regexp $'(^|\n)nvim[[:space:]]+Neovim.*($|\n)'
	assert_output --regexp $'(^|\n)jj[[:space:]]+JJ.*($|\n)'

	assert_same_output "$DOC -l" "$DOC"
}

@test 'show doc' {
	_mock_glow
	run $DOC jj
	assert_success
	assert_output --partial 'JJ'
}

@test '-k requires a pattern arg' {
	run $DOC -k
	assert_failure 2
	assert_output --partial "-k requires a pattern"
}

@test '-k pattern no match' {
	run $DOC -k asdf
	assert_failure 1
}

@test '-k pattern matches' {
	run $DOC -k jj
	assert_success
	assert_output --partial 'JJ'
	assert_output --partial 'jj'
}

@test 'invalid arguments fails' {
	run $DOC asdf
	assert_failure 1
}

@test 'unknown option fails' {
	run $DOC -x
	assert_failure 2
}
