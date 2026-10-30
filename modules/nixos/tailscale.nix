{
  flake.modules.nixos.tailscale =
    { config, ... }:
    {
      # Generate with `headscale preauthkeys create --reusable --user 1 -e 365d`
      # and store it with `cd secrets && agenix -e tailscale_authkey.age`.
      age.secrets.tailscale_authkey.file = ../../secrets/tailscale_authkey.age;

      services.tailscale = {
        enable = true;

        # tailscaled-autoconnect only runs `tailscale up` when the node is not
        # already logged in, so this is a no-op on every boot after the first.
        authKeyFile = config.age.secrets.tailscale_authkey.path;
        authKeyParameters.preauthorized = true;

        # Accept DNS from the tailnet (MagicDNS) and advertise this host's SSH
        # over Tailscale so tailnet ACLs gate access rather than authorized_keys.
        extraUpFlags = [
          "--accept-dns"
          "--login-server=https://headscale.securityishard.fyi"
        ];

        extraSetFlags = [
          "--advertise-exit-node"
          "--advertise-routes=192.168.0.0/16"
        ];

        # Punch a hole for direct (non-DERP-relayed) peer connections.
        openFirewall = true;

        # NOTE: leaving routing features off keeps this a plain tailnet member.
        # Flipping useRoutingFeatures to "client"/"server" sets
        # networking.firewall.checkReversePath = "loose", which collides with any
        # node that defines that option itself (utgard sets it to false).
      };

      # Services bound to this host are reachable from the tailnet without
      # listing each port in the firewall.
      networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
    };
}
