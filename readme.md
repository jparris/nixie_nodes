```
 _  _  ____  _  _  ____  ____    _  _  _____  ____  ____  ___ 
( \( )(_  _)( \/ )(_  _)( ___)  ( \( )(  _  )(  _ \( ___)/ __)
 )  (  _)(_  )  (  _)(_  )__)    )  (  )(_)(  )(_) ))__) \__ \
(_)\_)(____)(_/\_)(____)(____)  (_)\_)(_____)(____/(____)(___/
```

# Introduction

If this is your first time wandering into a nix configuration, know this nix is a language for defining immutable and reproducible configurations for Linux, MacOS, and other systems. 

Is this a perfect example? No but it's mine. This configuration uses the dendritic pattern and is indebted to [vimjoyer](https://www.vimjoyer.com/nix/dendritic-home-manager) and [Doc-Steve](https://github.com/Doc-Steve/dendritic-design-with-flake-parts/tree/main).

# NixOS Installs
* [Install Nixos](https://nixos.wiki/wiki/NixOS_Installation_Guide).
* `sudo nixos-rebuild switch --extra-experimental-features nix-command --extra-experimental-features flakes --flake .#<name>`.

# Nodes
## Naming Scheme
I've been using [Norse Mythology](https://namingschemes.com/Norse_Mythology) as a naming scheme for more decades ago than I'd like to admit.

## [DDN12278M](modules/nodes/DDN12278M/darwin.nix)
* Name: Work laptop which I didn't get to name.
* 2023 14in MacBook Pro.
* Apple M2 Pro.
* 16 GB & 1 TB.

## [idun](modules/node/idun/configuration.nix)
* Name: Norse goddess of eternal youth - because this is a framework 13 pro laptop.
* CPU: AMD Ryzen AI 7 350 w/ Radeon 860M 8 Cores / 16 Threads.
* Storage: WD_BLACK 2TB SN770 NVMe 
* Ram: Crucial RAM 32GB DDR5 5600MHz 

## [utgard](modules/nodes/idun/configuration.nix)
* Name: Home of the Jötunn a.k.a. Frost Giants
* My first custom PC build.
* Parts:
  - StreamCom DA2 V2 Case
  - ASRock B550 Phantom Gaming-ITX
  - AMD Ryzen 5 5600x. 6 cores & 12 threads.
  - 2 x 32GB DDR4 ECC Unbuffered UDIMM
  - Nvidia Quadro K2200
  - Corsair SF450
  - 2 x Noctua NF-P14 140mm
  - Noctua NH-L9a-AM5 CPU Cooler
  - 512 GB Team Group SSD Boot Drive
  - 2 x 14TB Western Digital HC530
  - 2 x Sabrent 1TB SSD for Cache

# Bootstrapping Notes
## Macos / Nix-Darwin
* Install nix `curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh`
* Install nix-darwin `sudo nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes  -- switch --flake ~/src/nixie_nodes`
* Post-install rebuilds `sudo darwin-rebuild switch --flake <path/to/>`.

## NixOS 
* [Install Nixos](https://nixos.wiki/wiki/NixOS_Installation_Guide).
* `sudo nixos-rebuild switch --extra-experimental-features flakes --flake .#<name>`.
