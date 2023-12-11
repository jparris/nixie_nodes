{
  description = "Our house (lab) in the middle of the street";

  # Usage 
  #  - Local 'nixos-rebuild --flake .#node'
  #  - Deploy 'deploy .#node'
  inputs = {
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixpkgs.url = "github:nixos/nixpkgs";
  };
  outputs = { self, agenix, deploy-rs, nixpkgs, ... } @ inputs:
  {
    nixosConfigurations.utgard = nixpkgs.lib.nixosSystem {
	  system = "x86_64-linux";
	  modules = [ 
	  	./nodes/utgard/configuration.nix
		agenix.nixosModules.default
		{
			environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
		}
	  ];
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
