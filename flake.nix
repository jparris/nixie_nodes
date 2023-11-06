{
  description = "Our house (lab) in the middle of the street";

  inputs.deploy-rs.url = "github:serokell/deploy-rs";
  outputs = { self, nixpkgs, deploy-rs }: {
    nixosConfigurations.utgard = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./nodes/utgard/configuration.nix ];
      };

      deploy.nodes.utgard.hostname = "192.168.1.235";
    deploy.nodes.utgard.profiles.system = {
      user = "root";
      path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.utgard;
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
