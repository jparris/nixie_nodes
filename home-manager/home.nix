{
  config,
  pkgs,
  lib,
  ...
}: {
  home = {
    stateVersion = "24.05"; # Please read the comment before changing.
    # The home.packages option allows you to install Nix packages into your
    # environment.
    # packages = with pkgs; [
    packages = [
      pkgs.alejandra
      pkgs.bat
      pkgs.buf
      pkgs.cargo-insta
      pkgs.cargo-machete
      pkgs.cargo-watch
      pkgs.libiconv
      pkgs.fzf
      pkgs.pipx
      # neovim Telescope Media Files
      pkgs.chafa
      pkgs.epub-thumbnailer
      pkgs.codespell
      pkgs.ffmpegthumbnailer
      #pkgs.fontpreview -- not avalible on macOs
      pkgs.fd
      pkgs.ripgrep
      pkgs.imagemagick
      pkgs.poppler_utils
            #pkgs.home-manager
      # LSP
      pkgs.nixd
      pkgs.marksman
      pkgs.rust-analyzer
      pkgs.lua-language-server
      pkgs.tree-sitter

      pkgs.coreutils-full
      pkgs.eclint
      pkgs.entr
      pkgs.exiftool
      pkgs.git
      pkgs.git-lfs
      pkgs.git-machete
      pkgs.gnused
      pkgs.jq
      pkgs.neovim
      pkgs.nmap
      pkgs.sqlite.dev
      pkgs.openssl.dev
      pkgs.pkg-config
      pkgs.python3
      pkgs.starship
      pkgs.stylua
      pkgs.vhs
      pkgs.wget
      pkgs.zoxide
     pkgs.sudo
    ];

    file = {
      "bin" = {
        recursive = true;
        source = ./scripts;
        target = ".bin";
      };
      "inputrc" = {
        source = ./inputrc;
        target = ".inputrc";
      };
      "i3" = {
        recursive = true;
        source = ./config/i3;
        target = ".config/i3";
      };
      "nvim" = {
        recursive = true;
        source = ./config/nvim;
        target = ".config/nvim";
      };
      "rofi" = {
        recursive = true;
        source = ./config/rofi;
        target = ".config/rofi";
      };
      "rofi-themes" = {
        recursive = true;
        source = ./local/share/rofi;
        target = ".local/share/rofi";
      };
      "skhd" = {
        recursive = true;
        source = ./config/skhd;
        target = ".config/skhd";
      };
      # I don't like app's creating a bunch of random dirs in my home dir
      "user-dirs.dirs" = {
        source = ./config/user-dirs.dirs;
        target = ".config/user-dirs.dirs";
      };
      "wezterm" = {
        recursive = true;
        source = ./config/wezterm;
        target = ".config/wezterm";
      };
      "yabai" = {
        recursive = true;
        source = ./config/yabai;
        target = ".config/yabai";
      };
    };
  };
  programs.home-manager.enable = true;
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      userName = "Jon Parris";
      userEmail = "jparris@ddn.com";
      ignores = [".DS_Store"];
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };

    jujutsu = {
      enable = true;
    };
    starship = {
      enable = true;
      settings = {
        format = "$hostname$directory$git_branch";
        directory = {
          truncation_length = 2;
          truncation_symbol = "…/";
        };
        hostname.style = "[$ssh_symbol$hostname]($style):";
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      #history.append = true;
      #history = {
      #append = true;
      #  ignoreAllDupes = true;
      #ignoreDupes = true;
      #ignoreSpace = true;
      #share = true;
      #size = 10000;
      #path = "${config.xdg.dataHome}/zsh/history";
      #};

      initExtra = ''
        if [ -f /opt/homebrew/bin/brew ] ; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        if [ -f "$HOME/.cargo/env" ] ; then
        . "$HOME/.cargo/env"
        fi

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
      shellAliases = {
        cd = "z";
        gg = "git grep";
        ll = "ls -l";
        grab_screen = "m1ddc set input 27";
        vim = "nvim";
      };
      sessionVariables = {
        EDITOR = "nvim";
        PATH = "$PATH:$HOME/.bin/:$HOME/.local/bin";
        PKG_CONFIG_PATH_aarch64-apple-darwin = "${pkgs.openssl.dev}/lib/pkgconfig";
        NIXPKGS_ALLOW_UNFREE = 1;
      };

      antidote = {
        enable = true;
        plugins = [
          "zsh-users/zsh-completions"
          "zsh-users/zsh-autosuggestions"
          "Aloxaf/fzf-tab"
        ];
      };
    };
  };
}
