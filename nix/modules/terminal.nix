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
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
  ];

  home.file.".config/dotfiles" = mkLink "shared";

  programs = {
    alacritty = {
      enable = true;
      settings = {
        terminal.shell = {
          program = "zsh";
          args = [ "-l" ];
        };
        font = {
          normal.family = "JetBrainsMono Nerd Font Mono";
          size = 12.0;
        };
      };
    };

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
