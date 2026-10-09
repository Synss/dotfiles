# frozen_string_literal: true

require_relative '../bin/dump-github-settings'
require 'json'
require 'minitest/autorun'

# Test helper for building request-response pairs
module RequestResponseHelper
  def parse_endpoint_responses(endpoints:, responses:)
    endpoints.zip(responses.each_line).to_h do |endpoint, line|
      [endpoint, JSON.parse(line, freeze: true)]
    end
  end

  def load_req_res(name, endpoints:)
    File.open(fixture(name)) do |file|
      parse_endpoint_responses(endpoints:, responses: file)
    end
  end

  def fixture(name)
    File.join(__dir__, 'fixtures', 'gh_endpoint', "#{name}.jsonl")
  end
end

# Stub for GHApi
class GHApiStub
  def initialize(req_res) = @req_res = req_res

  def get(endpoint, paginate: false)
    res = @req_res[endpoint]
    paginate ? [res].flatten(1) : res
  end

  def endpoint?(endpoint) = @req_res.key? endpoint
end

# Tests repo parser
class RepoTests < Minitest::Test
  def test_parse_defaults
    assert_equal '{owner}/{repo}', Repo.parse(nil).to_s
  end

  def test_parse_valid_name_is_identity
    %w[name/repo name/repoName Name/RepoName].each do |repo|
      assert_equal repo, Repo.parse(repo).to_s
    end
  end

  def test_parse_invalid_repo_names_raises
    [
      'name',
      'Name',
      'name repo'
    ].each do |repo|
      assert_raises(RepoNameError) { Repo.parse(repo) }
    end
  end
end

# Golden-file unit tests for branches endpoint
class TestBranches < Minitest::Test
  extend RequestResponseHelper

  CANNED_REQ_RES = load_req_res(
    'branches',
    endpoints: %w[/branches?protected=true /branches/main/protection]
  ).freeze
  EXPECTED = [{
    # https://github.com/repository-settings/app/blob/master/docs/plugins/branches.md
    'name' => 'main',
    'protection' => {
      'required_pull_request_reviews' => {
        'required_approving_review_count' => 0,
        'dismiss_stale_reviews' => false,
        'require_code_owner_reviews' => false,
        'require_last_push_approval' => false
      },
      'required_status_checks' => {
        'strict' => false,
        'contexts' => ['run QA on macos-latest', 'run QA on ubuntu-latest'],
        'checks' => [
          { 'context' => 'run QA on macos-latest', 'app_id' => 12_345 },
          { 'context' => 'run QA on ubuntu-latest', 'app_id' => 12_345 }
        ]
      },
      'enforce_admins' => true,
      'restrictions' => nil,
      'required_linear_history' => true,
      'allow_force_pushes' => false,
      'allow_deletions' => false,
      'block_creations' => false,
      'required_conversation_resolution' => false,
      'lock_branch' => false,
      'allow_fork_syncing' => false
    }
  }].freeze

  make_my_diffs_pretty!

  def test_settings
    req_res = CANNED_REQ_RES

    settings = Branches.new(api: GHApiStub.new(req_res)).settings

    assert_equal EXPECTED, settings
  end

  def test_with_review_actors
    actors = {
      'users' => [{ 'login' => 'octocat', 'id' => 1 }],
      'teams' => [{ 'slug' => 'justice-league', 'id' => 2 }]
    }
    req_res = with_reviews(
      'dismissal_restrictions' => actors.merge('url' => 'https://...'),
      'bypass_pull_request_allowances' => actors
    )

    settings = Branches.new(api: GHApiStub.new(req_res)).settings

    expected_actors = {
      'users' => ['octocat'], 'teams' => ['justice-league'], 'apps' => []
    }
    assert_equal(
      EXPECTED[0]['protection']['required_pull_request_reviews'].merge(
        'dismissal_restrictions' => expected_actors,
        'bypass_pull_request_allowances' => expected_actors
      ),
      settings[0]['protection']['required_pull_request_reviews']
    )
  end

  private

  def with_reviews(extra)
    protection = CANNED_REQ_RES['/branches/main/protection']
    reviews = protection['required_pull_request_reviews'].merge(extra)
    CANNED_REQ_RES.merge(
      '/branches/main/protection' =>
        protection.merge('required_pull_request_reviews' => reviews)
    )
  end
end

