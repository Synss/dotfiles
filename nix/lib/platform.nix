{ pkgs }:
let
  inherit (pkgs) lib;

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;

  wrapPlatform =
    cond: input: if builtins.isList input then lib.optionals cond input else lib.optional cond input;
in
{
  inherit isDarwin isLinux;

  ifLinux = lib.mkIf isLinux;
  ifDarwin = lib.mkIf isDarwin;

  onLinux = wrapPlatform isLinux;
  onDarwin = wrapPlatform isDarwin;
}
