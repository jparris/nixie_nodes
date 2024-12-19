inputs: let
  mkNixosConf = arch: stability: modules: let
    selectFlake = stable: unstable: {inherit stable unstable;}.${stability};
    home-manager-flake = selectFlake inputs.home-manager-stable inputs.home-manager-unstable;
    nixos-flake = selectFlake inputs.nixos-stable inputs.nixos-unstable;
  in
    nixos-flake.lib.nixosSystem {
      inherit modules;
      specialArgs = {inherit inputs nixos-flake home-manager-flake;};
      system = arch;
    };
in {
  "idun" = mkNixosConf "x64_64-linux" "unstable" [./idun/configuration.nix];
  "utgard" = mkNixosConf "x64_64-linux" "unstable" [inputs.agenix.nixosModules.default ./utgard/configuration.nix];
}
