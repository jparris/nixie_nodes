{inputs, ...}: {
  imports = [
    # adds home-manager options to flake-parts
    inputs.home-manager.flakeModules.home-manager
    # enables support of flake-parts modules
    inputs.flake-parts.flakeModules.modules
  ];

  config.systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];
}
