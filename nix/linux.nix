{
  pkgs,
  config,
  nixgl,
  ...
}:
{
  targets.genericLinux.nixGL = {
    packages = nixgl.packages.${pkgs.system};
    defaultWrapper = "mesa";
  };

  programs.alacritty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.alacritty;
    settings = {
      window = {
        padding = {
          x = 1;
          y = 1;
        };
        startup_mode = "Fullscreen";
      };
    };
  };
}
