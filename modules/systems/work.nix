{inputs, ...}: {
  flake.modules.darwin.work = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      google-cloud-sdk
      slack
      teams
      zed
    ];
  };
}
