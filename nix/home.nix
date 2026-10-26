{
  config,
  stateVersion,
  username,
  homeDirectory,
  dotfilesDir,
  ...
}:
{
  _module.args.mod = import ./modules/lib {
    inherit
      config
      dotfilesDir
      ;
  };
  home = {
    inherit stateVersion username homeDirectory;
  };
  xdg.configFile."nix/nix.conf".text = "accept-flake-config = true\n";
}
