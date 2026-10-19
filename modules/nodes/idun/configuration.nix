{ inputs, ... }:
let
  nym = "parrisj";
in
{
  flake.modules.nixos.idun = { pkgs, ... }: {
    imports = with inputs.self.modules.nixos; [
      desktop-niri
      printing
    ];

    home-manager = {
      users."${nym}".imports = with inputs.self.homeModules; [
        desktop
        parrisj
        personal
      ];
    };

    services.udev = {
      enable = true;
      extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="c000", GROUP="plugdev", MODE="0660"
      '';
    };

    hardware.logitech.wireless.enable = true;

    nix.enable = true;
    nix.extraOptions = ''
      warn-dirty = false
    '';

    users.users."${nym}" = {
      home = "/home/${nym}";
      shell = "${pkgs.zsh}/bin/zsh";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    security.sudo.wheelNeedsPassword = false;
    # Use the systemd-boot EFI boot loader.
    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      initrd.kernelModules = [ "amdgpu" ];
      supportedFilesystems = [ "ntfs" ];
    };

    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      # Shell
      gnupg
      git-annex
      wezterm
      htop
      man-pages
      mr
      pass
      #posix_man_pages
      pavucontrol
      orca-slicer
      sudo
      fd
      claude-code
      chromium
      bambu-studio
      libation
      solaar
      headscale
    ];

    networking.firewall.allowedTCPPorts = [ 5091 ];
    services.pulseaudio = {
      enable = false;
    };

    networking.hostName = "idun"; # Norse goddess of eternal youth - because this is a framework laptop.
    networking.networkmanager.enable = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    programs = {
      browserpass.enable = true;
      firefox.enable = true;
      zsh.enable = true;
    };

    services.pcscd.enable = true;
    programs.gnupg.agent = {
      enable = true;
    };

    security.sudo.enable = true;

    services.fwupd.enable = true;

    services.openssh.enable = true;

    system.stateVersion = "26.05";

    time.timeZone = "America/Denver";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "idun";
}
