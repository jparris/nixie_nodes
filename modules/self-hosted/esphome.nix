{
  flake.modules.nixos.esphome =
    {
      lib,
      pkgs,
      ...
    }:
    {
      systemd.services.esphome = {
        description = "esphome";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.esphome-device-builder} /appdata/esphome/";
          Restart = "on-failure";
        };
        wantedBy = [ "multi-user.target" ];
      };
      systemd.services.esphome.enable = true;
    };
}
