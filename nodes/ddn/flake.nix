{
  description = "DDN Work Laptop flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
  }: let
    configuration = {pkgs, ...}: {
      environment.systemPackages = [
        # Base Packages
        pkgs.alejandra
        pkgs.cargo-watch
        pkgs.entr
        pkgs.fzf
        pkgs.git
        pkgs.git-lfs
        pkgs.git-machete
        pkgs.openssl.dev
        pkgs.pkg-config
        pkgs.protobuf
        pkgs.starship
        pkgs.neovim
        # ISP Packages
        pkgs.go
        pkgs.go-protobuf
        # EMF
        pkgs.cargo-machete
        pkgs.cargo-insta
        pkgs.cargo-zigbuild
        pkgs.colima
        pkgs.nmap
        pkgs.postgresql
        pkgs.zig
      ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

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
        # onActivation.cleanup = "uninstall";
        taps = [];
        brews = [];
        casks = ["neovide"];
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
    };
    homeconfig = {pkgs, ...}: {
      # this is internal compatibility configuration
      # for home-manager, don't change this!
      home.stateVersion = "23.05";
      # Let home-manager install and manage itself.
      programs.home-manager.enable = true;

      home.packages = with pkgs; [];

      home.sessionVariables = {
        EDITOR = "nvim";
        PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      };
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#DDN12287M
    users.users.jparris = {
      name = "jparris";
      home = "/Users/jparris";
    };
    home-manager.users.jparris = homeconfig;
    darwinConfigurations."DDN12287M" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."DDN12287M".pkgs;
  };
}
