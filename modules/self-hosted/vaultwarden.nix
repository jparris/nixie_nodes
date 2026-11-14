{
  flake.modules.nixos.vaultwarden =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.vaultwarden;
    in
    {
      options = {
        vaultwarden.domain = lib.mkOption { type = lib.types.str; };

        vaultwarden.port = lib.mkOption {
          type = lib.types.port;
          default = 8222;
        };

        vaultwarden.secret = lib.mkOption { type = lib.types.path; };
      };

      config = {
        age.secrets.vaultwarden.file = cfg.secret;

        services.vaultwarden = {
          enable = true;
          config = {
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = cfg.port;
            DOMAIN = cfg.domain;
          };
          environmentFile = config.age.secrets.vaultwarden.path;
        };
      };
    };
}
