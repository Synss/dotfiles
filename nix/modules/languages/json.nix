{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.json;
in
{
  config = sys.langPkg cfg {
    packages = [ ];
    lspPackages = [
      # cssls eslint html jsonls
      pkgs.vscode-langservers-extracted
    ];
  };
}
