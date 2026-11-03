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
      k3d
      kubectl
      tilt
    ]
    ++ sys.onLinux pkgs.k3s
    ++ sys.onDarwin pkgs.colima; # lightweight Linux VM
}
