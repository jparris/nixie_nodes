{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [80 443];

  services.nginx = {
    enable = true;
    # give a name to the virtual host. It also becomes the server name.
    virtualHosts."transmission.int.securityishard.club" = {
      locations."/" = {
        proxyPass = "http://localhost:9091/";
      };
    };
  };
}
