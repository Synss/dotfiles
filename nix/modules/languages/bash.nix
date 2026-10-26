{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.bash;
in
{
  config = sys.langPkg cfg {
    packages = [ ];
    lspPackages = [
      # provide `bashls`
      pkgs.bash-language-server
    ];
  };
}
