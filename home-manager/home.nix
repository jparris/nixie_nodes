{ config, pkgs, lib, ... }:

{
  home = {
    stateVersion = "24.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = [
      pkgs.nixd
      pkgs.ripgrep
    ];

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
    };

    jujutsu = {
      enable = true;
    };
  };
}
