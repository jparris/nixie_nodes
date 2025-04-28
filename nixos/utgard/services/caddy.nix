{
  config,
  pkgs,
  ...
}: let
  certloc = " /var/lib/acme/int.securityishard.club";
in {
  networking.firewall.allowedTCPPorts = [80 443];

  services.caddy = {
    enable = true;
    group = "acme";
    virtualHosts."audiobookshelf.int.securityishard.club".extraConfig = ''
      reverse_proxy http://localhost:12345

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."esphome.int.securityishard.club".extraConfig = ''
      reverse_proxy http://localhost:6052

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."fava.int.securityishard.club".extraConfig = ''
      reverse_proxy http://localhost:5000

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."miniflux.int.securityishard.club".extraConfig = ''
      reverse_proxy http://localhost:7076

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    #    virtualHosts."hass.int.securityishard.club".extraConfig = ''
    #reverse_proxy http://localhost:8123

    #tls ${certloc}/cert.pem ${certloc}/key.pem {
    #    protocols tls1.3
    #}
    #'';
    virtualHosts."jellyfin.int.securityishard.club".extraConfig = ''
      reverse_proxy http://localhost:8096

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    #virtualHosts."transmission.int.securityishard.club".extraConfig = ''
    #    reverse_proxy http://localhost:9091
    #
    #    tls ${certloc}/cert.pem ${certloc}/key.pem {
    #        protocols tls1.3
    #    }
    #'';
  };
}
