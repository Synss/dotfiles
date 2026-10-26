{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.javascript;
in
{
  config = sys.langPkg cfg {
    packages = with pkgs; [
      nodejs
      pnpm
    ];
  };
}
