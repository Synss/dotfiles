{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.python;
in
{
  config = sys.langPkg cfg {
    packages = [ pkgs.uv ];
    lspPackages = [
      pkgs.basedpyright
      pkgs.ruff
    ];
  };
}
