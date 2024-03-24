{config, ...}:
### Miniflux
# RSS feed reader, defaults to :8080 but set to :7076, 70 = F & 76 = L for the beginning of FLUX
# site: https://miniflux.app/
# repo: https://github.com/miniflux/v2
# docs: https://miniflux.app/docs/index.html
{
  age.secrets.miniflux.file = ../secrets/miniflux.age;

  networking.firewall.allowedTCPPorts = [7076];
  services.postgresql = {
    enable = true;
    identMap = ''
      parrisj parrisj miniflux
    '';
  };

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux.path;
    config = {
      LISTEN_ADDR = "0.0.0.0:7076";
      FETCH_YOUTUBE_WATCH_TIME = "1";
      #BASE_URL = "https://rss.securityishard.club/";
    };
  };
}
