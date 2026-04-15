{
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
      machines = {
        klapp-0672 = {
          system = "x86_64-linux";
          username = "mathiaslaurin";
        };
        "MacBookAir" = {
          system = "aarch64-darwin";
          username = "laurin";
        };
      };
      mkHome =
        _:
        { system, username }:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          homeDirectory =
            if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
          ]
          ++ nixpkgs.lib.optional pkgs.stdenv.isLinux ./linux.nix
          ++ nixpkgs.lib.optional pkgs.stdenv.isDarwin ./darwin.nix;
          extraSpecialArgs = {
            inherit
              username
              homeDirectory
              nix-index-database
              nixgl
              ;
            dotfilesDir = "${homeDirectory}/src/dotfiles.git";
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
          default = pkgs.mkShell {
            packages = with pkgs; [
              deadnix
              just
              nixfmt-tree
              pre-commit
              shellcheck
              statix
            ];
          };
        }
      );
    };
}
