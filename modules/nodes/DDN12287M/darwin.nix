{inputs, ...}: let
  nym = "jparris";
in {
  flake.modules.darwin.DDN12287M = {pkgs, ...}: {
    imports = with inputs.self.modules.darwin; [
      desktop
    ];

    home-manager = {
      useGlobalPkgs = true;
      users."${nym}".imports = with inputs.self.homeModules; [desktop parrisj work];
    };

    # I'm using determinate nix
    nix.enable = false;

    nixpkgs.config.allowUnfree = true;

    security.pam.services.sudo_local.touchIdAuth = true;

    system = {
      primaryUser = nym;
      stateVersion = 7;
    };

    # nix-darwin doesn't change the shells so we do it here
    system.activationScripts.postActivation.text = "dscl . create /Users/${nym} UserShell \"${pkgs.bash}/bin/bash\"";

    users.users."${nym}" = {
      home = "/Users/${nym}";
      shell = "${pkgs.bash}/bin/bash";
    };
  };

  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" "DDN12287M";
}
