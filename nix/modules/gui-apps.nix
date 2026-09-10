{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "google-chrome"
      "slack"
    ];
  home.packages = with pkgs; [
    google-chrome
    slack
  ];
}
