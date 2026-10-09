#!/usr/bin/env ruby
# Dump `settings.yaml` for IaC
#
# Schema/documentation:
# - https://github.com/repository-settings/app/tree/master/docs/plugins
#
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

  def get(endpoint, paginate: false)
    p = path(endpoint)
    pagination = paginate ? %w[--paginate --slurp] : []
    out, status = Open3.capture2('gh', 'api', *pagination, p)
    raise RestAPIError, "gh api failed: #{p}" unless status.success?

    data = JSON.parse(out)
    paginate ? data.flatten(1) : data
  end

  def endpoint?(endpoint)
    _, err, status = Open3.capture3('gh', 'api', path(endpoint))
    return true if status.success?
    return false if err.include?('HTTP 404')

    raise RestAPIError, err
  end

  private

  def path(endpoint) = "repos/#{@repo}#{endpoint}"
end

# Settings for the `/branches` endpoint (`lib/plugins/branches.js`)
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

  PULL_REQUEST_REVIEW_ALLOW = %w[
    required_approving_review_count
    dismiss_stale_reviews
    require_code_owner_reviews
    require_last_push_approval
  ].freeze
  private_constant :PULL_REQUEST_REVIEW_ALLOW

  PULL_REQUEST_REVIEW_ACTORS = %w[
    dismissal_restrictions
    bypass_pull_request_allowances
  ].freeze
  private_constant :PULL_REQUEST_REVIEW_ACTORS

  def initialize(api:)
    @api = api
  end

  def settings
    protected = @api.get('/branches?protected=true', paginate: true)
                    .select { it.dig('protection', 'enabled') }
    protected.map do |branch|
      name = branch['name']
      protection = @api.get("/branches/#{name}/protection")
      { 'name' => name, 'protection' => branch_protection(protection) }
    end
  end

  private

  def actors(restriction)
    restriction&.then do |r|
      {
        'users' => r.fetch('users', []).map { it['login'] },
        'teams' => r.fetch('teams', []).map { it['slug'] },
        'apps' => r.fetch('apps', []).map { it['slug'] }
      }
    end
  end

  def pull_request_reviews(reviews)
    reviews&.then do |r|
      r.slice(*PULL_REQUEST_REVIEW_ALLOW).merge(
        r.slice(*PULL_REQUEST_REVIEW_ACTORS).transform_values { actors(it) }
      )
    end
  end

  def toggles(protection)
    BRANCH_PROTECTION_TOGGLES.to_h do |toggle|
      [toggle, protection.dig(toggle, 'enabled')]
    end
  end

  def branch_protection(protection)
    {
      'required_pull_request_reviews' =>
        pull_request_reviews(protection['required_pull_request_reviews']),
      'required_status_checks' =>
        protection['required_status_checks']
          &.slice('strict', 'contexts', 'checks'),
      'enforce_admins' => protection.dig('enforce_admins', 'enabled'),
      'restrictions' => actors(protection['restrictions'])
    }.merge(toggles(protection))
  end
end

# Settings for the environments endpoint (`lib/plugins/environments.js`)
#
# /environments/*  PUT
class Environments
  def initialize(api:)
    @api = api
  end

  def settings
    @api.get('/environments', paginate: true)
        .flat_map { it['environments'] }
        .map { environment(it) }
  end

  private

  def environment(env)
    rules = env.fetch('protection_rules', []).to_h { [it['type'], it] }
    {
      'name' => env['name'],
      'wait_timer' => rules.dig('wait_timer', 'wait_timer'),
      'reviewers' => reviewers(rules['required_reviewers']),
      'deployment_branch_policy' => deployment_branch_policy(env)
    }.compact
  end

  def reviewers(rule)
    rule&.fetch('reviewers')&.map do |r|
      { 'id' => r.dig('reviewer', 'id'), 'type' => r['type'] }
    end
  end

  def deployment_branch_policy(env)
    policy = env['deployment_branch_policy']
    if policy.nil?
      nil
    elsif policy['custom_branch_policies']
      { 'custom_branches' => custom_branches(env['name']) }
    else
      { 'protected_branches' => true }
    end
  end

  def custom_branches(name)
    @api.get("/environments/#{name}/deployment-branch-policies", paginate: true)
        .flat_map { it['branch_policies'] }
        .map { it.slice('name', 'type') }
  end
end

# Settings for the root endpoint (`lib/plugins/repository.js`)
#
# /                          PATCH
# /automated-security-fixes  PUT/DELETE
# /topics                    PUT
# /vulnerability-alerts      PUT/DELETE
class Repository
  REPOSITORY_ALLOW = %w[
    name
    description
    homepage
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
  private_constant :REPOSITORY_ALLOW

  def initialize(api:)
    @api = api
  end

  def settings
    repo = @api.get('')
    security_fixes = @api.get('/automated-security-fixes')['enabled']
    vulnerability_alerts = @api.endpoint?('/vulnerability-alerts')
    repo.slice(*REPOSITORY_ALLOW).merge(
      'topics' => repo['topics'].join(', '),
      'enable_automated_security_fixes' => security_fixes,
      'enable_vulnerability_alerts' => vulnerability_alerts
    )
  end
end

# Settings for the `/rulesets` endpoint (`lib/plugins/rulesets.js`)
class Rulesets
  # See `changed` in `lib/plugins/rulesets.js`
  RULESET_DENY = %w[
    id
    _links
    created_at
    updated_at
    source_type
    source
    node_id
    current_user_can_bypass
  ].freeze
  private_constant :RULESET_DENY

  def initialize(api:)
    @api = api
  end

  def settings
    rulesets = @api.get('/rulesets?includes_parents=false', paginate: true)
    rulesets.map do |ruleset|
      @api.get("/rulesets/#{ruleset['id']}")
          .except(*RULESET_DENY)
    end
  end
end

def settings(api)
  {
    'repository' => Repository.new(api:).settings,
    'branches' => Branches.new(api:).settings,
    'environments' => Environments.new(api:).settings,
    'rulesets' => Rulesets.new(api:).settings
  }
end

def main(argv)
  puts settings(GHApi.new(repo: Repo.parse(argv.first))).to_yaml
rescue RepoNameError, RestAPIError => e
  warn "Error: #{e.message}"
  warn USAGE
  exit 1
end

main(ARGV) if $PROGRAM_NAME == __FILE__
