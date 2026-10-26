{
  config,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.languages.github-actions;
in
{
  config = sys.langPkg cfg {
    packages = [ ];
    lspPackages = [
      # provide `gh_action_ls`
      pkgs.actions-languageserver
      # provide `yaml-language-server`
      pkgs.yaml-language-server
    ];
  };
}
