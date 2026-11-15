### JuicePass Proxy
# JuicePass Proxy sits between a JuiceBox EV charger and its (now defunct)
# EnelX cloud, decoding the charger's UDP status messages and publishing them
# to MQTT with Home Assistant discovery.
#
# The charger is pointed at the proxy over telnet (`--update_udpc`), so no
# local DNS override for the EnelX hostname is needed.
#
# repo: https://github.com/JuiceRescue/juicepassproxy
{
  flake.modules.nixos.juicepassproxy =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.juicepassproxy;
    in
    {
      options = {
        juicepassproxy.juiceboxHost = lib.mkOption {
          type = lib.types.str;
          description = "LAN address of the JuiceBox; its telnet port is used to set where it sends data.";
        };

        # The proxy binds to this address and tells the JuiceBox to send to it,
        # so it must be this host's LAN address, not loopback or the tailnet.
        juicepassproxy.host = lib.mkOption {
          type = lib.types.str;
          description = "LAN address of this host, as reachable from the JuiceBox.";
        };

        juicepassproxy.port = lib.mkOption {
          type = lib.types.port;
          default = 8047;
        };

        # EnelX shut down its North American service in October 2024, so
        # forwarding to it only produces errors.
        juicepassproxy.ignoreEnelx = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        juicepassproxy.extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };

      config = {
        systemd.services.juicepassproxy = {
          description = "JuicePass Proxy";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network-online.target"
            "mosquitto.service"
          ];
          wants = [ "network-online.target" ];
          requires = [ "mosquitto.service" ];

          serviceConfig = {
            ExecStart = lib.escapeShellArgs (
              [
                (lib.getExe (pkgs.callPackage ../../pkgs/juicepassproxy.nix { }))
                "--juicebox_host"
                cfg.juiceboxHost
                "--update_udpc"
                "--jpp_host"
                cfg.host
                "--local_ip"
                cfg.host
                "--local_port"
                (toString cfg.port)
                "--config_loc"
                "/var/lib/juicepassproxy"
                # Logs go to the journal instead of a rotating file.
                "--log_loc"
                "none"
              ]
              ++ lib.optional cfg.ignoreEnelx "--ignore_enelx"
              ++ cfg.extraArgs
            );
            Restart = "on-failure";
            RestartSec = 10;

            DynamicUser = true;
            StateDirectory = "juicepassproxy";
            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = true;
            NoNewPrivileges = true;
          };
        };

        networking.firewall.allowedUDPPorts = [ cfg.port ];

        # Mosquitto's default listener is localhost:1883 with anonymous access,
        # which is what the proxy connects to by default.
        services.mosquitto.enable = true;
      };
    };
}
