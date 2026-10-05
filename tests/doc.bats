#!/usr/bin/env bats

# Run with `nix develop --command bats ./tests/doc.bats`.

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

_setup_docdir() {
	local docdir="$1"

	cat <<-EOF >"$docdir/lorem ipsum.md"
		# Lorem Ipsum

		dolor sit amet, consectetur adipiscing elit,

		## sed do

		eiusmod tempor incididunt ut labore et dolore magna aliqua.

		## Ut enim

		ad minim veniam,
	EOF

	cat <<-EOF >"$docdir/quis nostrud.md"
		# Quis Nostrud

		exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

		## Duis aute

		irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
	EOF
}

_make_nested() {
	mkdir -p "$docdir/sub dir"
	cat <<-EOF >"$docdir/sub dir/nested.md"
		# Nested doc

		something interesting in this subdirectory
	EOF
}

_teardown_docdir() {
	rm -rf "$1"
}

setup() {
	bats_load_library 'bats-assert'
	bats_load_library 'bats-file'
	bats_load_library 'bats-support'

	doc="./bin/doc.rb"

	docdir=$(mktemp -d)
	_setup_docdir "$docdir"
}

teardown() {
	_teardown_docdir "$docdir"
}

assert_same_output() {
	run $1
	local first_output="$output"

	run $2
	assert_equal "$output" "$first_output"
}

@test 'doc.rb is executable' {
	assert_file_executable ./bin/doc.rb
}

@test '-h and --help show the help' {
	run $doc --help
	assert_success
	assert_output --partial 'Usage: '

	run $doc -h
	assert_success
	assert_same_output "$doc --help" "$doc -h"

	run $doc "$docdir" --help
	assert_success
	assert_same_output "$doc --help" "$doc $docdir --help"
}

@test '-l and no argument shows the available docs' {
	run $doc "$docdir" -l
	assert_success
	assert_output - <<-EOF
		lorem ipsum   Lorem Ipsum - sed do - Ut enim
		quis nostrud  Quis Nostrud - Duis aute
	EOF

	assert_same_output "$doc $docdir -l" "$doc $docdir"
}

@test 'show doc' {
	_mock_glow
	run $doc "$docdir" 'lorem ipsum'
	assert_success
	assert_output - <"$docdir/lorem ipsum.md"
}

@test 'show non-existing doc' {
	run $doc "$docdir" asdf
	assert_failure 1
	assert_output --partial "no reference for 'asdf'"
}

@test 'show doc matches the whole basename' {
	run $doc "$docdir" md
	assert_failure 1
	assert_output --partial "no reference for 'md'"
}

@test 'show doc with regex characters in the name' {
	run $doc "$docdir" 'a('
	assert_failure 1
	assert_output --partial "no reference for 'a('"
}

@test 'show doc in a subdirectory by basename' {
	_mock_glow
	_make_nested
	run $doc "$docdir" 'nested'
	assert_success
	assert_output --partial 'Nested'
}

@test 'show ambiguous doc' {
	_make_nested
	mkdir "$docdir/other"
	cp "$docdir/sub dir/nested.md" "$docdir/other"
	run $doc "$docdir" "nested"
	assert_failure 1
	assert_output --partial "'nested' is ambiguous"
}

@test '-k missing argument' {
	run $doc "$docdir" -k
	assert_failure 2
	assert_output --partial "Error: missing argument: -k"
}

@test '-k pattern no match' {
	run $doc "$docdir" -k asdf
	assert_failure 1
	refute_output
}

@test '-k pattern is invalid' {
	run $doc "$docdir" -k '('
	assert_failure 2
	assert_output --partial 'regex parse error'
}

@test '-k searches every doc, including subdirectories' {
	_make_nested
	run $doc "$docdir" -k ''
	assert_success
	assert_output --partial 'lorem ipsum.md'
	assert_output --partial 'sub dir/nested.md'
}

@test '-l takes the title from the first # heading' {
	mkdir -p "$docdir/nested"
	printf "## Pre title section\n# Title\n## Section\n" >"$docdir/nested/pretitle.md"
	run $doc "$docdir" -l
	assert_success
	assert_output --regexp $'(^|\n)nested/pretitle[[:space:]]+Title - Section($|\n)'
}

@test '-k pattern matches' {
	run $doc "$docdir" -k lorem
	assert_success
	assert_output - <<-EOF
		./lorem ipsum.md
		1:# Lorem Ipsum
	EOF
}

@test 'unknown option fails' {
	run $doc -x
	assert_failure 2
	assert_output --partial 'Error: invalid option: -x'
}
