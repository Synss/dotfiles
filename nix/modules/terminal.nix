{
  pkgs,
  config,
  dotfilesDir,
  ...
}:
let
  inherit (import ./lib.nix { inherit config dotfilesDir; }) mkLink;
in
{
  home.file = {
    ".config/dotfiles" = mkLink "shared";
    ".local/bin/j2y" = mkLink "bin/j2y";
    ".local/bin/y2j" = mkLink "bin/y2j";
  };

  programs = {
    tmux = {
      enable = true;
      prefix = "C-Space";
      mouse = true;
      terminal = "tmux-256color";
      keyMode = "vi";
      escapeTime = 0;
      extraConfig = ''
        set -ga terminal-overrides ",*:Tc"
        bind C-Space send-prefix
      '';
      plugins = with pkgs.tmuxPlugins; [
        resurrect
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
          '';
        }
      ];
    };
  };
}
