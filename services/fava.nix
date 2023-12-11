
{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 5000 ];
  systemd.user.services.fava = {
    description = "Fava";
    enable = true;
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.fava}/bin/fava --host 0.0.0.0 --port 5000 /appdata/ledger/index.beancount";
      ExecStop = "${pkgs.busybox}/bin/pkill fava";
      Restart = "always";
    };
    wantedBy = [ "default.target" ];
  };
}
