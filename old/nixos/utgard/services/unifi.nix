{
  config,
  pkgs,
  ...
}: {
  services.unifi = {
    unifiPackage = pkgs.unifi8;
    enable = true;
    openFirewall = true;
  };
}
