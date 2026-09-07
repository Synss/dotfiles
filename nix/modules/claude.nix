{ config, dotfilesDir, ... }:
let
  inherit (import ./lib.nix { inherit config dotfilesDir; }) mkLink;
in
{
  home.file = {
    ".claude/CLAUDE.md" = mkLink "claude/CLAUDE.md";
    ".claude/hooks" = mkLink "claude/hooks";
    ".claude/skills" = mkLink "claude/skills";
  };
}
