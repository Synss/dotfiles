#!/usr/bin/env bash
# shellcheck disable=SC2034  # fail is read by the suite script sourcing this file
# Assertion helpers shared by every suite.
#
# Each suite sets SUITE_NAME and SCRATCH_DIR before calling these, and
# reads $fail after its assertions to know whether to exit non-zero.
# Failure messages include the suite and scratch dir so a failure is
# diagnosable without re-running setup.

fail=0

fail_context() {
	echo "  suite: ${SUITE_NAME:-unknown}, scratch dir: ${SCRATCH_DIR:-unknown}"
}

assert_grep() {
	local label=$1 pattern=$2 file=$3
	if grep -qF -- "$pattern" "$file"; then
		echo "PASS $label"
	else
		echo "FAIL $label: '$pattern' missing from $file"
		fail_context
		fail=1
	fi
}

assert_grep_re() {
	local label=$1 pattern=$2 file=$3
	if grep -qiE -- "$pattern" "$file"; then
		echo "PASS $label"
	else
		echo "FAIL $label: /$pattern/i missing from $file"
		fail_context
		fail=1
	fi
}

assert_no_grep() {
	local label=$1 pattern=$2 file=$3
	if grep -qF -- "$pattern" "$file"; then
		echo "FAIL $label: '$pattern' still in $file"
		fail_context
		fail=1
	else
		echo "PASS $label"
	fi
}

# String analog of assert_no_grep, for a captured value rather than a file.
assert_no_grep_str() {
	local label=$1 pattern=$2 value=$3
	if grep -qF -- "$pattern" <<<"$value"; then
		echo "FAIL $label: '$pattern' found in: $value"
		fail_context
		fail=1
	else
		echo "PASS $label"
	fi
}

assert_count() {
	local label=$1 pattern=$2 want=$3 file=$4 got
	got=$(grep -cF -- "$pattern" "$file" || true)
	if [ "$got" -eq "$want" ]; then
		echo "PASS $label"
	else
		echo "FAIL $label: '$pattern' occurs $got times in $file, want $want"
		fail_context
		fail=1
	fi
}

assert_unchanged() {
	local label=$1 orig=$2 file=$3
	if diff -q "$orig" "$file" >/dev/null; then
		echo "PASS $label"
	else
		echo "FAIL $label: $file was edited but should have been left alone"
		fail_context
		fail=1
	fi
}

# Fails if $2 is non-empty; used to assert a command produced no output.
assert_empty() {
	local label=$1 value=$2
	if [ -z "$value" ]; then
		echo "PASS $label"
	else
		echo "FAIL $label: $value"
		fail_context
		fail=1
	fi
}

# Fails if $1 is empty; used to validate a captured revision id.
assert_nonempty() {
	local label=$1 value=$2
	if [ -n "$value" ]; then
		echo "PASS $label"
	else
		echo "FAIL $label: value is empty"
		fail_context
		fail=1
	fi
}
