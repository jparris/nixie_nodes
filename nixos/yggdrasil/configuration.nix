{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  domain = "headscale.securityishard.club";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  age.secrets = {
    acme.file = ../../secrets/acme.age;
    cloudflare_ddns.file = ../../secrets/cloudflare_ddns.age;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [alejandra git neovim];

  networking = {
    hostName = "yggdrasil";
    firewall.allowedTCPPorts = [443];
  };

  # Cert
  security.acme = {
    acceptTerms = true;
    certs."${domain}" = {
      group = "acme";
      email = "parrisj@gmail.com";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.acme.path;
    };
  };

  # DynDns just in case Oracle Changes Our IP
  services.cloudflare-dyndns = {
    apiTokenFile = config.age.secrets.cloudflare_ddns.path;
    domains = [domain];
    enable = true;
  };

  # Headscale Coordination Server
  services.headscale = {
    enable = true;
    group = "acme";
    port = 8080;
    settings = {
      server_url = "https://${domain}";
      dns = {
        magic_dns = true;
        base_domain = "int.securityishard.club";
        override_local_dns = false;
      };
      grpc_listen_addr = "127.0.0.1:50443";
      grpc_allow_insecure = true;

      ip_prefixes = [
        "100.64.0.0/10"
      ];
      logtail.enabled = false;
    };
  };

  services.nginx = {
    enable = true;
    group = "acme";

    virtualHosts."${domain}" = {
      forceSSL = true;
      useACMEHost = domain;
      locations = {
        "/headscale." = {
          extraConfig = ''
            grpc_pass grpc://${config.services.headscale.settings.grpc_listen_addr};
          '';
          priority = 1;
        };
        "/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            proxy_set_header Host $server_name;
            proxy_redirect http:// https://;
            proxy_buffering off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;
          '';
          priority = 99;
        };
      };
      extraConfig = ''
        access_log /var/log/nginx/${domain}.access.log;
      '';
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "25.11";

  users.users.parrisj = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
  };
}
