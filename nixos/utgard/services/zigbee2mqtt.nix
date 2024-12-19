### Zigbee2MQTT
# Zigbee2MQTT bridges Zigbee, a smart home wireless standard, to Home Assistant.
# Zigbee2MQTT requires a compatible USB dongle.
#
# port: 2697 from z = 26, i = 9, g = 7.
# site: https://www.zigbee2mqtt.io/
# repo: https://github.com/Koenkk/zigbee2mqtt
# docs: https://www.zigbee2mqtt.io/guide/configuration/
{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [2697];
  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = true;
      frontend = {
        enable = true;
        port = 2697;
      };
      permit_join = true;
      serial = {
        port = "/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0";
      };
    };
  };
  users.users.zigbee2mqtt.extraGroups = ["dialout"];
}
