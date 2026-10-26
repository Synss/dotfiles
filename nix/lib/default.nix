{ lib, pkgs }:
(import ./platform.nix { inherit lib pkgs; })
// {
  modules = import ./modules.nix { };
}
