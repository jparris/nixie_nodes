{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../selfhosted/audiobookshelf.nix
    ../../selfhosted/acme.nix
    ../../selfhosted/esphome.nix
    ../../selfhosted/fava.nix
    ../../selfhosted/home-assistant.nix
    #    ../../services/nextcloud.nix
    #../../services/nginx.nix
    ../../selfhosted/plex.nix
    ../../selfhosted/syncthing.nix
    ../../selfhosted/transmission.nix
    ../../selfhosted/unifi.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;
  services.zfs.autoScrub.enable = true;

  networking.enableIPv6 = false;
  networking.hostId = "DEADFA10";
  networking.hostName = "utgard";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";

  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = ["root" "parrisj"];

  nixpkgs.config.allowUnfree = true;
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  services.transmission.enable = true;
  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  users.users.parrisj = {
    isNormalUser = true;
    extraGroups = ["transmission" "wheel"];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    alejandra # Nix Code Formater
    calibre
    deploy-rs
    ffmpeg
    figlet
    git
    htop
    jq
    ncdu
    neovim
    nmap
    p7zip
    phockup
    python3
    smartmontools
    starship
    tmux
    unrar-wrapper
    unzip
    wget
    zoxide
  ];
  # agenix.packages.${system}.default

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.avahi.enable = true;

  services.openssh = {
    enable = true;
    settings.Macs = ["hmac-sha2-512-etm@openssh.com" "hmac-sha2-256-etm@openssh.com" "umac-128-etm@openssh.com" "hmac-sha2-512"];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
