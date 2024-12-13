inputs: let
  mkDarwinConf = arch: stability: module: let
    selectFlake = stable: unstable: {inherit stable unstable;}.${stability};
    darwin-pkgs = selectFlake inputs.darwin-stable inputs.darwin-unstable;
    home-manager-flake = selectFlake inputs.home-manager-stable inputs.home-manager-unstable;
    nix-darwin.inputs.follows = selectFlake inputs.darwin-stable inputs.darwin-unstable;
  in
    inputs.nix-darwin.lib.darwinSystem {
      system = arch;
      pkgs = import darwin-pkgs {system = arch;};
      specialArgs = {inherit inputs home-manager-flake;}; # passes inputs and main flakes to modules
      modules = [module];
    };
in {
  "ddn" = mkDarwinConf "aarch64-darwin" "unstable" ./ddn12287m.nix;
}
