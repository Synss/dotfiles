# GitHub

## GitHub pages

### Setup

Settings → Pages → Build and deployment

- → Source: Change to GitHub Actions
- → Static → Configure: Provides workflow template

### Test first deployment

#### Requirements

- the website is built in a `deploy.yml`
- there is a PR on GitHub adding this workflow from a `deploy` branch

#### Setup

Settings → Environments → github-pages → Deployment branches and tags  
→ Add deployment...: Add rule for the `deploy` branch.

Temporarily add `"deploy"` to the workflow's `on.push.branches`.

#### Tear down

Push again, check, remove `"deploy"` from `on.push.branches` and from
the environment if successful.
