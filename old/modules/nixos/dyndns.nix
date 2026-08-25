{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.dyndns;
in {
  options = {
    dyndns.enable = lib.mkEnableOption "enable ddclient for dyndns";

    dyndns.domain = lib.mkOption {type = lib.types.str;};

    dyndns.secret = lib.mkOption {type = lib.types.path;};
  };

  config = lib.mkIf cfg.enable {
    age.secrets.ddclient.file = cfg.secret;

    services.ddclient = {
      secretsFile = config.age.secrets.ddclient.path;
      domains = [cfg.domain];
      enable = true;
    };
  };
}
