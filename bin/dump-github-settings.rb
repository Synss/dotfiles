#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'yaml'

USAGE = "usage: #{File.basename($PROGRAM_NAME)} [OWNER/REPO]".freeze

RepoNameError = Class.new(ArgumentError)
RestAPIError = Class.new(IOError)

# Validator for repo name
Repo = Data.define(:owner, :name) do
  def self.parse(arg)
    owner, name =
      case arg
      in nil then ['{owner}', '{repo}']
      in %r{\A[\w.-]+/[\w.-]+\z} => repo then repo.split('/')
      else raise RepoNameError, "Invalid repo name: #{arg}"
      end
    new(owner:, name:)
  end

  def to_s = "#{owner}/#{name}"

  alias_method :to_str, :to_s
end

# Wrapper for `gh api`
class GHApi
  def initialize(repo:)
    @repo = repo
  end

  def get(endpoint:, paginate: false)
    p = path(endpoint)
    pagination = paginate ? %w[--paginate --slurp] : []
    out, status = Open3.capture2('gh', 'api', *pagination, p)
    raise RestAPIError, "gh api failed: #{p}" unless status.success?

    data = JSON.parse(out)
    paginate ? data.flatten(1) : data
  end

  def endpoint?(endpoint:)
    _, err, status = Open3.capture3('gh', 'api', path(endpoint))
    return true if status.success?
    return false if err.include?('HTTP 404')

    raise RestAPIError, err
  end

  private

  def path(endpoint) = "repos/#{@repo}#{endpoint}"
end

# Settings for the `/branches` endpoint
class Branches
  BRANCH_PROTECTION_TOGGLES = %w[
    required_linear_history
    allow_force_pushes
    allow_deletions
    block_creations
    required_conversation_resolution
    lock_branch
    allow_fork_syncing
  ].freeze
  private_constant :BRANCH_PROTECTION_TOGGLES

  PULL_REQUEST_REVIEW_SETTINGS = %w[
    required_approving_review_count
    dismiss_stale_reviews
    require_code_owner_reviews
    require_last_push_approval
  ].freeze
  private_constant :PULL_REQUEST_REVIEW_SETTINGS

  def initialize(api:)
    @api = api
  end

  def settings
    protected = @api.get(endpoint: '/branches?protected=true', paginate: true)
                    .select { it.dig('protection', 'enabled') }
    protected.map do |branch|
      name = branch['name']
      protection = @api.get(endpoint: "/branches/#{name}/protection")
      { 'name' => name, 'protection' => branch_protection(protection) }
    end
  end

  private

  def status_checks(protection)
    checks = protection['required_status_checks']
    return nil if checks.nil?

    {
      'strict' => checks['strict'],
      'checks' => checks['checks'].map { it.slice('context', 'app_id') }
    }
  end

  def restrictions(protection)
    restrictions = protection['restrictions']
    return nil if restrictions.nil?

    {
      'users' => restrictions['users'].map { it['login'] },
      'teams' => restrictions['teams'].map { it['slug'] },
      'apps' => restrictions['apps'].map { it['slug'] }
    }
  end

  def toggles(protection)
    BRANCH_PROTECTION_TOGGLES.to_h do |toggle|
      [toggle, protection.dig(toggle, 'enabled')]
    end
  end

  def branch_protection(protection)
    reviews = protection['required_pull_request_reviews']
    {
      'required_pull_request_reviews' =>
        reviews&.slice(*PULL_REQUEST_REVIEW_SETTINGS),
      'required_status_checks' => status_checks(protection),
      'enforce_admins' => protection.dig('enforce_admins', 'enabled'),
      'restrictions' => restrictions(protection)
    }.merge(toggles(protection))
  end
end

# Settings for the root endpoint
class Repository
  REPOSITORY_SETTINGS = %w[
    name
    description
    homepage
    topics
    private
    has_issues
    has_projects
    has_wiki
    has_downloads
    default_branch
    allow_squash_merge
    allow_merge_commit
    allow_rebase_merge
    allow_auto_merge
    allow_update_branch
    delete_branch_on_merge
    squash_merge_commit_title
    squash_merge_commit_message
    merge_commit_title
    merge_commit_message
  ].freeze
  private_constant :REPOSITORY_SETTINGS

  def initialize(api:)
    @api = api
  end

  def settings
    repo = @api.get(endpoint: '')
    security_fixes = @api.get(endpoint: '/automated-security-fixes')['enabled']
    vulnerability_alerts = @api.endpoint?(endpoint: '/vulnerability-alerts')
    repo.slice(*REPOSITORY_SETTINGS).merge(
      'topics' => repo['topics'].join(', '),
      'enable_automated_security_fixes' => security_fixes,
      'enable_vulnerability_alerts' => vulnerability_alerts
    )
  end
end

# Settings for the `/rulesets` endpoint
class Rulesets
  RULESET_SETTINGS = %w[
    name
    target
    enforcement
    conditions
    rules
    bypass_actors
  ].freeze
  private_constant :RULESET_SETTINGS

  def initialize(api:)
    @api = api
  end

  def settings
    @api.get(endpoint: '/rulesets', paginate: true).map do |ruleset|
      @api.get(endpoint: "/rulesets/#{ruleset['id']}")
          .slice(*RULESET_SETTINGS)
    end
  end
end

def main(argv)
  api = GHApi.new(repo: Repo.parse(argv.first))
  puts({
    'repository' => Repository.new(api:).settings,
    'branches' => Branches.new(api:).settings,
    'rulesets' => Rulesets.new(api:).settings
  }.to_yaml)
rescue RepoNameError, RestAPIError => e
  warn "Error: #{e.message}"
  warn USAGE
  exit 1
end

main(ARGV) if $PROGRAM_NAME == __FILE__
