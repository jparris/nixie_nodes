{
  inputs,
  home-manager,
  ...
}: let
  nym = "jparris";
in {
  flake.modules.darwin.DDN12287M = {pkgs, ...}: {
    imports = with inputs.self.modules.darwin; [
      desktop
      work
    ];

    home-manager = {
      useGlobalPkgs = true;
      users."${nym}".imports = [inputs.self.homeModules.parrisj];
    };

    # I'm using determinate nix
    nix.enable = false;

    system = {
      primaryUser = nym;
      stateVersion = 7;
    };

    users.users."${nym}".home = "/Users/${nym}";
  };

  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" "DDN12287M";
}
