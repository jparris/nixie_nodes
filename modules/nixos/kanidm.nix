{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kanidm;
in {
  options = {
    kanidm.enable = lib.mkEnableOption "enable kanidm module";

    kanidm.domain = lib.mkOption {type = lib.types.str;};

    kanidm.group = lib.mkOption {type = lib.types.str;};
  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [636];

    services = {
      kanidm = {
        enableClient = true;
        clientSettings = {
          uri = "https://${cfg.domain}";
        };

	package = pkgs.kanidm_1_8;
        enableServer = true;
        serverSettings = {
	  version = "2";
	  # 11114 k = 11, a = 1, n = 14
          bindaddress = "[::1]:11114";
          ldapbindaddress = "[::]:636";
          domain = "${cfg.domain}";
          origin = "https://${cfg.domain}";
	  http_client_address_info.x-forward-for = ["127.0.0.1" "127.0.0.0/8"];
          tls_chain = "/var/lib/kanidm/cert.pem";
          tls_key = "/var/lib/kanidm/key.pem";
        };
      };
    };

    services.nginx = {
      enable = true;
      group = cfg.group;

      virtualHosts = {
        "${cfg.domain}" = {
          forceSSL = true;
	  useACMEHost = cfg.domain;

          locations."/" = {
            proxyPass = "https://${config.services.kanidm.serverSettings.bindaddress}";
          };
        };
      };
    };

    security.acme.certs."${cfg.domain}" = {
      credentialsFile = config.age.secrets.acme.path;
      postRun = ''
        cp -Lv {cert,key,chain}.pem /var/lib/kanidm/
        chown kanidm:kanidm /var/lib/kanidm/{cert,key,chain}.pem
        chmod 400 /var/lib/kanidm/{cert,key,chain}.pem
      '';
      reloadServices = ["kanidm.service"];
    };
  };
}
