{
  config,
  lib,
  dotfilesDir,
  ...
}:
let
  inherit (import ./lib.nix { inherit config dotfilesDir; }) mkLink;
  skillNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../../claude/skills)
  );
in
{
  home.file = {
    ".claude/CLAUDE.md" = mkLink "claude/CLAUDE.md";
    ".claude/hooks" = mkLink "claude/hooks";
  }
  // lib.listToAttrs (
    map (name: lib.nameValuePair ".claude/skills/${name}" (mkLink "claude/skills/${name}")) skillNames
  );

  # mkdir -p won't replace an existing symlink, so the rm keeps this a
  # real directory that can hold unmanaged files too.
  home.activation.ensureClaudeSkillsDir = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if [ -L "$HOME/.claude/skills" ]; then
      run rm "$HOME/.claude/skills"
    fi
    run mkdir -p "$HOME/.claude/skills"
  '';
}
