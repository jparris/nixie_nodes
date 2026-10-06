{ ... }: {
  flake.homeModules.beets = { pkgs, ... }: {
    programs.beets = {
      enable = true;
      package =
        let
          # extrafiles is gone from nixpkgs (unmaintained since 2020, broken since
          # beets 2.0.0); filetote is its maintained successor. Nixpkgs marks it
          # broken on beets >= 2.14 only because the plugin's own test suite calls
          # beets internals that moved, so skip those tests.
          # https://github.com/gtronset/beets-filetote/issues/402
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
        plugins = [
          "fetchart"
          "embedart"
          "filetote"
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
