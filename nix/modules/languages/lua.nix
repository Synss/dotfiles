{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.lua;
in
{
  config = sys.langPkg cfg {
    packages = [ ];
    lspPackages = [
      # provide `lua_ls`
      pkgs.lua-language-server
    ];
  };
}
