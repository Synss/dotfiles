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

Allow `direnv` in the `ansible` directory.  `direnv` is configured
to remove the need to prefix ansible commands with `uv run`.
```bash
cd ansible
direnv allow
```

Update `uv` and run the playbooks:

```bash
cd ansible
uv sync
ansible-galaxy collection install -r requirements.yml
ansible-playbook site.yml
```

Or run a single role
```
ansible-playbook site.yml --tags vim
```

Test:
```bash
cd ansible
./test-idempotency.sh
```

Lint:
```bash
cd ansible
ansible-lint
```
