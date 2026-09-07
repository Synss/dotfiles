{
  stateVersion,
  username,
  homeDirectory,
  ...
}:
{
  imports = [
    ./modules/packages.nix
    ./modules/neovim.nix
    ./modules/git.nix
    ./modules/jujutsu.nix
    ./modules/shell.nix
    ./modules/terminal.nix
    ./modules/claude.nix
  ];
  home = {
    inherit stateVersion username homeDirectory;
  };
}
