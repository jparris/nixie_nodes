{ inputs, ... }:
let
  nym = "parrisj";
  dir = "/appdata";
  domain = "int.securityishard.fyi";
  email = "${nym}@gmail.com";
in
{
  flake.modules.nixos.utgard =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.nixos; [
        acme
        audiobookshelf
        base
        caddy
        esphome
        fava
        juicepassproxy
        home-assistant
        miniflux
        parrisj
        transmission
        tailscale
        vaultwarden
        zigbee2mqtt
        zwave-js-ui
      ];

      acme = {
        domain = domain;
        email = email;
        api_key = ../../../secrets/porkbun_api.age;
        secret_key = ../../../secrets/porkbun_secret_api.age;
      };

      miniflux = {
        domain = "miniflux.${domain}";
        secret = ../../../secrets/miniflux.age;
      };

      juicepassproxy = {
        juiceboxHost = "192.168.1.168";
        host = "192.168.1.235";
      };

      transmission = {
        dir = "${dir}/transmission";
        domain = "tranmission.${domain}";
        secret = ../../../secrets/transmission.age;
      };

      vaultwarden = {
        domain = "https://vaultwarden.${domain}";
        secret = ../../../secrets/vaultwarden.age;
      };

      environment.systemPackages = with pkgs; [
        nixfmt-tree
      ];
      programs.dconf.enable = true;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.kernelModules = [ "i2c-dev" ];

      boot.supportedFilesystems = [ "zfs" ];
      boot.zfs.forceImportRoot = false;

      networking.enableIPv6 = false;
      networking.hostId = "DEADFA10";
      networking.hostName = "utgard";
      networking.networkmanager.enable = true;
      networking.firewall.checkReversePath = false;

      services.jellyfin.enable = true;

      environment.shells = [ pkgs.zsh ];

      services.avahi.enable = true;

      # Enabled, with MAC policy, in modules.nixos.base; these host keys
      # predate this machine's rebuild and stay with it.
      services.openssh = {
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
        users."${nym}".imports = with inputs.self.homeModules; [
          parrisj
          # beets
        ];
      };

      system.stateVersion = "23.05";
    };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "utgard";
}
