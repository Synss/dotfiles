{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.ansible;
in
{
  config = sys.langPkg cfg {
    packages = [ ];
    lspPackages = [
      # provide `ansiblels`
      pkgs.ansible-language-server
      # provide `yaml-language-server`
      pkgs.yaml-language-server
    ];
  };
}
