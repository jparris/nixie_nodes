{inputs, ...}: let
  nym = "parrisj";
in {
  flake.modules.nixos.idun = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      desktop
    ];
    home-manager = {
      useGlobalPkgs = true;
      users."${nym}".imports = with inputs.self.homeModules; [
        desktop
        parrisj
      ];
    };

    nix.enable = true;
    nix.extraOptions = ''
      warn-dirty = false
    '';

    nixpkgs.config.allowUnfree = true;
    users.users."${nym}" = {
      home = "/home/${nym}";
      shell = "${pkgs.zsh}/bin/zsh";
      isNormalUser = true;
      extraGroups = ["wheel"];
    };

    security.sudo.wheelNeedsPassword = false;
    # Use the systemd-boot EFI boot loader.
    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      initrd.kernelModules = ["amdgpu"];
      supportedFilesystems = ["ntfs"];
    };

    environment.systemPackages = with pkgs; [
      # Shell
      gnupg
      #      git
      #      gitAndTools.git-annex
      #      gitAndTools.gitRemoteGcrypt
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
    ];

    #  environment.shells = [pkgs.zsh];

    #  fonts.packages = with pkgs; [
    #    noto-fonts
    #    noto-fonts-cjk-sans
    #    noto-fonts-emoji
    #    nerd-fonts.fira-code
    #  ];

    hardware.pulseaudio = {
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
      #light.enable = true;
      #    gnupg.agent.enable = true;
      zsh.enable = true;
    };

    security.sudo.enable = true;

    #  services.displayManager.defaultSession = "none+i3";

    services.fwupd.enable = true;

    services.openssh.enable = true;

    #services.xserver = {
    #    enable = true;
    #    videoDrivers = ["amdgpu"];
    #    desktopManager.xterm.enable = false;
    #    windowManager.i3 = {
    #      enable = true;
    #      extraPackages = with pkgs; [
    #        networkmanagerapplet
    #        rofi
    #        i3lock
    #        i3status
    #        i3blocks
    #      ];
    #    };
    #  };

    system.stateVersion = "26.05";

    time.timeZone = "America/Denver";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "idun";
}
