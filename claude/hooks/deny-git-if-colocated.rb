#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'open3'

GIT_MUTATING_COMMANDS = %w[
  add
  am
  apply
  branch
  checkout
  cherry-pick
  clean
  commit
  merge
  rebase
  reset
  restore
  revert
  rm
  stash
  tag
  update-ref
].freeze

MUTATING_GIT_COMMAND = /
  (?: ^ | [;&|(`] | \s)
  git\s+
  (?: (?:-C|-c) \s+ \S+ \s+ | --?\S+ \s+ )*
  (?: #{Regexp.union(GIT_MUTATING_COMMANDS).source} )
  (?: [;&|)`\s] | $)
/x

DENY_RESPONSE = {
  hookSpecificOutput: {
    hookEventName: 'PreToolUse',
    permissionDecision: 'deny',
    permissionDecisionReason:
    'Colocated jj/git repo (.jj next to .git). jj is authoritative. ' \
    'Use the jj equivalent instead of a mutating git command ' \
    "(#{GIT_MUTATING_COMMANDS.join('/')})."
  }
}.freeze

def parse_command(payload)
  case JSON.parse(payload, symbolize_names: true)
  in tool_input: { command: String => command } unless command.empty?
    command
  else
    nil
  end
rescue JSON::ParserError
  nil
end

def find_repo_root
  out, status = Open3.capture2(
    'git', 'rev-parse', '--show-toplevel', err: File::NULL
  )
  repo_root = out.chomp
  repo_root if status.success? && !repo_root.empty?
end

def colocated?(repo_root) = Dir.exist?(File.join(repo_root, '.jj'))

def main
  command = parse_command($stdin.read)
  return unless command
  return unless MUTATING_GIT_COMMAND.match?(command)

  repo_root = find_repo_root
  return unless repo_root
  return unless colocated?(repo_root)

  puts JSON.generate(DENY_RESPONSE)
end

main if $PROGRAM_NAME == __FILE__
