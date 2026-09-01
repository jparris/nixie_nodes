# From: https://github.com/Doc-Steve/dendritic-design-with-flake-parts/blob/main/modules/nix/flake-parts%20%5B%5D/lib.nix
# License: MIT
{
  inputs,
  lib,
  ...
}: {
  # Helper functions for creating system / home-manager configurations

  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = {};
  };

  config.flake.lib = {
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.self.modules.nixos.${name}
          {nixpkgs.hostPlatform = lib.mkDefault system;}
        ];
      };
    };

    mkDarwin = system: name: {
      ${name} = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          inputs.home-manager.darwinModules.home-manager
          inputs.self.modules.darwin.${name}
          {nixpkgs.hostPlatform = lib.mkDefault system;}
        ];
      };
    };

    mkHomeManager = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          inputs.self.modules.homeManager.${name}
          {nixpkgs.config.allowUnfree = true;}
        ];
      };
    };
  };
}
