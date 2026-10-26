{
  config,
  stateVersion,
  username,
  homeDirectory,
  dotfilesDir,
  ...
}:
{
  _module.args.mod = import ./modules/lib.nix {
    inherit
      config
      dotfilesDir
      ;
  };
  imports = [
    ./modules/alacritty.nix
    ./modules/bin.nix
    ./modules/claude.nix
    ./modules/comma.nix
    ./modules/containers.nix
    ./modules/fonts.nix
    ./modules/git.nix
    ./modules/jujutsu.nix
    ./modules/neovim.nix
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/tmux.nix
  ];
  home = {
    inherit stateVersion username homeDirectory;
  };
  xdg.configFile."nix/nix.conf".text = "accept-flake-config = true\n";
}
