{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "slack";
  home.packages = [ pkgs.slack ];
}
