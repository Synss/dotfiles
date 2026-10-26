{ pkgs }:
(import ./platform.nix { inherit pkgs; })
// {
  modules = import ./modules.nix { };
}
