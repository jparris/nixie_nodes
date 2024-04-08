{
  config,
  pkgs,
  ...
}: {
  age.secrets.nextcloud = {
    file = ../../secrets/nextcloud.age;
    mode = "700";
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    package = pkgs.nextcloud28;
    settings.trusted_domains = ["192.168.1.*"];
    config.adminpassFile = config.age.secrets.nextcloud.path;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar;
      #memories = pkgs.fetchNextcloudApp {
      #    sha256 = "sha256-X28Bmg4En97dQVxarZuUMHKdyfMiM6pfGdcv04EIaBg=";
      #    url = "https://github.com/pulsejet/memories/releases/download/v7.0.2/memories.tar.gz";
      #    license = "agpl3";
      #};
      #files_3dmodelviewer = pkgs.fetchNextcloudApp {
      #    sha256 = "sha256-X28Bmg4En97dQVxarZuUMHKdyfMiM6pfGdcv04EIaBg=";
      #    url = "https://github.com/WARP-LAB/files_3dmodelviewer/releases/download/v0.0.12/files_3dmodelviewer.tar.gz";
      #    license = "agpl3";
      #};
    };
    extraAppsEnable = true;
  };
}
