{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.acme;
in {
  options = {
    acme.enable = lib.mkEnableOption "enable acme module";

    acme.dnsProvider = lib.mkOption {type = lib.types.str;};

    acme.email = lib.mkOption {type = lib.types.str;};

    acme.group = lib.mkOption {type = lib.types.str;};

    acme.secret = lib.mkOption {type = lib.types.path;};
  };

  config = lib.mkIf cfg.enable {
    age.secrets.acme.file = cfg.secret;

    security.acme = {
      acceptTerms = true;

      defaults = {
        dnsProvider = cfg.dnsProvider;
      	group = cfg.group;
      	email = cfg.email;
      };
    };
  };
}
