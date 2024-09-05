{
  description = "DDN Work Laptop flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    home-manager,
    nixpkgs,
  }: {
    darwinConfigurations = {
      "DDN12287M" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              users.jparris = import ../../home-manager/home.nix;
            };
            users.users.jparris.home = "/Users/jparris";
          }
        ];
        specialArgs = {inherit inputs;};
      };
    };
  };
}
