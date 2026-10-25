{ mod, ... }:
{
  home.file = {
    ".local/bin/j2y" = mod.mkLink "bin/j2y";
    ".local/bin/y2j" = mod.mkLink "bin/y2j";
  };
}
