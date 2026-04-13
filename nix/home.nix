{
  pkgs,
  lib,
  config,
  username,
  homeDirectory,
  dotfilesDir,
  ...
}:
{
  home = {
    inherit username homeDirectory;
    stateVersion = "25.11";

    packages =
      with pkgs;
      [
        # nix tooling
        deadnix
        home-manager
        nixfmt-tree
        statix

        # terminal tools
        bazelisk
        delta
        eza
        fd
        jq
        just
        yq-go
        neovim
        pnpm
        pre-commit
        ripgrep
        shellcheck
        uv
        vivid
        zsh

        # programming languages
        rustup
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
    bat = {
      enable = true;
      config.style = "header-filename,header-filesize,rule";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

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

    tmux = {
      enable = true;
      prefix = "C-Space";
      mouse = true;
      terminal = "tmux-256color";
      keyMode = "vi";
      escapeTime = 0;
      extraConfig = ''
        set -ga terminal-overrides ",*:Tc"
        bind C-Space send-prefix
      '';
      plugins = with pkgs.tmuxPlugins; [
        resurrect
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
          '';
        }
      ];
    };

    # Shell integration for fzf lives in zsh/conf.d/.
    fzf.enable = true;

    # Shell integration for zoxide lives in zsh/conf.d/.
    zoxide.enable = true;

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
