{ inputs, ... }:
let
  nym = "parrisj";
in
{
  flake.modules.nixos.idun = { pkgs, ... }: {
    imports = with inputs.self.modules.nixos; [
      base
      desktop-niri
      printing
    ];

    home-manager = {
      users."${nym}".imports = with inputs.self.homeModules; [
        desktop
        parrisj
        personal
      ];
    };

    hardware.logitech.wireless.enable = true;

    users.users."${nym}" = {
      home = "/home/${nym}";
      shell = "${pkgs.zsh}/bin/zsh";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "dialout"
      ];
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      initrd.kernelModules = [ "amdgpu" ];
      supportedFilesystems = [ "ntfs" ];
    };

    environment.systemPackages = with pkgs; [
      # Shell
      gnupg
      git-annex
      wezterm
      htop
      man-pages
      mr
      pass
      #posix_man_pages
      pavucontrol
      orca-slicer
      fd
      claude-code
      chromium
      bambu-studio
      libation
      solaar
      headscale
    ];

    services.pulseaudio = {
      enable = false;
    };

    networking.hostName = "idun"; # Norse goddess of eternal youth - because this is a framework laptop.
    networking.networkmanager.enable = true;

    programs = {
      browserpass.enable = true;
      firefox.enable = true;
      zsh.enable = true;
    };

    services.pcscd.enable = true;
    programs.gnupg.agent = {
      enable = true;
    };

    services.fwupd.enable = true;

    system.stateVersion = "26.05";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "idun";
}
