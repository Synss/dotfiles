{ lib, ... }:
let
  modules = lib.filterAttrs (
    name: type: (name != "default.nix") && (type == "directory" || lib.hasSuffix ".nix" name)
  ) (builtins.readDir ./.);
  langNames = map (name: lib.removeSuffix ".nix" name) (lib.attrNames modules);
  modulePaths = map (name: ./. + "/${name}") (lib.attrNames modules);
in
{
  imports = modulePaths;
  options.languages = lib.genAttrs langNames (lang: {
    enable = lib.mkEnableOption "${lang} development environment";
    lsp = {
      enable = lib.mkEnableOption "${lang} language server" // {
        default = true;
      };
    };
  });
}
