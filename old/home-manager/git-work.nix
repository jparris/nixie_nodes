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
        userEmail = "jparris@ddn.com";
      };
    };
  };
}
