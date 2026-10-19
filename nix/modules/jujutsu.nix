{ pkgs, lib, ... }:
let
  jj-pr = pkgs.writers.writeDashBin "jj-pr" ''
    # USAGE: jj-pr feature-x --fill
    name=''${1:?bookmark name}
    shift
    jj git push --bookmark "$name" && gh pr create --head "$name" "$@"
  '';
in
{
  home.packages = [
    pkgs.lazyjj
    jj-pr
  ];

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = lib.mkDefault "Mathias Laurin";
        email = lib.mkDefault "Mathias.Laurin+github.com@gmail.com";
      };
      aliases = {
        l = [ "log" ];
        la = [
          "log"
          "-r"
          "all()"
        ];
        ld = [
          "log"
          "-T"
          "d"
        ];
        pr = [
          "util"
          "exec"
          "--"
          "jj-pr"
        ];
        tug = [
          "bookmark"
          "advance"
        ];
      };
      revsets.bookmark-advance-to = "closest_pushable(@)";
      revset-aliases = {
        # `jj l -r by("Alice")` to filter by author.
        "by(x)" = "author(substring:x)";
        "closest_pushable(to)" =
          ''heads(::to & mutable() & ~description(exact:" ") & (~empty() | merges()))'';

        # House keeping: `jj log -r pending()`, `-r submitted()`, `-r wip()`.
        "pending()" = "mine() & mutable() & bookmarks()";
        "submitted()" = "pending() & remote_bookmarks()";
        "wip()" = "mine() & mutable() & ~bookmarks()";
      };
      template-aliases = {
        # `jj ... -T d`
        d = "builtin_log_detailed";
      };
      templates = {
        draft_commit_description = ''
          concat(
          builtin_draft_commit_description,
          "\nJJ: ignore-rest\n",
          diff.git(),
          )
        '';
      };
      ui.pager = "less -FRX";
      core.watchman.register_snapshot_trigger = true; # requires watchman daemon
    };
  };
}
