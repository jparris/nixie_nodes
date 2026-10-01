{inputs, ...}: {
  flake.modules.nixos.desktop-niri = {pkgs, ...}: {
    programs.niri = {
      enable = true;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    environment.systemPackages = with pkgs; [
      fuzzel
      playerctl
      brightnessctl
      swaylock
      mako
      swayidle
      xwayland-satellite
    ];

    xdg.portal.config.niri = {
      "org.freedesktop.impl.portal.FileChooser" = ["gtk"]; # or "kde"
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # Must go through uwsm so the compositor runs inside the systemd user
          # session. Launching start-hyprland directly leaves
          # graphical-session.target inactive, and xdg-desktop-portal.service has
          # Requisite=graphical-session.target, so portals never start.
          command = "${pkgs.tuigreet}/bin/tuigreet --background matrix --cmd niri-session";
          user = "greeter";
        };
      };
    };

    security.polkit.enable = true; # polkit
    services.gnome.gnome-keyring.enable = true; # secret service
    security.pam.services.swaylock = {};

    programs.waybar.enable = true; # top bar
    #security.polkit.enable = true;
    #    security.rtkit.enable = true;
    #    services.gnome.gnome-keyring.enable = true;
    #    security.pam.services.swaylock = {};
  };
}
