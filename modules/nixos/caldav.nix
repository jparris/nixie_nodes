{
  flake.modules.nixos.rustical = { pkgs, ... }: {
    services.rustical = {
      enable = true;
      settings = {
        data_store.sqlite = {
          #            db_url = "/appdata/rustical/db.sqlite3";
          run_repairs = true;
          skip_broken = true;
        };

        frontend = {
          enabled = true;
          allow_password_login = true;
        };

        http = {
          bind = "0.0.0.0:4000";
        };
      };
    };
  };
}
