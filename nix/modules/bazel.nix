{ pkgs, ... }:
{
  home.packages = [
    pkgs.bazelisk
    pkgs.perfetto # Profile analysis
    pkgs.lcov # Coverage report
  ];
}
