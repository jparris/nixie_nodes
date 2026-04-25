{
  config,
  pkgs,
  ...
}: let
  certloc = " /var/lib/acme/int.securityishard.fyi";
in {
  networking.firewall.allowedTCPPorts = [80 443];

  services.caddy = {
    enable = true;
    group = "acme";
    virtualHosts."audiobookshelf.int.securityishard.fyi".extraConfig = ''
      reverse_proxy http://localhost:12345

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."calibre.int.securityishard.fyi".extraConfig = ''
      reverse_proxy http://localhost:3112

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."silverbullet.int.securityishard.fyi".extraConfig = ''
      reverse_proxy http://localhost:3333

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."esphome.int.securityishard.fyi".extraConfig = ''
      reverse_proxy http://localhost:6052

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."fava.int.securityishard.fyi".extraConfig = ''
      reverse_proxy http://localhost:5000

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."miniflux.int.securityishard.fyi".extraConfig = ''
      reverse_proxy http://localhost:7076

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."hass.int.securityishard.fyi".extraConfig = ''
      reverse_proxy http://localhost:8123 

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
      #'';
    virtualHosts."jellyfin.int.securityishard.fyi".extraConfig = ''
      reverse_proxy http://localhost:8096

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."syncthing.int.securityishard.fyi".extraConfig = ''
      reverse_proxy http://localhost:8384
      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."transmission.int.securityishard.fyi".extraConfig = ''
      reverse_proxy http://localhost:9091
      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
    virtualHosts."vaultwarden.int.securityishard.fyi".extraConfig = ''
      reverse_proxy http://localhost:8222

      tls ${certloc}/cert.pem ${certloc}/key.pem {
          protocols tls1.3
      }
    '';
  };
}
