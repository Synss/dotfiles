# frozen_string_literal: true

require_relative '../bin/dump-github-settings'
require 'json'
require 'minitest/autorun'

def mk_req_res(endpoints:, responses:)
  endpoints.zip(File.readlines(responses)).to_h { |k, l| [k, JSON.parse(l)] }
end

def gh_responses(endpoint)
  File.join(__dir__, 'assets', 'gh_endpoint', "#{endpoint}.jsonl")
end

# Stub for GHApi
class GHApiStub
  def initialize(req_res) = @req_res = req_res
  def get(endpoint:, paginate: false) = @req_res[endpoint]
  def endpoint?(endpoint:) = @req_res.key? endpoint
end

# Test `Repo` class
class RepoTests < Minitest::Test
  def test_parse_defaults
    assert_equal '{owner}/{repo}', Repo.parse(nil).to_s
  end

  def test_parse_valid_name_is_identity
    [
      'name/repo',
      'name/repoName',
      'Name/RepoName'
    ].each do |repo|
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

# Golden-file unit tests for branch settings
class TestBranch < Minitest::Test
  # TODO
  EXPECTED = [].freeze

  make_my_diffs_pretty!

  def canned_req_res
    mk_req_res(
      endpoints: %w[/branches?protected=true /branches/main/protection],
      responses: gh_responses('branches')
    )
  end

  def test_settings
    req_res = canned_req_res

    settings = Branches.new(api: GHApiStub.new(req_res)).settings

    assert_equal EXPECTED, settings
  end
end

# Golden-file unit tests for repository settings
class TestRepository < Minitest::Test
  EXPECTED = {
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

  def canned_req_res
    mk_req_res(
      endpoints: ['', '/automated-security-fixes'],
      responses: gh_responses('root')
    )
  end

  def test_settings
    req_res = canned_req_res

    settings = Repository.new(api: GHApiStub.new(req_res)).settings

    assert_equal EXPECTED, settings
  end

  def test_with_disabled_automated_security_fixes
    req_res = canned_req_res.merge(
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
    req_res = canned_req_res.merge(
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

class TestRuleset < Minitest::Test
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
          'strict_required_status_checks_policy' => false,
          'do_not_enforce_on_create' => false,
          'required_status_checks' => [
            { 'context' => 'lint-all', 'integration_id' => 15_368 }
          ]
        } }
    ],
    'bypass_actors' => []
  }].freeze

  make_my_diffs_pretty!

  def canned_req_res
    mk_req_res(
      endpoints: %w[/rulesets /rulesets/14671132],
      responses: gh_responses('rulesets')
    )
  end

  def test_settings
    req_res = canned_req_res

    settings = Rulesets.new(api: GHApiStub.new(req_res)).settings

    assert_equal EXPECTED, settings
  end
end
