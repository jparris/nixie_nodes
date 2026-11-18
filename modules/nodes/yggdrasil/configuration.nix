{
  inputs,
  ...
}:
let
  certGroup = "acme";
  domain = "securityishard.fyi";
  sub_domain = "ext";
in
{
  flake.modules.nixos.yggdrasil = { config, pkgs, ... }: {

    imports = with inputs.self.modules.nixos; [
      base
      headscale
    ];

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    environment.systemPackages = with pkgs; [
      alejandra
      git
      neovim
    ];

    networking = {
      hostName = "yggdrasil";
      firewall.allowedTCPPorts = [ 443 ];
    };

    age.secrets.porkbun_api.file = ../../../secrets/porkbun_api.age;
    age.secrets.porkbun_secret_api.file = ../../../secrets/porkbun_secret_api.age;

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

    security.acme.acceptTerms = true;
    security.acme.defaults = {
      group = certGroup;
      email = "parrisj@gmail.com";
      dnsProvider = "porkbun";
      credentialFiles = {
        "PORKBUN_API_KEY_FILE" = config.age.secrets.porkbun_api.path;
        "PORKBUN_SECRET_API_KEY_FILE" = config.age.secrets.porkbun_secret_api.path;
      };
      webroot = null;
    };

    headscale = {
      enable = true;
      domain = "headscale.${domain}";
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
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keyFiles = [ inputs.ssh-keys.outPath ];
    };
  };
  flake.nixosConfigurations = inputs.self.lib.mkNixos "aarch64-linux" "yggdrasil";
}
