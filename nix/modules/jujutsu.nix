{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.lazyjj ];

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
          "builtin_log_detailed"
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
