{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.yaml;
in
{
  config = sys.langPkg cfg {
    packages = [ ];
    lspPackages = [
      # provide `yaml-language-server`
      pkgs.yaml-language-server
    ];
  };
}
