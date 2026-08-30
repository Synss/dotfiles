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

sub main {
    my $input = do {
        local $/;
        <STDIN>;
      }
      // '';

    my $command = parse_command($input);
    return unless defined $command;

    my $mutating_git_commands =
      build_mutating_git_command_regex(GIT_MUTATING_COMMANDS);
    return unless is_mutating_git_command( $command, $mutating_git_commands );

    my $repo_root = find_repo_root();
    return unless defined $repo_root;
    return unless is_colocated_repo($repo_root);

    my $response = build_denial_response(GIT_MUTATING_COMMANDS);
    print encode_json($response), "\n";
}

sub parse_command {
    my ($input) = @_;
    my $data = eval { decode_json($input) };
    return unless ref($data) eq 'HASH';

    my $tool_input = $data->{tool_input};
    return unless ref($tool_input) eq 'HASH';

    my $command = $tool_input->{command} // '';
    return unless length $command;

    return $command;
}

sub build_mutating_git_command_regex {
    my @commands     = @_;
    my $git_commands = join '|', map { quotemeta } @commands;

    return qr{
        (?: ^ | [;&|(`] | \s)
        git\s+
        (?: (?:-C|-c) \s+ \S+ \s+ | --?\S+ \s+ )*
        (?: $git_commands )
        (?: [;&|)`\s] | $)
    }mx;
}

sub is_mutating_git_command {
    my ( $command, $mutating_git_commands ) = @_;
    return $command =~ $mutating_git_commands;
}

sub find_repo_root {
    my $repo_root = `git rev-parse --show-toplevel 2>/dev/null`;
    chomp $repo_root;
    return unless $? == 0;
    return unless length $repo_root;

    return $repo_root;
}

sub is_colocated_repo {
    my ($repo_root) = @_;
    return -d "$repo_root/.jj";
}

sub build_denial_response {
    my @commands = @_;
    my $reason =
        'Colocated jj/git repo (.jj next to .git) - jj is authoritative. '
      . 'Use the jj equivalent instead of a mutating git command ('
      . join( '/', @commands ) . ').';

    return {
        hookSpecificOutput => {
            hookEventName            => 'PreToolUse',
            permissionDecision       => 'deny',
            permissionDecisionReason => $reason,
        },
    };
}

main();
