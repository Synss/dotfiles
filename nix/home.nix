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
  mkLink = path: { source = config.lib.file.mkOutOfStoreSymmkLink "${dotfilesDir}/${path}"; };
in
{
  imports = [ nix-index-database.homeModules.nix-index ];
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

        # fonts
        nerd-fonts.hack
        nerd-fonts.jetbrains-mono

        # LSP servers
        actions-languageserver
        ansible-language-server
        clang-tools
        groovy-language-server
        lua-language-server
        nil
        pyright
        starlark-rust
        vscode-langservers-extracted

        # terminal tools
        bazelisk
        buildifier
        delta
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
        ruff
        shellcheck
        stylua
        uv
        vivid
        zsh

        # programming languages
        rustup
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
          blink-cmp
          close-buffers-vim
          fzf-lua
          gruvbox-nvim
          lualine-nvim
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
          normal.family = "Hack Nerd Font Mono";
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
          names = "diff --name-only";
          retop = "!f() { branch=\${1:-master}; git fetch origin $branch:$branch && git rebase $branch; }; f";
          ri = "rebase -i";
          sweep-dry =
            "!f() { "
            + "base=\${1:-main}; "
            + "git for-each-ref --format='%(refname:short)' refs/heads/ "
            + "| grep -v \"^$base$\" "
            + "| while read branch; do "
            + "  if git merge-base --is-ancestor \"$branch\" \"$base\" 2>/dev/null; then "
            + "    echo \"$branch\"; "
            + "  elif [ $(git rev-list --count \"$base..$branch\" 2>/dev/null) -le 30 ] "
            + "    && cherry=$(git cherry \"$base\" \"$branch\" 2>/dev/null) "
            + "    && ! echo \"$cherry\" | grep -q '^+'; then "
            + "    echo \"$branch\"; "
            + "  fi; "
            + "done; "
            + "}; f";
          unstage = "reset HEAD --";
        };
        user = {
          name = "Mathias Laurin";
          email = "Mathias.Laurin+github.com@gmail.com";
        };
        branch.sort = "-committerdate";
        commit.verbose = true;
        diff.algorithm = "histogram";
        fetch.prune = true;
        merge.conflictStyle = "zdiff3";
        pull.rebase = true;
        push.default = "upstream";
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
