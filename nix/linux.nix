{
  pkgs,
  config,
  nixgl,
  ...
}:
{
  targets.genericLinux.nixGL = {
    packages = nixgl.packages.${pkgs.stdenv.hostPlatform.system};
    defaultWrapper = "mesa";
  };

  programs.alacritty.package = config.lib.nixGL.wrap pkgs.alacritty;
  programs.alacritty.settings = {
    window = {
      padding = {
        x = 1;
        y = 1;
      };
      decorations = "None";
      startup_mode = "Fullscreen";
    };
  };
}
