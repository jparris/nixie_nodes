{inputs, ...}: let
  nym = "jparris";
in {
  flake.modules.darwin.DDN12287M = {pkgs, ...}: {
    imports = with inputs.self.modules.darwin; [
      desktop
    ];

    home-manager = {
      users."${nym}".imports = with inputs.self.homeModules; [desktop parrisj work];
    };

    nix = {
      enable = true;
      distributedBuilds = true;
      linux-builder = {
        enable = true;
        package = pkgs.darwin.linux-builder;
        systems = ["aarch64-linux"];
      };
      extraOptions = ''
        warn-dirty = false
      '';
    };

    nixpkgs.config.allowUnfree = true;

    security.pam.services.sudo_local.touchIdAuth = true;

    system = {
      primaryUser = nym;
      stateVersion = 7;
    };

    # nix-darwin doesn't change the shells so we do it here
    system.activationScripts.postActivation.text = "dscl . create /Users/${nym} UserShell \"${pkgs.zsh}/bin/zsh\"";

    users.users."${nym}" = {
      home = "/Users/${nym}";
      shell = "${pkgs.bash}/bin/zsh";
    };
  };

  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" "DDN12287M";
}
