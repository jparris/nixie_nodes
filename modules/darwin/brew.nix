{inputs, ...}: {
  flake.modules.darwin.brew = {pkgs, ...}: {
    homebrew = {
      enable = true;
      global = {
        brewfile = true;
      };
      taps = ["homebrew/bundle"];
      brews = ["m1ddc"];
      casks = [
        "hiddenbar"
        "logseq"
        "notion"
        "firefox"
        "slack"
        "wezterm"
        "zed"
      ];
      masApps = {};
    };
    brew-nix.enable = true;
    environment.systemPackages = with pkgs; [
      # Let's me hide menu bar items
      brewCasks.hiddenbar
      brewCasks.wezterm
    ];
  };
}
