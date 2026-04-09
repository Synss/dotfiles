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
        git
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
}
