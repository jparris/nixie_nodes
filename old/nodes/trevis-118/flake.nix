{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: {
    homeConfigurations.jparris = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ../../home-manager/home.nix
        {
          home = {
            homeDirectory = "/home/jparris";
            username = "jparris";
            stateVersion = "24.05";
          };
        }
      ];
    };
  };
}
