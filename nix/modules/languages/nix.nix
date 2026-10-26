{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.nix;
in
{
  config = sys.langPkg cfg {
    packages = [ ];
    lspPackages = [
      # provide `nixd`
      pkgs.nixd
    ];
  };
}
