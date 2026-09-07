{
  pkgs,
  lib,
  config,
  stateVersion,
  username,
  homeDirectory,
  nix-index-database,
  dotfilesDir,
  ...
}:
let
  mkLink = path: { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}"; };
in
{
  imports = [
    nix-index-database.homeModules.nix-index
    ./modules/neovim.nix
    ./modules/git.nix
  ];
  fonts.fontconfig.enable = true;
  home = {
    inherit stateVersion username homeDirectory;

    sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";

    packages = with pkgs; [
      # nix tools
      home-manager

      # terminal tools
      fd
      glow
      graphviz
      jq
      just
      lazyjj
      yq-go
      pre-commit
      prettier
      ripgrep
      vivid
      xxd
      zsh

      # fonts
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono

      # programming languages
      bazelisk
      nodejs
      pnpm
      rustup
      uv
    ];

    file = {
      ".config/dotfiles" = mkLink "shared";
      ".claude/CLAUDE.md" = mkLink "claude/CLAUDE.md";
      ".claude/hooks" = mkLink "claude/hooks";
      ".claude/skills" = mkLink "claude/skills";
    };

  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        terminal.shell = {
          program = "zsh";
          args = [ "-l" ];
        };
        font = {
          normal.family = "JetBrainsMono Nerd Font Mono";
          size = 12.0;
        };
      };
    };

    bat = {
      enable = true;
      config.style = "header-filename,header-filesize,rule";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --hidden --exclude .venv";
    };

    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = lib.mkDefault "Mathias Laurin";
          email = lib.mkDefault "Mathias.Laurin+github.com@gmail.com";
        };
        aliases = {
          l = [ "log" ];
          la = [
            "log"
            "-r"
            "all()"
          ];
          ld = [
            "log"
            "-T"
            "d"
          ];
          tug = [
            "bookmark"
            "advance"
          ];
        };
        revsets.bookmark-advance-to = "closest_pushable(@)";
        revset-aliases = {
          # `jj l -r by("Alice")` to filter by author.
          "by(x)" = "author(substring:x)";
          "closest_pushable(to)" =
            ''heads(::to & mutable() & ~description(exact:" ") & (~empty() | merges()))'';

          # House keeping: `jj log -r pending()`, `-r submitted()`, `-r wip()`.
          "pending()" = "mine() & mutable() & bookmarks()";
          "submitted()" = "pending() & remote_bookmarks()";
          "wip()" = "mine() & mutable() & ~bookmarks()";
        };
        template-aliases = {
          # `jj ... -T d`
          d = "builtin_log_detailed";
        };
        templates = {
          draft_commit_description = ''
            concat(
            builtin_draft_commit_description,
            "\nJJ: ignore-rest\n",
            diff.git(),
            )
          '';
        };
        ui.pager = "less -FRX";
        core.watchman.register_snapshot_trigger = true; # requires watchman daemon
      };
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      fastSyntaxHighlighting.enable = true;
      history = {
        path = "${config.home.homeDirectory}/.zsh_history";
        size = 50000;
        save = 50000;
        extended = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        share = false;
        append = true;
      };
      initContent =
        with lib;
        mkMerge [
          (mkBefore ''
            DOTFILES_ZSH="${dotfilesDir}/zsh"
          '')
          (mkOrder 550 ''
            fpath+=(${dotfilesDir}/zsh/completions)
          '')
          ''
            for f in ${dotfilesDir}/zsh/conf.d/*.zsh; do source "$f"; done
            () { for f; do source "$f"; done } ${dotfilesDir}/zsh/conf.d/*.local(N)
          ''
        ];
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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
