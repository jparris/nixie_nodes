{
  flake.modules.nixos.caddy =
    { lib, ... }:
    let
      domain = "int.securityishard.fyi";
      certloc = "/var/lib/acme/${domain}";

      # Every service gets <name>.${domain}, served with the wildcard cert
      # ACME issues for the domain.
      proxied = {
        audiobookshelf = 12345;
        esphome = 6052;
        fava = 5000;
        hass = 8123;
        jellyfin = 8096;
        miniflux = 7076;
        transmission = 9091;
        vaultwarden = 8222;
      };
    in
    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      services.caddy = {
        enable = true;
        group = "acme";

        virtualHosts = lib.mapAttrs' (
          name: port:
          lib.nameValuePair "${name}.${domain}" {
            extraConfig = ''
              reverse_proxy http://localhost:${toString port}

              tls ${certloc}/cert.pem ${certloc}/key.pem {
                  protocols tls1.3
              }
            '';
          }
        ) proxied;
      };
    };
}
