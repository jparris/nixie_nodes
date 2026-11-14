{
  flake.modules.nixos.esphome =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.esphome = {
        enable = true;
        environment = {
          ESPHOME_TRUSTED_DOMAINS = "esphome.int.securityishard.fyi";
        };
      };

      # ESP-IDF is the default ESP32 toolchain. ESPHome downloads the framework
      # and prebuilt xtensa/riscv compilers into /var/lib/esphome, so they need
      # nix-ld to run, plus host cmake/ninja/git. Nix's ninja spawns build
      # commands via `sh` from PATH, so bash is needed too.
      programs.nix-ld.enable = true;

      systemd.services.esphome = {
        path = with pkgs; [
          bash
          cmake
          ninja
          git
        ];
        # systemd units don't get sessionVariables, so pass nix-ld's through.
        environment = {
          inherit (config.environment.sessionVariables) NIX_LD NIX_LD_LIBRARY_PATH;
        };
      };
    };
}
