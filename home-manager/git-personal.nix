{
  config,
  pkgs,
  lib,
  ...
}: {
  home = {
    programs = {
      git = {
        lfs.enable = true;
        userName = "Jon Parris";
        userEmail = "parrisj@gmail.com";
      };
    };
  };
}
