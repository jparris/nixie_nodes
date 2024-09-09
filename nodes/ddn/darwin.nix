{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.home-manager
  ];

  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/src/nixie_nodes/nodes/ddn";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = ["nix-command" "flakes"];
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true; # default shell on catalina
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  #  _   _                      ____
  # | | | | ___  _ __ ___   ___| __ ) _ __ _____      __
  # | |_| |/ _ \| '_ ` _ \ / _ \  _ \| '__/ _ \ \ /\ / /
  # |  _  | (_) | | | | | |  __/ |_) | | |  __/\ V  V /
  # |_| |_|\___/|_| |_| |_|\___|____/|_|  \___| \_/\_/
  #
  homebrew = {
    enable = true;
    brews = ["m1ddc"];
    casks = [
      # "karabiner-elements"
      # "brave-browser"
      # "logseq"
      # "obsidian"
      # "raycast"
      "firefox"
      "neovide"
      "wezterm"
    ];
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

  system.defaults = {
    dock = {
      autohide = true;
      show-process-indicators = false;
      show-recents = false;
      static-only = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
  };
}
