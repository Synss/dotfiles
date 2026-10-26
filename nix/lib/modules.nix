_: {
  imports = { dir, modules }: map (name: dir + "/${name}.nix") modules;
}
