{...}: {
  flake.homeModules.desktop = {pkgs, ...}: {
    home.packages = with pkgs;
      [
        feishin
        wezterm
      ]
      ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin (
        with pkgs; [
          hidden-bar
          tailscale
        ]
      );
    programs = {
      neovide = {
        enable = true;
        settings = {
          chdir = "~/src";
        };
      };
      zed-editor = {
        enable = true;
      };
    };
  };
}
