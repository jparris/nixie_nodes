{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [1883];
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        address = "0.0.0.0";
        users = {
          hass = {
            acl = ["readwrite homeassistant/#" "readwrite zigbee/#"];
            password = "zUuBrnOYouQFWiTalhBcOsuky";
          };
          zigbee = {
            acl = ["readwrite homeassistant/#" "readwrite zigbee/#"];
            password = "sph56CVTnyJT1T5ssPoIJzI2S";
          };
          zwave = {
            acl = ["readwrite zwave/#"];
            password = "[{~Iz.YowF.`GeKoRU*^";
          };
          me = {
            acl = ["readwrite #"];
            password = "ssmssm";
          };
        };
      }
    ];
  };
}
