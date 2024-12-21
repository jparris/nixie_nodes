{
  config,
  lib,
  home-manager-flake,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    home-manager-flake.nixosModules.home-manager
  ];

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
    git
    gitAndTools.git-annex
    gitAndTools.gitRemoteGcrypt
    wezterm
    htop
    man-pages
    mr
    pass
    #posix_man_pages
    vim
    pavucontrol
    orca-slicer
    sudo
    fd
  ];

  environment.shells = [pkgs.zsh];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.fira-code
  ];

  hardware.pulseaudio = {
    enable = false;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.parrisj = {
      imports = [
        ../../home-manager/home.nix
      ];
    };
  };

  networking.hostName = "idun"; # Norse goddess of eternal youth - because this is a framework laptop.
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [53317];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  programs = {
    browserpass.enable = true;
    firefox.enable = true;
    light.enable = true;
    gnupg.agent.enable = true;
    zsh.enable = true;
  };

  security.sudo.enable =  true;

  services.displayManager.defaultSession = "none+i3";

  services.openssh.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        networkmanagerapplet
        rofi
        i3lock
        i3status
        i3blocks
      ];
    };
  };

  system.stateVersion = "24.05";

  time.timeZone = "America/Denver";

  users.users.parrisj = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };
}
