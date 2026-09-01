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
* [Determinate Systems Installer](https://github.com/DeterminateSystems/nix-installer).
* Install nix-darwin `sudo nix run nix-darwin -- switch --flake <path/to/flake.nix>`.
* `darwin-rebuild switch --flake .#<name>`.

# Nodes
## [DDN12278M](modules/hosts/DDN12278M/darwin.nix)
* Name: Work laptop which I didn't get to name
* 2023 14in MacBook Pro 
* Apple M2 Pro
* 16 GB & 1 TB

# Repo Layout
* modules/darwin
* modules/flake-parts
* modules/hosts/DDN12287M
* modules/parts.nix
