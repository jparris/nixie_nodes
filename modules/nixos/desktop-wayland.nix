{inputs, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    services.pipewire.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.Hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        # Deskflow's Wayland input capture; only the hyprland backend implements it.
        "org.freedesktop.impl.portal.InputCapture" = ["hyprland"];
        "org.freedesktop.impl.portal.RemoteDesktop" = ["hyprland"];
      };
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    environment.systemPackages = with pkgs; [
      hyprshade
      hyprlauncher
      playerctl
      brightnessctl
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # Must go through uwsm so the compositor runs inside the systemd user
          # session. Launching start-hyprland directly leaves
          # graphical-session.target inactive, and xdg-desktop-portal.service has
          # Requisite=graphical-session.target, so portals never start.
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd '${pkgs.uwsm}/bin/uwsm start -e -D Hyprland hyprland.desktop'";
          user = "greeter";
        };
      };
    };

    #security.polkit.enable = true;
    #    security.rtkit.enable = true;
    #    services.gnome.gnome-keyring.enable = true;
    #    security.pam.services.swaylock = {};
  };
}
