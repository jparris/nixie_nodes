### CalibreWeb
# Web app for browsing, reading and downloading eBooks stored in a Calibre database.
#
# port: 3112 from c = 3, a = 1, l = 12.
# repo: https://github.com/janeczku/calibre-web
# docs: https://github.com/janeczku/calibre-web/wiki/
{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [3112];
  services.calibre-web = {
    enable = true;
    openFirewall = true;
    listen = {
      ip = "0.0.0.0";
      port = 3112;
    };
    options = {
      calibreLibrary = "/wunderkammer/print/books/";
      enableBookUploading = true;
    };
  };
}
