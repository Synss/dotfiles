{
  sys,
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      docker
      docker-credential-helpers
    ]
    ++ sys.onDarwin pkgs.colima; # lightweight Linux VM
}
