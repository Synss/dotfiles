#!/usr/bin/env perl
# PreToolUse/Bash hook: block mutating git commands in a colocated jj/git repo.
#
# Enforces the "Version control" section of ~/.claude/CLAUDE.md: in a repo
# where jj and git are colocated (.jj next to .git), jj is the source of
# truth and Claude must use the jj equivalent instead of mutating git
# commands.
use strict;
use warnings;
use JSON::PP qw(decode_json encode_json);

use constant GIT_MUTATING_COMMANDS => qw(
  add
  rm
  commit
  checkout
  reset
  stash
  restore
  clean
  merge
  rebase
  cherry-pick
  revert
  am
  apply
  update-ref
  branch
  tag
);

my $input = do { local $/; <STDIN> } // '';
my $data = eval { decode_json($input) };
exit 0 unless ref($data) eq 'HASH';

my $command         = $data->{tool_input}{command} // '';
my $git_commands    = join '|', map { quotemeta } GIT_MUTATING_COMMANDS;
my $git_commands_re = qr{
    (?: ^ | [;&|(`] | \s)
    git\s+
    (?: $git_commands )
    (?: [;&|)`\s] | $)
}mx;

exit 0 unless $command =~ $git_commands_re;

my $repo_root = `git rev-parse --show-toplevel 2>/dev/null`;
chomp $repo_root;
exit 0 if $? != 0 || $repo_root eq '' || !-d "$repo_root/.jj";

my $reason =
    'Colocated jj/git repo (.jj next to .git) - jj is authoritative. '
  . 'Use the jj equivalent instead of a mutating git command ('
  . join( '/', GIT_MUTATING_COMMANDS ) . ').';

print encode_json({
    hookSpecificOutput => {
        hookEventName            => 'PreToolUse',
        permissionDecision       => 'deny',
        permissionDecisionReason => $reason,
    },
}) . "\n";
