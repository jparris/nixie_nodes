```
 _  _  ____  _  _  ____  ____    _  _  _____  ____  ____  ___ 
( \( )(_  _)( \/ )(_  _)( ___)  ( \( )(  _  )(  _ \( ___)/ __)
 )  (  _)(_  )  (  _)(_  )__)    )  (  )(_)(  )(_) ))__) \__ \
(_)\_)(____)(_/\_)(____)(____)  (_)\_)(_____)(____/(____)(___/
```

Like Nixie Tubes except it's Nix Configurations.

This repo use the dendratic pattern and indebted to [vimjoyer](https://www.vimjoyer.com/nix/dendritic-home-manager) and [Doc-Steve](https://github.com/Doc-Steve/dendritic-design-with-flake-parts/tree/main).

# Bootstrapping
## Macos / Nix-Darwin
* Install nix `curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh`
* Install nix-darwin `sudo nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes  -- switch --flake ~/src/nixie_nodes`
* Post-install rebuilds `sudo darwin-rebuild switch --flake <path/to/>`.

# NixOS Installs
* [Install Nixos](https://nixos.wiki/wiki/NixOS_Installation_Guide).
* `sudo nixos-rebuild switch --extra-experimental-features nix-command --extra-experimental-features flakes --flake .#<name>`.

# Nodes
## Naming Scheme
I've been using [Norse Mythology](https://namingschemes.com/Norse_Mythology) as a naming scheme for more decades ago than I'd like to admit.

## [DDN12278M](modules/node/DDN12278M/darwin.nix)
* Name: Work laptop which I didn't get to name.
* 2023 14in MacBook Pro.
* Apple M2 Pro.
* 16 GB & 1 TB.

## [idun](modules/node/idun/configuration.nix)
* Name: Norse goddess of eternal youth - because this is a framework 13 pro laptop.
* CPU: AMD Ryzen AI 7 350 w/ Radeon 860M 8 Cores / 16 Threads.
* Storage: WD_BLACK 2TB SN770 NVMe 
* Ram: Crucial RAM 32GB DDR5 5600MHz 
