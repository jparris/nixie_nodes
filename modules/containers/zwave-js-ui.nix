{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [3000 8091];
  virtualisation.oci-containers.containers.zwave-js-ui = {
    image = "zwavejs/zwave-js-ui:latest";
    ports = ["3000:3000" "8091:8091"];
    environment = {TZ = "America/Denver";};
    extraOptions = [
      "--device=/dev/serial/by-id/usb-Silicon_Labs_HubZ_Smart_Home_Controller_C13013F4-if00-port0:/dev/zwave"
    ];
    volumes = [
      "/var/lib/zwavejs:/usr/src/app/store"
    ];
  };
  systemd.services.podman-zwave-js-ui.serviceConfig = {
    StandardOutput = lib.mkForce "journal";
    StandardError = lib.mkForce "journal";
  };
}
