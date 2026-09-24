{...}: {
  flake.homeModules.desktop = {pkgs, ...}: {
    home.packages = with pkgs;
      [
        feishin
        obsidian
        wezterm
      ]
      ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin (
        with pkgs; [
          hidden-bar
          tailscale
        ]
      );
  };
}
