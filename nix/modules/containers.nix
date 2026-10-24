{ pkgs, ... }:
{
  home.packages = with pkgs; [
    colima # VM
    docker
    docker-credential-helpers # for `credsStore`
  ];
}
