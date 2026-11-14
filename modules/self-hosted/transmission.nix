{
  flake.modules.nixos.transmission =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.transmission;
    in
    {
      options = {
        transmission.domain = lib.mkOption { type = lib.types.str; };

        transmission.dir = lib.mkOption { type = lib.types.path; };

        transmission.port = lib.mkOption {
          type = lib.types.port;
          default = 9091;
        };

        transmission.secret = lib.mkOption { type = lib.types.path; };
      };

      config = {
        age.secrets.transmission.file = cfg.secret;
        services.transmission = {
          enable = true;

          package = pkgs.transmission_4;
          credentialsFile = config.age.secrets.transmission.path;
          home = cfg.dir;
          settings = {
            umask = 002;
            script-torrent-done-enabled = true;
            script-torrent-done-filename = pkgs.writers.writeBash "post-dl.sh" ''
              set -ex
              src="$TR_TORRENT_DIR/$TR_TORRENT_NAME"
              cp -r "$src" ${cfg.dir}/incoming
            '';
            download-dir = "${cfg.dir}/seeding";
            incomplete-dir = "${cfg.dir}/downloading";
            incomplete-dir-enabled = true;
            rpc-port = cfg.port;
            rpc-host-whitelist-enabled = false;
          };
        };
        systemd.services.transmission.serviceConfig.BindPaths = [ "${cfg.dir}/incoming" ];
      };
    };
}
