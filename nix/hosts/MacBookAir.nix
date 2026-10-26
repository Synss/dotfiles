{ sys, ... }: {
  imports = [
    ../profiles/alacritty.nix
    ../profiles/base.nix
  ]
  ++ sys.modules.imports {
    dir = ../modules;
    modules = [
      "containers"
      "perl"
      "python"
      "ruby"
    ];
  };
}
