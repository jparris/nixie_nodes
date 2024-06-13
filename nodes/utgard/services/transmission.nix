### Transmission
# BitTorrent Client with a WebUI, WebUI port 9091 which is the default.
{
  config,
  pkgs,
  ...
}: {
  age.secrets.transmission.file = ../../../secrets/transmission.age;
  networking.firewall.allowedTCPPorts = [9091];
  services.transmission = {
    enable = true;
    credentialsFile = config.age.secrets.transmission.path;
    home = "/appdata/transmission";
    settings = {
      umask = 002;
      script-torrent-done-enabled = true;
      script-torrent-done-filename = pkgs.writers.writeBash "post-dl.sh" ''
        set -ex
        src="$TR_TORRENT_DIR/$TR_TORRENT_NAME"
        cp -r "$src" /appdata/transmission/incoming
      '';
      download-dir = "/appdata/transmission/seeding";
      incomplete-dir = "/appdata/transmission/downloading";
      incomplete-dir-enabled = true;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.*.*";
    };
  };
  systemd.services.transmission.serviceConfig.BindPaths = ["/appdata/transmission/incoming"];
}
