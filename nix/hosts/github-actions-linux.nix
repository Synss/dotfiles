{ sys, ... }: {
  imports = sys.importModules {
    dir = ../modules;
    modules = [
      "alacritty"
      "bin"
      "claude"
      "comma"
      "containers"
      "fonts"
      "git"
      "jujutsu"
      "neovim"
      "packages"
      "shell"
      "tmux"
    ];
  };
}
