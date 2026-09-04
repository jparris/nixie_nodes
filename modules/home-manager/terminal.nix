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
        sessionVariables = {
          "EDITOR" = "nvim";
          "PATH" = "$PATH:$HOME/.cargo/bin/";
        };
        bashrcExtra = ''
          #
          # Directory Navigation
          #
          shopt -s autocd         # Prepend cd to directory names automatically
          shopt -s cdable_vars    # Use Env Vars as bookmarks - you cd into a env var from any directory
          shopt -s cdspell        # Correct spelling errors in arguments supplied to cd
          shopt -s dirspell       # Correct spelling errors during tab-completion

          #
          # Globing - aka filename matching
          #
          #shopt -s dotglob        # Matchs hidden files
          shopt -s extglob        # Brings the power of regular expressions to globing
          #shopt -s failglob       # Report errors -- Breaks nix-shell
          shopt -s globstar       # Turn on recursive globbing (enables ** to recurse all directories)
          shopt -s nocaseglob     # Case-insensitive globbing

          # Highlights man pages
          man() {
              env \
              LESS_TERMCAP_md=$'\e[1;36m' \
              LESS_TERMCAP_me=$'\e[0m' \
              LESS_TERMCAP_se=$'\e[0m' \
              LESS_TERMCAP_so=$'\e[1;40;92m' \
              LESS_TERMCAP_ue=$'\e[0m' \
              LESS_TERMCAP_us=$'\e[1;32m' \
                  man "$@"
          }

          # Borrowed from http://www.bashoneliners.com/oneliners/oneliner/231/
          up(){
              case $# in
                  0 )
                  DEEP=1 ;;
                  1 )
                  DEEP=$1 ;;
              esac
              for i in $(seq 1 $DEEP); do
                  cd ../;
              done;
          }

          # Disable the system bell
          set bell-style none
        '';
        shellAliases.gg = "git grep";
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

      neovim = {
        enable = true;
      };

      readline = {
        enable = true;
        bindings = {
          "\e[A" = "history-search-backward";
          "\e[B" = "history-search-forward";
          "\e[C" = "forward-char";
          "\e[D" = "backward-char";
        };
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

      zoxide = {
        enable = true;
        enableBashIntegration = true;
      };
    };

    home.stateVersion = "26.05";
  };
}
