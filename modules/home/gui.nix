{inputs, ...}: {
  flake.modules.home.guiApps = {pkgs, ...}: {
    home.packages = [pkgs.Feishin];
    home.stateVersion = "26.05";
  };
}
