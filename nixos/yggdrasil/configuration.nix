{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  certGroup = "acme";
  dnsProvider = "cloudflare";
  domain = "securityishard.fyi";
  sub_domain = "ext";
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

  environment.systemPackages = with pkgs; [alejandra git neovim];

  networking = {
    hostName = "yggdrasil";
    firewall.allowedTCPPorts = [443];
  };

  age.secrets.porkbun_api.file = ../../secrets/porkbun_api.age;
  age.secrets.porkbun_secret_api.file = ../../secrets/porkbun_secret_api.age;

  services.oink = {
    enable = true;
    apiKeyFile = config.age.secrets.porkbun_api.path;
    secretApiKeyFile = config.age.secrets.porkbun_secret_api.path;
    domains = [
      {
        domain = domain;
        subdomain = sub_domain;
      }
    ];
  };
  #  acme = {
  #    enable = true;
  #    group = certGroup;
  #    email = "parrisj@gmail.com";
  #    dnsProvider = dnsProvider;
  #    secret = ../../secrets/acme.age;
  #  };

  #  headscale = {
  #    enable = true;
  #    domain = "headscale.${domain}";
  #    group = certGroup;
  #  };

  #  kanidm = {
  #    enable = true;
  #    domain = "auth.${domain}";
  #    group = certGroup;
  #  };

  #  services.kanidm.provision = {
  #    enable = true;
  #    autoRemove = true;
  #
  #    adminPasswordFile = config.sops.secrets.kanidm.path;
  #    idmAdminPasswordFile = config.sops.secrets.kanidm.path;
  #
  #    groups = {
  #      "admins" = {};
  #      "media" = {};
  #      "users" = {};
  #    };
  #
  #    persons = {
  #      parrisj = {
  #        displayName = "parrisj";
  #        legalName = "Jon Parris";
  #        mailAddresses = ["parrisj@gmail.com"];
  #        groups = ["admins" "users"];
  #      };
  #    };
  #  };

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
