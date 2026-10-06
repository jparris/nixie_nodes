{...}: {
  flake.homeModules.work = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs;
      [
        gh
        claude-code
        google-cloud-sdk
        slack
      ]
      ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin (
        with pkgs; [
          (callPackage ../../pkgs/spacelauncher.nix { })
        ]
      );
  };
}
