{
  flake.modules.nixos.home-assistant = { lib, ... }: {
    virtualisation.oci-containers.containers.home-assistant = {
      image = "homeassistant/home-assistant:2026.11.1@sha256:6785d1eca68747a524c156faae1b139ed415c07357386ae6fe17291986e59e82";
      extraOptions = [
        "--device=/dev/serial/by-id/usb-Silicon_Labs_HubZ_Smart_Home_Controller_C13013F4-if01-port0:/dev/ttyUSB1"
        "--network=host"
      ];
      volumes = [
        "/opt/home-assistant:/config"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };

    systemd.services.podman-home-assistant.serviceConfig = {
      StandardOutput = lib.mkForce "journal";
      StandardError = lib.mkForce "journal";
    };
  };
}
