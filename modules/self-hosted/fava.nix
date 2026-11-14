{
  flake.modules.nixos.fava =
    { pkgs, ... }:
    {
      systemd.services.fava = {
        description = "Fava";
        enable = true;
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.fava}/bin/fava --host 127.0.0.1 --port 5000 /appdata/ledger/index.beancount";
          Restart = "always";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
