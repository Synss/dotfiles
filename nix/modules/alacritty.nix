{
  config,
  sys,
  nixgl,
  pkgs,
  ...
}:
{
  programs.alacritty = {
    enable = true;
    package = sys.ifLinux (config.lib.nixGL.wrap pkgs.alacritty);

    settings = {
      window = {
        decorations = if sys.isDarwin then "Transparent" else "None";
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

  targets.genericLinux.nixGL = sys.ifLinux {
    packages = nixgl.packages.${pkgs.stdenv.hostPlatform.system};
    defaultWrapper = "mesa";
  };
}
