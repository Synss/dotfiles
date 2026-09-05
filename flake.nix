{
  nixConfig = {
    warn-dirty = false;
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-index-database,
      nixgl,
      ...
    }:
    let
      machines = import ./nix/hosts.nix;
      forAllSystems = nixpkgs.lib.genAttrs (
        nixpkgs.lib.unique (map (host: host.system) (nixpkgs.lib.attrValues machines))
      );
      overlay =
        _: prev:
        let
          # Self-named overrides (nil, bash-language-server) need prev's attribute
          # passed explicitly, or callPackage recurses into its own override.
          selfOverrideArgs = {
            nil = { inherit (prev) nil; };
            bash-language-server = { inherit (prev) bash-language-server; };
            jujutsu = { inherit (prev) jujutsu; };
          };
        in
        nixpkgs.lib.mapAttrs' (
          name: _:
          nixpkgs.lib.nameValuePair name (
            prev.callPackage (./nix/packages + "/${name}/package.nix") (selfOverrideArgs.${name} or { })
          )
        ) (nixpkgs.lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./nix/packages));

      mkHome =
        name:
        {
          system,
          stateVersion,
          username,
          dotfilesSubpath ? "src/dotfiles.git",
        }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
          homeDirectory =
            if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
          hostModule = ./nix/hosts + "/${name}.nix";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./nix/home.nix
          ]
          ++ nixpkgs.lib.optional pkgs.stdenv.hostPlatform.isLinux ./nix/linux.nix
          ++ nixpkgs.lib.optional pkgs.stdenv.hostPlatform.isDarwin ./nix/darwin.nix
          ++ nixpkgs.lib.optional (builtins.pathExists hostModule) hostModule;
          extraSpecialArgs = {
            inherit
              stateVersion
              username
              homeDirectory
              nix-index-database
              nixgl
              ;
            dotfilesDir = "${homeDirectory}/${dotfilesSubpath}";
          };
        };
    in
    {
      homeConfigurations = nixpkgs.lib.mapAttrs mkHome machines;

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = import ./nix/dev.nix { inherit pkgs; };
        }
      );
    };
}
