.DEFAULT_GOAL := all

ln = ln -nsf
mkdir = mkdir -p

current_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
git_dir := $(current_dir)git
tmux_dir := $(current_dir)tmux
vim_dir := $(current_dir)vim
zsh_dir := $(current_dir)zsh


.PHONY: etc-git
etc-git:
	$(ln) $(git_dir)/gitconfig $(HOME)/.gitconfig

.PHONY: etc-tmux
etc-tmux:
	$(ln) $(tmux_dir)/tmux.conf $(HOME)/.tmux.conf

.PHONY: etc-vi
etc-vi:
	$(mkdir) $(HOME)/.config
	$(ln) $(vim_dir) $(HOME)/.config/nvim
	$(ln) $(vim_dir) $(HOME)/.vim

.PHONY: etc-zsh
etc-zsh:
	echo "export ZDOTDIR=\"$(zsh_dir)\"" > $(HOME)/.zshenv
	$(mkdir) $(zsh_dir)/hashed_dirs

.PHONY: install
install: etc-git etc-tmux etc-vi etc-zsh

.PHONY: all
all: install

.PHONY: uninstall
uninstall:
	-unlink $(HOME)/.gitconfig
	-unlink $(HOME)/.config/nvim
	-unlink $(HOME)/.vim
	-unlink $(HOME)/.tmux.conf
	-$(RM) $(HOME)/.zshenv

.PHONY: clean
clean: uninstall
