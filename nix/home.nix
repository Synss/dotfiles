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

  colocate = pkgs.writers.writePython3 "git-colocate" { } (
    builtins.readFile ./scripts/git-colocate.py
  );
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
        basedpyright # -               basedpyright
        clang-tools # -                clangd
        groovy-language-server # -     groovyls
        lua-language-server # -        lua_ls
        marksman # -                   marksman
        nil # -                        nil_ls
        nixd # -                       nixd
        ruff # -                       ruff
        starpls # -                    starpls
        vscode-langservers-extracted # cssls eslint html jsonls
        yaml-language-server # -       yaml-language-server

        # tools
        ansible-lint
        bazelisk
        buildifier
        delta
        fd
        gh
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
        prettier
        ripgrep
        shellcheck
        typos-lsp
        vivid
        xxd
        zsh

        # programming languages
        rustup
        uv

        # Dependencies
        watchman # for jj
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [ ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ ];

    file = {
      ".config/nvim" = mkLink "nvim";
      ".config/dotfiles" = mkLink "shared";
      ".claude/CLAUDE.md" = mkLink "claude/CLAUDE.md";
      ".claude/hooks" = mkLink "claude/hooks";
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
          conform-nvim
          fzf-lua
          gruvbox-nvim
          lazygit-nvim
          lazyjj-nvim
          lualine-nvim
          mini-ai
          mini-bufremove
          mini-icons
          mini-surround
          nerdy-nvim
          nvim-lspconfig
          nvim-web-devicons
          oil-nvim
          vim-fugitive
          vim-nix
          tiny-inline-diagnostic-nvim
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
          colocate = "!${colocate}";
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
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
