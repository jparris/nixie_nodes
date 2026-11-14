{ inputs, ... }:
{
  flake.modules.nixos.base =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.agenix.nixosModules.default
      ];

      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      nixpkgs.config.allowUnfree = true;

      nix = {
        enable = true;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          warn-dirty = false;
          trusted-users = [ "parrisj" ];
        };
      };

      time.timeZone = lib.mkDefault "America/Denver";

      security.sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };

      services.openssh = {
        enable = true;
        settings.Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
          "hmac-sha2-512"
        ];
      };
    };
}
