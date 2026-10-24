{
  stateVersion,
  username,
  homeDirectory,
  ...
}:
{
  imports = [
    ./modules/claude.nix
    ./modules/containers.nix
    ./modules/git.nix
    ./modules/jujutsu.nix
    ./modules/neovim.nix
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/terminal.nix
  ];
  home = {
    inherit stateVersion username homeDirectory;
  };
  xdg.configFile."nix/nix.conf".text = "accept-flake-config = true\n";
}
