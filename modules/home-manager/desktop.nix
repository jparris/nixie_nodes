{...}: {
  flake.homeModules.desktop = {pkgs, ...}: {
    home.packages = with pkgs;
      [
        feishin
        wezterm
        (callPackage ../../pkgs/glide.nix { })
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
