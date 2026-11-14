{
  flake.modules.nixos.zwave-js-ui =
    { config, lib, ... }:
    ### Z-Wave JS UI
    # Web UI on :8091, proxied by caddy. The Z-Wave JS websocket server that
    # Home Assistant talks to (:3000) is configured in the app's settings.
    # site: https://zwave-js.github.io/zwave-js-ui/
    let
      cfg = config.zwave-js-ui;
    in
    {
      options = {
        zwave-js-ui.port = lib.mkOption {
          type = lib.types.port;
          default = 8091;
        };
      };

      config = {
        services.zwave-js-ui = {
          enable = true;
          # Only grants the service access; the app must also be pointed at it.
          serialPort = "/dev/serial/by-id/usb-Silicon_Labs_HubZ_Smart_Home_Controller_C13013F4-if00-port0";
          settings = {
            HOST = "127.0.0.1";
            PORT = toString cfg.port;
          };
        };
      };
    };
}
