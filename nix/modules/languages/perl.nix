{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.perl;
in
{
  config = sys.langPkg cfg {
    packages = with pkgs; [
      perl
      perlPackages.Carton
    ];
    lspPackages = [ pkgs.perlnavigator ];
  };
}
