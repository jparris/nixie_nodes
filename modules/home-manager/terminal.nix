{...}: {
  flake.homeModules.parrisj = {pkgs, ...}: {
    home.packages = with pkgs; [
      alejandra
      devenv
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.fira-code
      nixd
      nil
    ];

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      bash = {
        enable = true;
        shellAliases.ll = "ls -l";
      };

      git = {
        enable = true;
        lfs.enable = true;
        ignores = [".DS_Store"];
        settings = {
          user = {
            name = "Jon Parris";
            email = "jparris@ddn.com";
          };
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        };
      };

      jujutsu = {
        enable = true;
      };

      starship = {
        enable = true;
        #extraPackages = [pkgs.starship-jj]

        settings = {
          format = "$hostname$directory$git_branch";
          directory = {
            truncation_length = 2;
            truncation_symbol = "…/";
          };
          hostname.style = "[$ssh_symbol$hostname]($style):";
        };
      };
      wezterm = {
        enable = true;
        extraConfig = ''
          return {
            font = wezterm.font("FiraCode Nerd Font Mono"),
            font_size = 20.0,
            color_scheme = "Tomorrow Night",
            hide_tab_bar_if_only_one_tab = true,
            audible_bell = "Disabled"
          }
        '';
      };
    };
    home.stateVersion = "26.05";
  };
}
