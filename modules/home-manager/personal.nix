{ ... }: {
  flake.homeModules.personal = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      obsidian
    ];

    programs.calibre.enable = true;
  };
}
