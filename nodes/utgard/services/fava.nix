{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../../modules/nixos/fava.nix
  ];

  services.fava = {
    enable = true;
    openFirewall = true;
    port = 5000;
    journal = "/appdata/ledger/index.beancount";
  };
}
