{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "yggdrasil";

  services.openssh = {
    enable = true;
    settings = {
    	PermitRootLogin = "no";
	PasswordAuthentication = false;
    };
  };

  system.stateVersion = "25.11";

  users.users.parrisj = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     openssh.authorizedKeys.keyFiles = [ inputs.ssh-keys.outPath ];
#     openssh.authorizedKeys.keys = [
#"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFkgvisBqM+UdDjBTC3THiaoCXpI6S80oi6JdU5EQ9oG parrisj@idun"
#     ];
   };
}

