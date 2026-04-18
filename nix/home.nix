{
  pkgs,
  lib,
  config,
  username,
  homeDirectory,
  nix-index-database,
  dotfilesDir,
  ...
}:
{
  imports = [ nix-index-database.hmModules.nix-index ];
  home = {
    inherit username homeDirectory;
    stateVersion = "25.11";

    sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";

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
        glow
        graphviz
        jq
        just
        yq-go
        neovim
        nodejs
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
    };
  };

  programs = {
    alacritty = {
      enable = true;
      settings.terminal.shell = {
        program = "zsh";
        args = [ "-l" ];
      };
    };

    bat = {
      enable = true;
      config.style = "header-filename,header-filesize,rule";
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options.navigate = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fzf.enable = true;

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtraFirst = ''
        DOTFILES_ZSH="${dotfilesDir}/zsh"
      '';
      initExtraBeforeCompInit = ''
        fpath+=(${dotfilesDir}/zsh/completions)
      '';
      initExtra = ''
        for f in ${dotfilesDir}/zsh/conf.d/*.zsh; do source "$f"; done
        () { for f; do source "$f"; done } ${dotfilesDir}/zsh/conf.d/*.local(N)
      '';
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

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    nix-index-database.comma.enable = true;

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

    zoxide.enable = true;
  };
}
