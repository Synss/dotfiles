_: {
  imports =
    { dir, modules }:
    map (
      name:
      let
        path = dir + "/${name}";
      in
      if builtins.pathExists (path + ".nix") then
        path + ".nix"
      else if builtins.pathExists (path + "/default.nix") then
        path + "/default.nix"
      else
        throw "No module found for ${toString path}"
    ) modules;
}
