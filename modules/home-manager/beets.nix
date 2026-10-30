{ ... }: {
  flake.homeModules.beets = { pkgs, ... }: {
    programs.beets = {
      enable = true;
      package =
        let
          filetote = pkgs.python3Packages.beets-filetote.overridePythonAttrs (old: {
            doCheck = false;
            meta = old.meta // {
              broken = false;
            };
          });
        in
        pkgs.python3Packages.toPythonApplication (
          pkgs.python3Packages.beets.override {
            pluginOverrides.filetote = {
              enable = true;
              propagatedBuildInputs = [ filetote ];
            };
          }
        );
      settings = {
        directory = "/wunderkammer/audio/music/";
        plugins = [
          "fetchart"
          "filetote"
          "musicbrainz"
        ];
        filetote.extensions = [
          ".cue"
          ".log"
          ".nfo"
          ".jpg"
          ".png"
          ".pdf"
        ];
      };
    };
  };
}
