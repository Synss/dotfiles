{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.ruby;
in
{
  config = sys.langPkg cfg {
    packages = [ pkgs.ruby ];
    lspPackages = [ pkgs.ruby-lsp ];
  };
}
