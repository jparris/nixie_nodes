{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.cloudflare-dyndns;
in {
  options = {
    cloudflare-dyndns.enable = lib.mkEnableOption "enable cloudflare-dyndns";

    cloudflare-dyndns.domain = lib.mkOption {type = lib.types.str;};

    cloudflare-dyndns.secret = lib.mkOption {type = lib.types.path;};
  };

  config = lib.mkIf cfg.enable {
    age.secrets.cloudflare_ddns.file = cfg.secret;

    services.cloudflare-dyndns = {
      apiTokenFile = config.age.secrets.cloudflare_ddns.path;
      domains = [cfg.domain];
      enable = true;
    };
  };
}
