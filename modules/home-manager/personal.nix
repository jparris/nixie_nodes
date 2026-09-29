{...}: {
  flake.homeModules.desktop = {pkgs, ...}: {
    home.packages = with pkgs;
      [
        obsidian
      ];
  };
}
