#!/usr/bin/env bats

setup() {
	bats_load_library 'bats-assert'
	bats_load_library 'bats-file'
	bats_load_library 'bats-support'
	load 'bats/namespace'

	PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
}

@test 'j2y is executable' {
	assert_file_executable ./bin/j2y
}

@test 'y2j is executable' {
	assert_file_executable ./bin/y2j
}

@test 'j2y | y2j | ... is identity function' {
	json_file="tests/fixtures/example.json"

	# Normalize with `jq -S` to make the round trip independent from formatting.
	run bats_pipe j2y "$json_file" \| y2j \| j2y \| y2j \| jq -S .
	assert_success
	assert_output "$(jq -S . "$json_file")"
}
