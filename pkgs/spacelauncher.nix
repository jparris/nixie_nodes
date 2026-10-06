{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
let
  pname = "spacelauncher";
  version = "3.5.5";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  # Upstream only publishes an unversioned "latest" archive (see the Sparkle
  # feed at https://spacelauncherapp.com/download/appcast.xml), so this hash
  # has to be refreshed together with `version`.
  src = fetchurl {
    url = "https://spacelauncherapp.com/download/SpaceLauncher.zip";
    hash = "sha256-3vUH1+GVl0lf9H3KjoswpZ9wk2+ij5Qbauc8Eo9G/lc=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = "SpaceLauncher.app";

  installPhase = ''
    runHook preInstall

    # unzip materialises the archive's AppleDouble entries as ._* files, which
    # macOS then counts as unsealed contents in the signed bundle.
    find . -name '._*' -delete

    mkdir -p "$out/Applications/SpaceLauncher.app"
    cp -R . "$out/Applications/SpaceLauncher.app"

    mkdir -p $out/bin
    ln -s "$out/Applications/SpaceLauncher.app/Contents/MacOS/spacelauncher-cli" $out/bin/spacelauncher-cli

    runHook postInstall
  '';

  meta = {
    description = "Launch and switch apps with Space as a leader key on macOS";
    homepage = "https://spacelauncherapp.com/";
    changelog = "https://spacelauncherapp.com/changelog.html";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.platforms.darwin;
    mainProgram = "spacelauncher-cli";
  };
}
