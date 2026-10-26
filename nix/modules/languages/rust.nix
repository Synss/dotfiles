{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.rust;
in
{
  config = sys.langPkg cfg {
    packages = [ pkgs.rustup ];
    lspPackages = [ pkgs.starpls ];
  };
}
