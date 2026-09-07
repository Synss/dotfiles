{
  pkgs,
  lib,
  config,
  dotfilesDir,
  nix-index-database,
  ...
}:
{
  imports = [ nix-index-database.homeModules.nix-index ];

  home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";

  home.packages = with pkgs; [
    fd
    glow
    ripgrep
    vivid
    zsh
  ];

  programs = {
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

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    nix-index-database.comma.enable = true;

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
