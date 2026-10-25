{
  config,
  lib,
  nixgl,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  programs.alacritty = {
    enable = true;
    package = lib.mkIf isLinux (config.lib.nixGL.wrap pkgs.alacritty);

    settings = {
      window = {
        decorations = if isDarwin then "Transparent" else "None";
        padding = {
          x = 1;
          y = 1;
        };
        startup_mode = "Fullscreen";
      };

      terminal.shell = {
        program = "zsh";
        args = [ "-l" ];
      };

      font = {
        normal.family = "JetBrainsMono Nerd Font Mono";
        size = 12.0;
      };
    };
  };

  targets.genericLinux.nixGL = lib.mkIf isLinux {
    packages = nixgl.packages.${pkgs.stdenv.hostPlatform.system};
    defaultWrapper = "mesa";
  };
}
