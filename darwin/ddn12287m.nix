{
  pkgs,
  config,
  lib,
  home-manager-flake,
  ...
} @ inputs: {
  imports = [
    home-manager-flake.darwinModules.home-manager
  ];

  environment.systemPackages = [
    pkgs.black
    pkgs.cargo-zigbuild
    pkgs.colima
    pkgs.docker
    pkgs.docker-buildx
    pkgs.docker-credential-helpers
    pkgs.gh
    pkgs.google-cloud-sdk
    pkgs.home-manager
    pkgs.nixd
    pkgs.nodePackages.npm
    pkgs.nodejs-slim
    pkgs.postgresql
    pkgs.protobuf
    pkgs.zig
    # ISP Packages
    pkgs.go
    pkgs.go-protobuf
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
    (pkgs.nerdfonts.override {fonts = ["FiraCode"];})

    #pkgs.jankyborders
    #pkgs.kanata
    #pkgs.skhd
    #pkgs.yabai
  ];

  users.users.jparris = {
    home = "/Users/jparris";
    shell = "${pkgs.zsh}/bin/zsh";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = config._module.specialArgs;
  home-manager.users.jparris = {
    imports = [
      ../home-manager/home.nix
    ];
  };

  # nix-darwin doesn't change the shells so we do it here
  system.activationScripts.postActivation.text = ''
    echo "setting up users' shells..." >&2

    ${lib.concatMapStringsSep "\n" (user: ''
      dscl . create /Users/${user.name} UserShell "${user.shell}"
    '') (lib.attrValues config.users.users)}
  '';

  nix.settings.experimental-features = "nix-command flakes repl-flake";

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 2d";
    interval = {
      Hour = 5;
      Minute = 0;
    };
  };

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  # This sets up /etc/zshrc to load nix-darwin
  programs = {
    zsh.enable = true;
  };

  environment.shells = [pkgs.zsh];

  homebrew = {
    enable = true;
    #cleanup = "zap";
    global = {
      brewfile = true;
    };
    taps = ["homebrew/bundle"];
    brews = ["m1ddc"];
    casks = [
      "altair-graphql-client"
      "brave-browser"
      "hiddenbar"
      "logseq"
      "notion"
      "firefox"
      "slack"
      "wezterm"
      "zed"
    ];
    masApps = {};
  };

  #                  _
  #  _ __   ___  ___| |_ __ _ _ __ ___  ___
  # | '_ \ / _ \/ __| __/ _` | '__/ _ \/ __|
  # | |_) | (_) \__ \ || (_| | | |  __/\__ \
  # | .__/ \___/|___/\__\__, |_|  \___||___/
  # |_|                 |___/
  #
  # This is section is so complicated due to limitations with nix-darwin
  system.activationScripts.preActivation = {
    enable = true;
    text = ''
      if [ ! -d "/var/lib/postgresql/" ]; then
        echo "creating PostgreSQL data directory..."
        sudo mkdir -m 750 -p /var/lib/postgresql/15
        sudo chown -R jparris:DATADIRECT\\Domain\ Users /var/lib/postgresql/
      fi
    '';
  };

  services.postgresql = {
    enable = true;
    initdbArgs = ["-U jparris" "--pgdata=/var/lib/postgresql/15" "--auth=trust" "--no-locale" "--encoding=UTF8"];
    package = pkgs.postgresql;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all      all trust
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';
    # Would be nice but nix-darwin doesn't support it.s
    #initialScript = pkgs.writeText "backend-initScript" ''
    #  CREATE ROLE postgres WITH LOGIN PASSWORD 'emf' SUPERUSER;
    #  CREATE ROLE emf WITH LOGIN PASSWORD 'emf' CREATEDB;
    #  CREATE DATABASE emf;
    #  GRANT ALL PRIVILEGES ON DATABASE emf TO emf;
    #'';
  };

  launchd.user.agents.postgresql.serviceConfig = {
    StandardErrorPath = "/tmp/postgres.error.log";
    StandardOutPath = "/tmp/postgres.log";
  };

  security.pam.enableSudoTouchIdAuth = true;

  #                         ___  ____        _       __             _ _
  #  _ __ ___   __ _  ___ / _ \/ ___|    __| | ___ / _| __ _ _   _| | |_ ___
  # | '_ ` _ \ / _` |/ __| | | \___ \   / _` |/ _ \ |_ / _` | | | | | __/ __|
  # | | | | | | (_| | (__| |_| |___) | | (_| |  __/  _| (_| | |_| | | |_\__ \
  # |_| |_| |_|\__,_|\___|\___/|____/   \__,_|\___|_|  \__,_|\__,_|_|\__|___/
  #
  system.defaults = {
    dock = {
      # Hide the dock
      autohide = true;
      # No dots for running Apps
      show-process-indicators = false;
      # No recent Apps section
      show-recents = false;
      # Only running Apps
      static-only = true;
    };
    finder = {
      # Shows file extensions
      AppleShowAllExtensions = true;
      # Show path bar in the bottom of the Finder windows
      ShowPathbar = true;
      # Suppresses warning when changing a file extension.
      FXEnableExtensionChangeWarning = false;
      # Set the default view to column
      FXPreferredViewStyle = "clmv";
      # Show full path in title
      _FXShowPosixPathInTitle = true;
    };
    screencapture.location = "~/screenshots";
    NSGlobalDomain = {
      # Save new files to the local disk
      NSDocumentSaveNewDocumentsToCloud = false;
      # Control + Command + Click = Move window by clicking anywhere
      NSWindowShouldDragOnGesture = true;
    };
  };
}
