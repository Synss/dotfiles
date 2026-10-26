{ pkgs }:
(import ./platform.nix { inherit pkgs; })
// {
  langPkg = import ./lang.nix { inherit (pkgs) lib; };
  modules = import ./modules.nix { };
}
