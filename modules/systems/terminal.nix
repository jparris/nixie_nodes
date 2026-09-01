{inputs, ...}: {
  flake.homeModules.parrisj = {pkgs, ...}: {
    programs.bash.enable = true;
    programs.bash.shellAliases.ll = "ls -l";

    home.packages = with pkgs; [alejandra jujutsu nixd nil];
    home.stateVersion = "26.05";
  };
}
