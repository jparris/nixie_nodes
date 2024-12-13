```
 _  _  ____  _  _  ____  ____    _  _  _____  ____  ____  ___ 
( \( )(_  _)( \/ )(_  _)( ___)  ( \( )(  _  )(  _ \( ___)/ __)
 )  (  _)(_  )  (  _)(_  )__)    )  (  )(_)(  )(_) ))__) \__ \
(_)\_)(____)(_/\_)(____)(____)  (_)\_)(_____)(____/(____)(___/
```

Like Nixie Tubes except it's Nix Configurations.

This repo is inspired by [Paul Grandperrin's](https://github.com/PaulGrandperrin/nix-systems).

# Bootstrapping
## Home Manager on Other Distros
* [Install Nix](https://nixos.org/download/#nix-install-linux)
* Enable Flakes
* Boostrap Home Manager
    * `nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager`
    * `nix-channel --update`
    * `nix-shell -p home-mananger`
* `home-manager switch --flake .#<name>`

## Macos / Nix-Darwin
* [Determinate Systems Installer](https://github.com/DeterminateSystems/nix-installer).
* Install nix-darwin `nix run nix-darwin -- switch --flake <path/to/mac_config>`.
* `darwin-rebuild switch --flake .#<name>`.

## NixOS Installs
* [Install Nixos](https://nixos.wiki/wiki/NixOS_Installation_Guide).
* Enable flakes `nix.settings.experimental-features = [ "nix-command" "flakes" ];`.
* `sudo nixos-rebuild switch --flake .#<name>`.

# Nodes 
## Naming Scheme
I've been using [Norse Mythology](https://namingschemes.com/Norse_Mythology) as a naming scheme for more decades ago than I'd like to admit.

## [DDN12278M](darwin/ddn12287m.nix) (Work laptop which I didn't get to name)
* 2023 14in MacBook Pro 
* Apple M2 Pro
* 16 GB & 1 TB

## [utgard](nixos/utgard) - Home of the Jötunn a.k.a. Frost Giants
* My first custom PC build.
* Parts:
  - StreamCom DA2 V2 Case
  - ASRock B550 Phantom Gaming-ITX
  - AMD Ryzen 5 5600x
  - 2 x 32GB DDR4 ECC Unbuffered UDIMM
  - Nvidia Quadro K2200
  - Corsair SF450
  - 2 x Noctua NF-P14 140mm
  - Noctual NH-L9a-AM5 CPU Cooler
  - 512 GB Team Group SSD Boot Drive
  - 2 x 14TB Western Digital HC530
  - 2 x Sabrent 1TB SSD for Cache
