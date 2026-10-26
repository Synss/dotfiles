{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.cc;
in
{
  config = sys.langPkg cfg {
    packages = [ ];
    lspPackages = [ pkgs.clang-tools ];
  };
}
