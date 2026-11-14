{
  flake.modules.nixos.miniflux =
    { config, lib, ... }:
    ### Miniflux
    # RSS feed reader, defaults to :8080 but set to :7076, 70 = F & 76 = L for the beginning of FLUX
    # site: https://miniflux.app/
    # repo: https://github.com/miniflux/v2
    # docs: https://miniflux.app/docs/index.html
    let
      cfg = config.miniflux;
    in
    {
      options = {
        miniflux.domain = lib.mkOption { type = lib.types.str; };

        miniflux.port = lib.mkOption {
          type = lib.types.port;
          default = 7076;
        };

        miniflux.secret = lib.mkOption { type = lib.types.path; };
      };

      config = {
        age.secrets.miniflux.file = cfg.secret;

        services.postgresql = {
          enable = true;
          identMap = ''
            parrisj parrisj miniflux
          '';
        };

        services.miniflux = {
          enable = true;
          # Generate hash with `htpasswd -bnBC 10 "" <password> | tr -d ':\n'`
          adminCredentialsFile = config.age.secrets.miniflux.path;
          config = {
            LISTEN_ADDR = "127.0.0.1:${lib.toString cfg.port}";
            FETCH_YOUTUBE_WATCH_TIME = "1";
            BASE_URL = "http://192.168.1.235:${lib.toString cfg.port}/";
          };
        };
      };
    };
}
