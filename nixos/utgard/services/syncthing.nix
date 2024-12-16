{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [8384 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];

  services = {
    syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
      user = "parrisj";
      dataDir = "/home/parrisj/sync"; # Default folder for new synced folders
      configDir = "/home/parrisj/.config/syncthing"; # Folder for Syncthing's settings and keys
    };
  };
}
