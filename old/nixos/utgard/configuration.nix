{
  inputs,
  config,
  pkgs,
  home-manager-flake,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    # Self Hosted Services
    ## Etc
    ./services/fava.nix
    ./services/syncthing.nix

    ## Media Services
    ./services/audiobookshelf.nix
    ./services/miniflux.nix
    ./services/soft-serve.nix
    ./services/qbittorrent.nix
    ./services/caddy.nix

    ## Smart Home
    ../../modules/containers/home-assistant.nix
    ../../modules/containers/zwave-js-ui.nix
    ./services/esphome.nix
    #./services/zigbee2mqtt.nix
    #home-manager-flake.nixosModules.home-manager
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = ["i2c-dev"];

  boot.binfmt.emulatedSystems = ["riscv32-linux"];
  boot.supportedFilesystems = ["hfsplus" "zfs"];
  boot.zfs.forceImportRoot = false;
  services.zfs.autoScrub.enable = true;

  networking.enableIPv6 = false;
  networking.hostId = "DEADFA10";
  networking.hostName = "utgard";
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;
  time.timeZone = "America/Denver";
  #services.tailscale.enable = true;
  #services.resolved = {
  #    enable = true;
  #    settings.Resolve.DNS = [1.1.1.1];
  #};
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

  environment.shells = [pkgs.zsh];

  services.silverbullet = {
    enable = true;
    listenPort = 3333;
    listenAddress = "0.0.0.0";
  };

  #home-manager = {
  #extraSpecialArgs = config._module.specialArgs;
  #useGlobalPkgs = true;
  #useUserPackages = true;
  #users.parrisj = {
  #  imports = [
  #    ../../home-manager/home.nix
  #  ];
  #};
  #};

  users.users.parrisj = {
    isNormalUser = true;
    extraGroups = ["transmission" "wheel"];
    shell = "${pkgs.zsh}/bin/zsh";
  };

  environment.systemPackages = with pkgs; [
    alejandra # Nix Code Formater
    calibre
    deploy-rs
    ffmpeg-full
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
    ddcutil
    inputs.agenix.packages.${system}.default
    openssl
    libargon2
    bitwarden-cli
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # List services that you want to enable:
  services.avahi.enable = true;

  networking.firewall.allowedTCPPorts = [3000 8222];

  age.secrets.porkbun_api.file = ../../secrets/porkbun_api.age;
  age.secrets.porkbun_secret_api.file = ../../secrets/porkbun_secret_api.age;

  security.acme.acceptTerms = true;
  security.acme.certs."int.securityishard.fyi" = {
    group = "acme";
    email = "parrisj@gmail.com";
    dnsProvider = "porkbun";
    credentialFiles = {
      "PORKBUN_API_KEY_FILE" = config.age.secrets.porkbun_api.path;
      "PORKBUN_SECRET_API_KEY_FILE" = config.age.secrets.porkbun_secret_api.path;
    };
    webroot = null;
    extraDomainNames = ["*.int.securityishard.fyi"];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    settings.Macs = ["hmac-sha2-512-etm@openssh.com" "hmac-sha2-256-etm@openssh.com" "umac-128-etm@openssh.com" "hmac-sha2-512"];
    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/etc/ssh/ssh_host_ecdsa-sha2-nistp256_key";
        type = "ecdsa-sha2-nistp256";
      }
    ];
  };

  age.secrets.vaultwarden.file = ../../secrets/vaultwarden.age;

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
    };
    environmentFile = config.age.secrets.vaultwarden.path;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
