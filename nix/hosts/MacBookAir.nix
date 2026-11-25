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

  services.colima.profiles = {
    linux.settings.memory = 2;
    linux-amd64.settings.memory = 2;
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
