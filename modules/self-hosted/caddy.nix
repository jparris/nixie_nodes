{
  flake.modules.nixos.caddy =
    { config, lib, ... }:
    let
      domain = "int.securityishard.fyi";
      certloc = "/var/lib/acme/${domain}";

      mkVhost = proxy: {
        extraConfig = ''
          ${proxy}

          tls ${certloc}/cert.pem ${certloc}/key.pem {
              protocols tls1.3
          }
        '';
      };

      # Every service gets <name>.${domain}, served with the wildcard cert
      # ACME issues for the domain.
      proxied = {
        audiobookshelf = 12345;
        esphome = 6052;
        fava = 5000;
        hass = 8123;
        jellyfin = 8096;
        miniflux = config.miniflux.port;
        transmission = config.transmission.port;
        vaultwarden = config.vaultwarden.port;
        zigbee = 2697;
        zwave = config.zwave-js-ui.port;
      };

      # Backends that terminate TLS themselves, so the proxy hop is https too.
      # They serve the same wildcard cert, which only validates against the
      # public hostname -- not "localhost" -- hence tls_server_name.
      tlsProxied = {
        kanidm = 11114;
      };

      vhostsFor = mk: lib.mapAttrs' (name: port: lib.nameValuePair "${name}.${domain}" (mk name port));
    in
    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      # Wait until we have certs
      systemd.services.caddy = {
        wants = [ "acme-${domain}.service" ];
        after = [ "acme-${domain}.service" ];
      };

      # Restart when acme updates the certs
      security.acme.certs.${domain}.reloadServices = [ "caddy.service" ];

      services.caddy = {
        enable = true;
        group = "acme";

        virtualHosts =
          vhostsFor (_: port: mkVhost "reverse_proxy http://localhost:${toString port}") proxied

          // vhostsFor (
            name: port:
            mkVhost ''
              reverse_proxy https://localhost:${toString port} {
                  transport http {
                      tls
                      tls_server_name ${name}.${domain}
                  }
              }''
          ) tlsProxied;
      };
    };
}
