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
let
  mkLink = path: { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}"; };

  retop = pkgs.writeShellScript "git-retop" (builtins.readFile ./scripts/git-retop.sh);
  sweep = pkgs.writeShellScript "git-sweep" (builtins.readFile ./scripts/git-sweep.sh);
in
{
  imports = [ nix-index-database.homeModules.nix-index ];
  fonts.fontconfig.enable = true;
  home = {
    inherit username homeDirectory;
    stateVersion = "25.11";

    sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";

    packages =
      with pkgs;
      [
        # nix tooling
        home-manager

        # fonts
        nerd-fonts.hack
        nerd-fonts.jetbrains-mono

        # LSP servers | nvim
        actions-languageserver # -     gh_action_ls
        ansible-language-server # -    ansiblels
        clang-tools # -                clangd
        groovy-language-server # -     groovyls
        lua-language-server # -        lua_ls
        marksman # -                   marksman
        nil # -                        nil_ls
        pyright # -                    pyright
        starlark-rust # -              starlark_rust
        vscode-langservers-extracted # cssls eslint html jsonls
        yaml-language-server # -       yaml-language-server

        # terminal tools
        bazelisk
        buildifier
        delta
        fd
        glow
        graphviz
        jq
        just
        lazygit
        lazyjj
        yq-go
        neovim
        neovim-remote
        nixfmt-tree
        nodejs
        pnpm
        pre-commit
        ripgrep
        ruff
        shellcheck
        uv
        vivid
        zsh

        # programming languages
        rustup

        # Dependencies
        watchman # for jj
      ]
      ++ lib.optionals stdenv.isLinux [ ]
      ++ lib.optionals stdenv.isDarwin [ ];

    file = {
      ".config/nvim" = mkLink "vim";
      ".vim" = mkLink "vim";
      ".claude/settings.json" = mkLink "claude/settings.json";
      ".claude/CLAUDE.md" = mkLink "claude/CLAUDE.md";
    };

  };

  xdg.dataFile = builtins.listToAttrs (
    map
      (p: {
        name = "nvim/site/pack/nix/start/${p.pname}";
        value = {
          source = p;
        };
      })
      (
        with pkgs.vimPlugins;
        [
          auto-session
          blink-cmp
          close-buffers-vim
          fzf-lua
          gruvbox-nvim
          lazygit-nvim
          lazyjj-nvim
          lualine-nvim
          nerdy-nvim
          nvim-lspconfig
          nvim-web-devicons
          oil-nvim
          vim-fugitive
          vim-nix
          which-key-nvim
          zoxide-vim
        ]
      )
  );

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

    delta = {
      enable = true;
      enableGitIntegration = true;
      options.navigate = true;
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
          name = pkgs.lib.mkDefault "Mathias Laurin";
          email = pkgs.lib.mkDefault "Mathias.Laurin+github.com@gmail.com";
        };
        aliases = {
          l = [ "log" ];
          la = [
            "log"
            "-r"
            "all()"
          ];
          tug = [
            "bookmark"
            "advance"
          ];

          # House keeping
          pending = [
            "log"
            "-r"
            "mine() & ~::trunk() & bookmarks()"
          ];
          submitted = [
            "log"
            "-r"
            "mine() & ~::trunk() & bookmarks() & ~remote_bookmarks()"
          ];
          wip = [
            "log"
            "-r"
            "mine() & ~::trunk() & ~bookmarks()"
          ];
        };
        revsets.bookmark-advance-to = "closest_pushable(@)";
        revset-aliases = {
          "closest_pushable(to)" =
            ''heads(::to & mutable() & ~description(exact:" ") & (~empty() | merges()))'';
        };
        ui.pager = "less -FRX";
        core.watchman.register_snapshot_trigger = true; # requires watchman daemon
      };
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
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
      initContent = lib.mkMerge [
        (lib.mkBefore ''
          DOTFILES_ZSH="${dotfilesDir}/zsh"
        '')
        (lib.mkOrder 550 ''
          fpath+=(${dotfilesDir}/zsh/completions)
        '')
        ''
          for f in ${dotfilesDir}/zsh/conf.d/*.zsh; do source "$f"; done
          () { for f; do source "$f"; done } ${dotfilesDir}/zsh/conf.d/*.local(N)
        ''
      ];
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
          logline = "log --graph --oneline --decorate --color";
          logall = "log --graph --oneline --decorate --color --exclude='refs/notes/*' --all";
          logfull = "log --graph --pretty=format:'%C(yellow)%h%Creset %d%s %C(green)(%cr)%Creset %C(bold blue)<%an>%Creset'";
          names = "diff --name-only";
          retop = "!${retop}";
          ri = "rebase -i";
          sweep = "!${sweep}";
          unstage = "reset HEAD --";
        };
        user = {
          name = pkgs.lib.mkDefault "Mathias Laurin";
          email = pkgs.lib.mkDefault "Mathias.Laurin+github.com@gmail.com";
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
    };
  };
}
