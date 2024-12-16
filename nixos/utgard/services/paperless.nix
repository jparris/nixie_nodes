{
  config,
  pkgs,
  ...
}: {
  services.paperless = {
    enable = true;
    dataDir = "/mnt/the_new_annex/appdata/paperless";
    consumptionDirIsPublic = true;
    address = "0.0.0.0";
  };
}
