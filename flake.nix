{
  description = "Our house (lab) in the middle of the street";

  # Usage
  #  - Local 'nixos-rebuild --flake .#node'
  #  - Deploy 'deploy .#node'
  inputs = {
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = {
    self,
    agenix,
    deploy-rs,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations.idun = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nodes/idun/configuration.nix
        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.parrisj = import ./home-manager/home.nix;
        }
        agenix.nixosModules.default
        {
          environment.systemPackages = [agenix.packages.x86_64-linux.default];
        }
      ];
      specialArgs = {inherit inputs;};
    };
    nixosConfigurations.utgard = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nodes/utgard/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.parrisj = import ./home-manager/home.nix;
        }
        agenix.nixosModules.default
        {
          environment.systemPackages = [agenix.packages.x86_64-linux.default];
        }
      ];
      specialArgs = {inherit inputs;};
    };

    deploy.nodes.utgard = {
      hostname = "192.168.1.235";
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.utgard;
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
