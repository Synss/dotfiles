{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.groovy;
in
{
  config = sys.langPkg cfg {
    packages = [ ];
    lspPackages = [
      # provide `groovyls`
      pkgs.groovy-language-server
    ];
  };
}
