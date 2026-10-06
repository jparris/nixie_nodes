{ ... }: {
  flake.homeModules.photography = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      digikam
      darktable
      (callPackage ../../pkgs/epson-v500-plugin.nix { })
      (callPackage ../../pkgs/vuescan.nix { })
    ];
  };
}
