{ sys, ... }: {
  imports = sys.modules.imports {
    dir = ../modules;
    modules = [
      "alacritty"
      "tmux"
    ];
  };
}
