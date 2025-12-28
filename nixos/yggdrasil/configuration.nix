{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  certGroup = "acme";
  dnsProvider = "cloudflare";
  domain = "securityishard.club";
  email = "parrisj@gmail.com";
in {
  imports = [
    ../../modules/nixos/mod.nix
    ./hardware-configuration.nix
    ./headscale.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  cloudflare-dyndns = {
    enable = true;
    domain = domain;
    secret = ../../secrets/cloudflare_ddns.age;
  };

  environment.systemPackages = with pkgs; [alejandra git neovim];

  networking = {
    hostName = "yggdrasil";
    firewall.allowedTCPPorts = [443];
  };

  acme = {
    enable = true;
    group = certGroup;
    email = "parrisj@gmail.com";
    dnsProvider = dnsProvider;
    secret = ../../secrets/acme.age;
  };

  headscale = {
    enable = true;
    domain = "headscale.${domain}";
    group = certGroup;
  };

  kanidm = {
    enable = true;
    domain = "auth.${domain}";
    group = certGroup;
  };

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
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
  };
}
