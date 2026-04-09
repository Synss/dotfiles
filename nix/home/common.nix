{
  pkgs,
  lib,
  config,
  dotfilesDir,
  ...
}:
{
  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "24.11";

    packages =
      with pkgs;
      [
        # nix tooling
        deadnix
        nixfmt
        statix

        # terminal tools
        bat
        bazelisk
        delta
        direnv
        eza
        fd
        fzf
        jq
        just
        yq-go
        neovim
        pnpm
        ripgrep
        shellcheck
        tmux
        uv
        vivid
        zoxide
        zsh
      ]
      ++ lib.optionals stdenv.isLinux [ ]
      ++ lib.optionals stdenv.isDarwin [ ];

    file = {
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/vim";
      ".vim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/vim";
      ".zshenv".text = ''
        export ZDOTDIR="${dotfilesDir}/zsh"
      '';
    };
  };

  programs = {
    git = {
      enable = true;
      settings = {
        alias = {
          au = "add -u";
          ap = "add -p";
          amend = "commit --amend";
          branch-name = "rev-parse --abbrev-ref HEAD";
          cane = "commit --amend --no-edit";
          ci = "commit";
          co = "checkout";
          fixup = "commit --fixup";
          names = "diff --name-only";
          retop = "!f() { branch=\${1:-master}; git fetch origin $branch:$branch && git rebase $branch; }; f";
          ri = "rebase -i";
          unstage = "reset HEAD --";
        };
        user = {
          name = "Mathias Laurin";
          email = "Mathias.Laurin+github.com@gmail.com";
        };
        commit.verbose = true;
        merge.conflictStyle = "zdiff3";
        pull.rebase = true;
        push.default = "upstream";
        rebase.autosquash = true;
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        dark = {
          dark = true;
          syntax-theme = "gruvbox-dark";
        };
        light = {
          light = true;
          syntax-theme = "gruvbox-light";
        };
      };
    };
  };
}
