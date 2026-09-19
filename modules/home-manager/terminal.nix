{inputs, ...}: {
  flake.homeModules.parrisj = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.nixvim.homeModules.nixvim
      inputs.stylix.homeModules.stylix
    ];

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
      fonts = {
        monospace = {
          package = pkgs.maple-mono.NF-CN-unhinted;
          name = "Maple Mono NF CN";
        };
        sizes = {
          terminal = 18;
          desktop = 18;
        };
      };
    };

    home.packages = with pkgs; [
      alejandra
      coreutils
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.fira-code
      maple-mono.NF-CN-unhinted
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
        '';
        shellAliases.gg = "git grep";
      };

      dircolors = {
        enable = true;
        enableBashIntegration = true;
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

      nixvim = {
        enable = true;
        extraPackages = with pkgs; [fd ripgrep];
        globals = {
          mapleader = " ";
          maplocalleader = " ";
          have_nerd_font = true;
        };
        plugins.gitgutter.enable = true;
        plugins = {
          lsp-lines.enable = true;
          lsp-format.enable = true;
        };
        plugins.lsp = {
          enable = true;
          inlayHints = true;
          servers = {
            rust_analyzer = {
              enable = true;
              installRustc = false;
              installCargo = false;
            };
            nil_ls.enable = true;
          };
        };
        plugins.lualine = {
          enable = true;
          settings = {
            component_separators = {
              left = "";
              right = "";
            };
            section_separators = {
              left = "";
              right = "";
            };
            icons_enabled = true;
          };
        };
        plugins.telescope = {
          enable = true;
          keymaps = {
            "<leader>f" = "";
            "<leader>ff" = "git_files";
            "<leader>fb" = "buffers";
            "<leader>fg" = "live_grep";
          };
        };
      };

      neovide = {
        enable = true;
      };

      readline = {
        enable = true;
        variables."bell-style" = "none";
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
            font_size = 20.0,
            hide_tab_bar_if_only_one_tab = true,
            audible_bell = "Disabled"
          }
        '';
      };

      zoxide = {
        enable = true;
        enableBashIntegration = true;
      };

      zed-editor = {
        enable = true;
      };
    };

    home.stateVersion = "26.05";
  };
}
