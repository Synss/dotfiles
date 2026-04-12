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
  };
}
