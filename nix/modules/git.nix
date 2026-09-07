{ pkgs, lib, ... }:
let
  colocate = pkgs.writers.writePython3 "git-colocate" { } (
    builtins.readFile ../scripts/git-colocate.py
  );
in
{
  home.packages = [ pkgs.gh ];

  programs.git = {
    enable = true;
    settings = {
      alias = {
        au = "add -u";
        ap = "add -p";
        amend = "commit --amend";
        branch-name = "rev-parse --abbrev-ref HEAD";
        cane = "commit --amend --no-edit";
        ci = "commit";
        colocate = "!${colocate}";
        co = "checkout";
        fixup = "commit --fixup";
        logline = "log --graph --oneline --decorate --color";
        logall = "log --graph --oneline --decorate --color --exclude='refs/notes/*' --all";
        logfull = "log --graph --pretty=format:'%C(yellow)%h%Creset %d%s %C(green)(%cr)%Creset %C(bold blue)<%an>%Creset'";
        names = "diff --name-only";
        ri = "rebase -i";
        unstage = "reset HEAD --";
      };
      user = {
        name = lib.mkDefault "Mathias Laurin";
        email = lib.mkDefault "Mathias.Laurin+github.com@gmail.com";
      };
      branch.sort = "-committerdate";
      commit.verbose = true;
      diff.algorithm = "histogram";
      fetch.prune = true;
      merge.conflictStyle = "zdiff3";
      pull.rebase = true;
      push.autosetupremote = true;
      rebase.autosquash = true;
      rerere.enabled = true;
    };
  };
}
