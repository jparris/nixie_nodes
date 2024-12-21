{
  description = "Jon Parris's Nix Configs";

  inputs = {
    # General Flakes
    agenix.url = "github:ryantm/agenix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # NixOs Flakes
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Darwin Flakes & Urls
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    # darwin-unstable for now (https://github.com/NixOS/nixpkgs/issues/107466)
    darwin-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    darwin-home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "darwin-stable";
    };

    darwin-home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "darwin-unstable";
    };
  };

  outputs = inputs: {
    darwinConfigurations = import ./darwin/mod.nix inputs;
    nixosConfigurations = import ./nixos/mod.nix inputs;
  };
}
