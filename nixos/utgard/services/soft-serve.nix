{
  config,
  pkgs,
  ...
}: {
  # 19156
  # s = 19, o = 15, f = 6
  networking.firewall.allowedTCPPorts = [19156 19157];
  services.soft-serve = {
    enable = true;
    settings = {
      name = "parrisj's repos";
      log_format = "text";
      ssh = {
        listen_addr = ":19156";
        public_url = "ssh://192.168.1.235:19156";
        max_timeout = 30;
        idle_timeout = 120;
      };
      http = {
        listen_addr = ":19157";
        public_url = "http://192.168.1.235:19157";
      };
      lfs = {
        enable = true;
        ssh_enable = true;
      };
      initial_admin_keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG003GWp1imJXLtTgfCjEep++65lGl8BayU7G5qUHxWb jparris@DDN12287M.local''];
    };
  };
}
