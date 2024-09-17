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
    packages = [
      pkgs.nixd
      pkgs.ripgrep
      # Base Packages
      pkgs.alejandra
      pkgs.black
      pkgs.buf
      pkgs.cargo-watch
      pkgs.codespell
      pkgs.docker
      pkgs.docker-credential-helpers
      pkgs.entr
      pkgs.exiftool
      pkgs.fzf
      pkgs.gh
      pkgs.git
      pkgs.git-lfs
      pkgs.git-machete
      pkgs.gnused
      pkgs.jq
      pkgs.openssl.dev
      pkgs.pkg-config
      pkgs.protobuf
      pkgs.python3
      pkgs.python311Packages.pypdf
      pkgs.SDL2.dev
      #       pkgs.skhd
      pkgs.starship
      pkgs.neovim
      pkgs.wget
      pkgs.vhs
      pkgs.yabai
      pkgs.zoxide
      # ISP Packages
      pkgs.go
      pkgs.go-protobuf
      # EMF
      pkgs.cargo-machete
      pkgs.cargo-insta
      pkgs.cargo-zigbuild
      pkgs.colima
      pkgs.nmap
      pkgs.postgresql
      pkgs.zig
      (pkgs.nerdfonts.override { fonts = [ "FiraCode"]; })
    ];

    file = {
        ".inputrc" = {
            source = ./inputrc;
            target = ".inputrc";
        };
        # I don't like app's creating a bunch of random dirs in my home dir
        ".user-dirs.dirs" = {
            source = ./user-dirs.dirs;
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
      ignores = [ ".DS_Store" ];
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
};
}
