{ config, pkgs, ... }:

{
  age.secrets.transmission.file = ../secrets/transmission.age;
  networking.firewall.allowedTCPPorts = [ 9091 ];
  services.transmission = {
    enable = true;
    credentialsFile = config.age.secrets.transmission.path;
    home = "/appdata/transmission";
    settings = {
      download-dir = "/appdata/transmission/seeding";
      incomplete-dir = "/appdata/transmission/downloading";
      incomplete-dir-enabled = true;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.*.*";
   };
  };
}
