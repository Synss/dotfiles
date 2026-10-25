{ lib, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  home.packages =
    (lib.optionals isDarwin [
      pkgs.colima # lightweight Linux VM
    ])
    ++ (with pkgs; [
      docker
      docker-credential-helpers
    ]);
}
