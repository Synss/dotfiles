{ sys, ... }: {
  imports = [
    ../profiles/alacritty.nix
    ../profiles/base.nix
  ]
  ++ sys.modules.imports {
    dir = ../modules;
    modules = [
      "containers"
    ];
  };

  languages = {
    ansible.enable = true;
    bash.enable = true;
    github-actions.enable = true;
    json.enable = true;
    lua.enable = true;
    nix.enable = true;
    perl.enable = true;
    python.enable = true;
    ruby.enable = true;
    yaml.enable = true;
  };
}
