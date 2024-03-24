{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [8123];
  virtualisation.oci-containers.containers.home-assistant = {
    image = "homeassistant/home-assistant:stable";
    ports = ["8123:8123"];
    extraOptions = [
      "--device=/dev/serial/by-id/usb-Silicon_Labs_HubZ_Smart_Home_Controller_C13013F4-if01-port0:/dev/ttyUSB1"
    ];
    volumes = [
      "/opt/home-assistant:/config/"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
  systemd.services.podman-home-assistant.serviceConfig = {
    StandardOutput = lib.mkForce "journal";
    StandardError = lib.mkForce "journal";
  };
}
