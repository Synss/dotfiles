_: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "Transparent";
        padding = {
          x = 1;
          y = 1;
        };
        startup_mode = "Fullscreen";
      };
      terminal = {
        shell = {
          program = "zsh";
          args = [ "-l" ];
        };
      };
    };
  };
}
