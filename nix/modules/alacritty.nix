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
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
  ];

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
