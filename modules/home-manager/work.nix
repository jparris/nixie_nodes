{...}: {
  flake.homeModules.work = {pkgs, ...}: {
    home.packages = with pkgs;
      []
      ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin (
        with pkgs; [
          claude-code
          google-cloud-sdk
          slack
          zed
        ]
      );
  };
}
