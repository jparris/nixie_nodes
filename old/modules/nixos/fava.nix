{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.fava;
in {
  options.services.fava = {
    enable =
      lib.mkEnableOption "Enable fava";

    port = lib.mkOption {
      default = 5000;
      type = lib.types.port;
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to automatically open the specified ports in the firewall.
      '';
    };

    journal = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
    systemd.services.fava = {
      description = "Fava";
      enable = true;
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.fava}/bin/fava --host 0.0.0.0 --port ${toString cfg.port} ${cfg.journal}";
        ExecStop = "${pkgs.busybox}/bin/pkill fava";
        Restart = "always";
      };
      wantedBy = ["default.target"];
    };
  };
}
