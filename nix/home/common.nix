{ pkgs, ... }:
{
  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "24.11";

    packages = with pkgs; [
      deadnix
      nixfmt
      statix
    ];
  };
}
