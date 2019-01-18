.DEFAULT_GOAL := all

ln = ln -nsf
mkdir = mkdir -p

current_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
vim_dir := $(current_dir)vim
tmux_dir := $(current_dir)tmux
zsh_dir := $(current_dir)zsh


.PHONY: etc-vi
etc-vi:
	$(mkdir) $(HOME)/.config
	$(ln) $(vim_dir) $(HOME)/.config/nvim
	$(ln) $(vim_dir) $(HOME)/.vim

.PHONY: etc-tmux
etc-tmux:
	$(ln) $(tmux_dir)/tmux.conf $(HOME)/.tmux.conf

.PHONY: etc-zsh
etc-zsh:
	echo "export ZDOTDIR=\"$(zsh_dir)\"" > $(HOME)/.zshenv
	$(mkdir) $(zsh_dir)/hashed_dirs

.PHONY: install
install: etc-vi etc-tmux etc-zsh

.PHONY: all
all: install

.PHONY: uninstall
uninstall:
	-unlink $(HOME)/.config/nvim
	-unlink $(HOME)/.vim
	-unlink $(HOME)/.tmux.conf
	-$(RM) $(HOME)/.zshenv

.PHONY: clean
clean: uninstall
