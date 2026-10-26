{ mod, ... }:
{
  home.file = {
    ".local/bin/j2y" = mod.mkLink "tools/j2y";
    ".local/bin/y2j" = mod.mkLink "tools/y2j";
  };
}
