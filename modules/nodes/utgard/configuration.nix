{inputs, ...}: let
  nym = "parrisj";
in {
  flake.modules.nixos.utgard = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      home-assistant
      parrisj
      inputs.agenix.nixosModules.default
    ];

    environment.systemPackages = with pkgs; [
      nixfmt
    ];
    programs.dconf.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelModules = ["i2c-dev"];

    boot.supportedFilesystems = ["zfs"];
    boot.zfs.forceImportRoot = false;

    networking.enableIPv6 = false;
    networking.hostId = "DEADFA10";
    networking.hostName = "utgard";
    networking.networkmanager.enable = true;
    networking.firewall.checkReversePath = false;
    time.timeZone = "America/Denver";

    security.sudo.wheelNeedsPassword = false;
    nix.settings.trusted-users = [
      "root"
      "parrisj"
    ];

    nixpkgs.config.allowUnfree = true;

    environment.shells = [pkgs.zsh];

    services.avahi.enable = true;

    services.openssh = {
      enable = true;
      settings.Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
        "hmac-sha2-512"
      ];
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

    home-manager = {
      users."${nym}".imports = with inputs.self.homeModules; [parrisj];
    };

    system.stateVersion = "23.05";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "utgard";
}
