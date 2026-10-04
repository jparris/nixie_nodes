{
  inputs,
  self,
  ...
}: let
  username = "parrisj";
in {
  flake.modules.nixos."${username}" = {pkgs, ...}: {
    #imports = with inputs.self.modules.nixos; [
    # developmentEnvironment
    #];

    users.users."${username}" = {
      isNormalUser = true;
      shell = pkgs.bash;
      extraGroups = [
        "transmission"
        "wheel"
      ];
    };
  };
}
