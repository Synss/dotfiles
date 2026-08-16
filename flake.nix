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
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      machines = import ./nix/hosts.nix;
      overlay =
        _: prev:
        nixpkgs.lib.mapAttrs' (
          name: _:
          nixpkgs.lib.nameValuePair name (prev.callPackage (./nix/packages + "/${name}/package.nix") { })
        ) (nixpkgs.lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./nix/packages));

      mkHome =
        _:
        {
          system,
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
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./nix/home.nix
          ]
          ++ nixpkgs.lib.optional pkgs.stdenv.isLinux ./nix/linux.nix
          ++ nixpkgs.lib.optional pkgs.stdenv.isDarwin ./nix/darwin.nix;
          extraSpecialArgs = {
            inherit
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
