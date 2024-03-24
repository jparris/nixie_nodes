{ config, pkgs, ... }:

{
   networking.firewall.allowedTCPPorts = [ 6052 ];
  systemd.services.esphome = {
    description = "esphome";
    serviceConfig = {
      Type = "simple";
      ExecStart =
        "${pkgs.esphome}/bin/esphome dashboard /appdata/esphome/ ";
      ExecStop = "${pkgs.coreutils}/bin/pkill esphome";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.services.esphome.enable = true;
}
