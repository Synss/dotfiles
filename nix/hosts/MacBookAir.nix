{ sys, ... }: {
  imports = sys.modules.imports {
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
      "perl"
      "python"
      "ruby"
      "shell"
      "tmux"
    ];
  };
}
