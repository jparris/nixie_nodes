{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.headscale;
in {
  options = {
    headscale.enable = lib.mkEnableOption "enable headscale server";

    headscale.domain = lib.mkOption {type = lib.types.str;};

    headscale.group = lib.mkOption {type = lib.types.str;};
  };

  config = lib.mkIf cfg.enable {
    services.headscale = {
      enable = true;
      group = cfg.group;
      port = 8080;
      settings = {
        server_url = "https://${cfg.domain}";
        dns = {
          magic_dns = true;
          base_domain = "int.securityishard.club";
          override_local_dns = false;
          extra_records = [
            {
              name = "audiobookshelf.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "calibre.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "dash.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "esphome.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "fava.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "git.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "immich.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "jellyfin.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "hass.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "miniflux.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "photostructure.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "syncthing.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "transmission.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "vaultwarden.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "zigbee.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
            {
              name = "zwave.int.securityishard.club";
              type = "A";
              value = "100.64.0.2";
            }
          ];
        };
        grpc_listen_addr = "127.0.0.1:50443";
        grpc_allow_insecure = true;

        ip_prefixes = [
          "100.64.0.0/10"
        ];
        logtail.enabled = false;
      };
    };

    security.acme.certs."${cfg.domain}" = {
      credentialsFile = config.age.secrets.acme.path;
    };

    services.nginx = {
      enable = true;
      group = cfg.group;

      virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        useACMEHost = cfg.domain;
        locations = {
          "/headscale." = {
            extraConfig = ''
              grpc_pass grpc://${toString config.services.headscale.settings.grpc_listen_addr};
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
          access_log /var/log/nginx/${cfg.domain}.access.log;
        '';
      };
    };
  };
}
