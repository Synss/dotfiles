![Build Status](https://github.com/Synss/dotfiles/actions/workflows/lint.yml/badge.svg?branch=master)

# dotfiles

Configuration for

- claude
- neovim
- tmux
- zsh

## Installation

Ansible playbooks for localhost in `ansible`.

### Usage

```bash
cd ansible
uv sync
uv run ansible-galaxy collection install -r requirements.yml
uv run ansible-playbook site.yml
```

Or run a single role
```
uv run ansible-playbook site.yml --tags vim
```

Test:
```bash
cd ansible
./test-idempotency.sh
```

Lint:
```bash
cd ansible
uv run ansible-lint
```