# Golden-file unit tests for environments endpoint
class TestEnvironments < Minitest::Test
  extend RequestResponseHelper

  CANNED_REQ_RES = load_req_res(
    'environments',
    endpoints: %w[
      /environments
      /environments/github-pages/deployment-branch-policies
    ]
  ).freeze
  EXPECTED = [
    {
      'name' => 'github-pages',
      'deployment_branch_policy' => {
        'custom_branches' => [
          { 'name' => 'main', 'type' => 'branch' },
          { 'name' => 'v*', 'type' => 'tag' }
        ]
      }
    },
    {
      'name' => 'production',
      'wait_timer' => 5,
      'reviewers' => [{ 'id' => 42, 'type' => 'User' }],
      'deployment_branch_policy' => { 'protected_branches' => true }
    }
  ].freeze

  make_my_diffs_pretty!

  def test_settings
    req_res = CANNED_REQ_RES

    settings = Environments.new(api: GHApiStub.new(req_res)).settings

    assert_equal EXPECTED, settings
  end
end

# Golden-file unit tests for root endpoint
class TestRepository < Minitest::Test
  extend RequestResponseHelper

  CANNED_REQ_RES = load_req_res(
    'root',
    endpoints: ['', '/automated-security-fixes']
  ).freeze
  EXPECTED = {
    # https://github.com/repository-settings/app/blob/master/docs/plugins/repository.md
    'name' => 'dotfiles',
    'description' => nil,
    'homepage' => nil,
    'topics' => '',
    'private' => false,
    'has_issues' => false,
    'has_projects' => false,
    'has_wiki' => false,
    'has_downloads' => false,
    'default_branch' => 'main',
    'allow_squash_merge' => true,
    'allow_merge_commit' => false,
    'allow_rebase_merge' => true,
    'allow_auto_merge' => true,
    'allow_update_branch' => true,
    'delete_branch_on_merge' => true,
    'squash_merge_commit_title' => 'COMMIT_OR_PR_TITLE',
    'squash_merge_commit_message' => 'COMMIT_MESSAGES',
    'merge_commit_title' => 'MERGE_MESSAGE',
    'merge_commit_message' => 'PR_TITLE',
    'enable_automated_security_fixes' => true,
    'enable_vulnerability_alerts' => false
  }.freeze

  make_my_diffs_pretty!

  def test_settings
    req_res = CANNED_REQ_RES

    settings = Repository.new(api: GHApiStub.new(req_res)).settings

    assert_equal EXPECTED, settings
  end

  def test_with_disabled_automated_security_fixes
    req_res = CANNED_REQ_RES.merge(
      {
        '/automated-security-fixes' => { 'enabled' => false }
      }
    )

    settings = Repository.new(api: GHApiStub.new(req_res)).settings

    assert_equal(
      EXPECTED.merge({ 'enable_automated_security_fixes' => false }),
      settings
    )
  end

  def test_with_vulnerability_alerts
    req_res = CANNED_REQ_RES.merge(
      {
        '/vulnerability-alerts' => {}
      }
    )

    settings = Repository.new(api: GHApiStub.new(req_res)).settings

    assert_equal(
      EXPECTED.merge({ 'enable_vulnerability_alerts' => true }),
      settings
    )
  end
end

# Golden-file unit tests for rulesets endpoint
class TestRuleset < Minitest::Test
  extend RequestResponseHelper

  CANNED_REQ_RES = load_req_res(
    'rulesets',
    endpoints: %w[/rulesets?includes_parents=false /rulesets/14671132]
  ).freeze
  EXPECTED = [{
    'name' => 'Default branch',
    'target' => 'branch',
    'enforcement' => 'active',
    'conditions' => {
      'ref_name' => { 'exclude' => [], 'include' => ['~DEFAULT_BRANCH'] }
    },
    'rules' => [
      { 'type' => 'deletion' },
      { 'type' => 'non_fast_forward' },
      { 'type' => 'required_linear_history' },
      { 'type' => 'pull_request',
        'parameters' => {
          'required_approving_review_count' => 0,
          'dismiss_stale_reviews_on_push' => false,
          'required_reviewers' => [],
          'require_code_owner_review' => false,
          'require_last_push_approval' => false,
          'required_review_thread_resolution' => false,
          'require_extra_approval_for_unattributed_changes' => true,
          'allowed_merge_methods' => %w[rebase squash]
        } },
      { 'type' => 'required_status_checks',
        'parameters' => {
          'strict_required_status_checks_policy' => false, # required field
          'do_not_enforce_on_create' => false,
          'required_status_checks' => [
            { 'context' => 'lint-all', 'integration_id' => 15_368 }
          ]
        } }
    ],
    'bypass_actors' => []
  }].freeze

  make_my_diffs_pretty!

  def test_settings
    req_res = CANNED_REQ_RES

    settings = Rulesets.new(api: GHApiStub.new(req_res)).settings

    assert_equal EXPECTED, settings
  end
end
