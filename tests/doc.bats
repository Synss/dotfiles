#!/usr/bin/env bats

# Run with `nix develop --command bats ./tests/doc.bats`.

setup() {
	bats_load_library 'bats-assert'
	bats_load_library 'bats-file'
	bats_load_library 'bats-support'

	DIR="$(cd "$BATS_TEST_DIRNAME" >/dev/null 2>&1 && pwd)"
	PATH="$DIR/..:$PATH"
	doc="./bin/doc.rb"
	docdir="$DIR/../docs/"
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

_make_docdir() {
	tmp_docdir="$BATS_TEST_TMPDIR/docs"
	mkdir -p "$tmp_docdir/sub dir"
	printf '# Top\nneedle here\n' >"$tmp_docdir/top.md"
	printf '## Early\n# Nested\n## Section\nneedle here\n' \
		>"$tmp_docdir/sub dir/nested.md"
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
	assert_output --regexp $'(^|\n)nvim[[:space:]]+Neovim.*($|\n)'
	assert_output --regexp $'(^|\n)jj[[:space:]]+JJ.*($|\n)'

	assert_same_output "$doc $docdir -l" "$doc $docdir"
}

@test 'show doc' {
	_mock_glow
	run $doc "$docdir" jj
	assert_success
	assert_output --partial 'JJ'
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
	_make_docdir
	run $doc "$tmp_docdir" nested
	assert_success
	assert_output --partial 'Nested'
}

@test 'show ambiguous doc' {
	_make_docdir
	mkdir "$tmp_docdir/other"
	printf '# Other\n' >"$tmp_docdir/other/nested.md"
	run $doc "$tmp_docdir" nested
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
	_make_docdir
	run $doc "$tmp_docdir" -k 'needle here'
	assert_success
	assert_output --partial 'top.md'
	assert_output --partial 'sub dir/nested.md'
}

@test '-l takes the title from the first # heading' {
	_make_docdir
	run $doc "$tmp_docdir" -l
	assert_success
	assert_output --regexp $'(^|\n)sub dir/nested[[:space:]]+Nested - Section($|\n)'
}

@test '-k pattern matches' {
	run $doc "$docdir" -k jj
	assert_success
	assert_output --partial 'JJ'
	assert_output --partial 'jj'
}

@test 'unknown option fails' {
	run $doc -x
	assert_failure 2
	assert_output --partial 'Error: invalid option: -x'
}
