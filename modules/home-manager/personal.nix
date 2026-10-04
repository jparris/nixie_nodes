{...}: {
  flake.homeModules.personal = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      obsidian
      digikam
      darktable
      (callPackage ../../pkgs/epson-v500-plugin.nix {})
      (callPackage ../../pkgs/vuescan.nix {})
    ];

    programs.calibre.enable = true;
  };
}
