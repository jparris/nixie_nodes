{
  config,
  pkgs,
  ...
}: {
  #services.audiobookshelf = {
  #enable = true;
  #host = "0.0.0.0";
  #port = 12345;
  #openFirewall = true;
  #dataDir = "/appdata/audiobookshelf";
  #};
  networking.firewall.allowedTCPPorts = [12345];
  systemd.services.audiobookshelf = {
    description = "audiobookshelf";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.audiobookshelf}/bin/audiobookshelf --host 0.0.0.0 --port 12345 --config /appdata/audiobookshelf/config --metadata /appdata/audiobookshelf/metadata";
      ExecStop = "${pkgs.coreutils}/bin/pkill audiobookshelf";
      Restart = "on-failure";
    };
    wantedBy = ["default.target"];
  };

  systemd.services.audiobookshelf.enable = true;
}
