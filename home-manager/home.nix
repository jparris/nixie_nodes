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
      pkgs.black
      pkgs.buf
      pkgs.cargo-insta
      pkgs.cargo-machete
      pkgs.cargo-watch
      pkgs.codespell
      pkgs.entr
      pkgs.exiftool
      pkgs.fzf
      pkgs.gh
      pkgs.git
      pkgs.git-lfs
      pkgs.git-machete
      pkgs.gnused
      pkgs.jq
      pkgs.luaformatter
      pkgs.neovim
      pkgs.nmap
      pkgs.openssl.dev
      pkgs.pkg-config
      pkgs.python3
      pkgs.ripgrep
      pkgs.starship
      pkgs.vhs
      pkgs.wget
      pkgs.zoxide
    ];

    file = {
      ".bin" = {
        recursive = true;
        source = ./scripts;
        target = ".bin";
      };
      ".inputrc" = {
        source = ./inputrc;
        target = ".inputrc";
      };
      "nvim" = {
        recursive = true;
        source = ./config/nvim;
        target = ".config/nvim";
      };
      # I don't like app's creating a bunch of random dirs in my home dir
      ".user-dirs.dirs" = {
        source = ./config/user-dirs.dirs;
        target = ".config/user-dirs.dirs";
      };
      "wezterm" = {
        recursive = true;
        source = ./config/wezterm;
        target = ".config/wezterm";
      };
    };
    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    #file = {
    # git
    #  ".cvsignore".source = ../git/.cvsignore;
    #  ".gitconfig".source = ../git/.gitconfig;
    # vim
    #  ".config/nvim/.vimrc".source = ../nvim/.config/nvim/.vimrc;
    # wezterm
    # ".config/wezterm/wezterm.lua".source = ../wezterm/.wezterm.lua;
    #};

    #activation.mkdirNvimFolders = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #  mkdir -p $HOME/.config/nvim/backups $HOME/.config/nvim/swaps $HOME/.config/nvim/undo
    #'';

    #activation.installWeztermProfile = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #  tempfile=$(mktemp) \
    #  && ${pkgs.curl}/bin/curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
    #  && tic -x -o ~/.terminfo $tempfile \
    #  && rm $tempfile
    #'';

    #sessionVariables = {
    #};
  };
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
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        if [ -f /opt/homebrew/bin/brew ] ; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        if [ -f "$HOME/.cargo/env" ] ; then
        . "$HOME/.cargo/env"
        fi
      '';
      shellAliases = {
        ll = "ls -l";
        grab_screen = "m1ddc set input 27";
        vim = "nvim";
        #update = "sudo nixos-rebuild switch";
      };
      history = {
        size = 10000;
        #path = "${config.xdg.dataHome}/zsh/history";
      };
      sessionVariables = {
        EDITOR = "nvim";
        PATH = "$PATH:$HOME/.bin/:$HOME/.local/bin";
        NIXPKGS_ALLOW_UNFREE = 1;
      };

      #        zplug = {
      #            enable = true;
      #            plugins = [
      #                { name = "plugins/vscode"; tags = [ from:oh-my-zsh ]; }
      #            ];
    };
  };
}
