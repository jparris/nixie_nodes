{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,

  # Darwin
  undmg,

  # Linux
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
  alsa-lib,
  atk,
  cairo,
  dbus,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libX11,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libglvnd,
  libva,
  libxcb,
  pango,
  pciutils,
  pipewire,
}:
let
  pname = "glide";
  version = "0.1.64a";

  sources = {
    x86_64-linux = {
      file = "glide.linux-x86_64.tar.xz";
      hash = "sha256-H5ewo9GbWbpkFFsAARd0FHxD9AXU8Dc4alvNqa6lMP0=";
    };
    aarch64-linux = {
      file = "glide.linux-aarch64.tar.xz";
      hash = "sha256-WIsgOPKP8K9P3dUSMY2iNRmjgElVdwilnF7hZ7TxWeY=";
    };
    x86_64-darwin = {
      file = "glide.macos-x86_64.dmg";
      hash = "sha256-rLruG+WY6XyDr8t7ghRpUbQp0xlIiXua/3TTlfL5TrQ=";
    };
    aarch64-darwin = {
      file = "glide.macos-aarch64.dmg";
      hash = "sha256-lm1/XbMdEwzM3iMQlyXqg7kAbAgxPcwQwcC/aDPggqY=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "glide: unsupported platform ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/glide-browser/glide/releases/download/${version}/${source.file}";
    inherit (source) hash;
  };

  meta = {
    description = "Extensible and keyboard-focused web browser built on Firefox";
    homepage = "https://glide-browser.app/";
    changelog = "https://github.com/glide-browser/glide/releases/tag/${version}";
    license = lib.licenses.mpl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.attrNames sources;
    mainProgram = "glide";
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Glide.app";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/Glide.app"
      cp -R . "$out/Applications/Glide.app"

      mkdir -p $out/bin
      ln -s "$out/Applications/Glide.app/Contents/MacOS/glide" $out/bin/glide

      runHook postInstall
    '';
  };

  linux = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [
      autoPatchelfHook
      copyDesktopItems
      wrapGAppsHook3
    ];

    buildInputs = [
      alsa-lib
      atk
      cairo
      dbus
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libX11
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libxcb
      pango
      stdenv.cc.cc.lib
    ];

    # dlopen()ed rather than linked, so autoPatchelfHook can't discover them.
    runtimeDependencies = [
      libGL
      libglvnd
      libva
      pciutils
    ];
    appendRunpaths = [ (lib.makeLibraryPath [ pipewire ]) ];

    # Stripping the prebuilt Gecko libraries breaks them.
    dontStrip = true;

    sourceRoot = "glide";

    desktopItems = [
      (makeDesktopItem {
        name = "glide";
        desktopName = "Glide";
        genericName = "Web Browser";
        comment = meta.description;
        icon = "glide";
        exec = "glide %U";
        terminal = false;
        startupNotify = true;
        startupWMClass = "glide";
        categories = [
          "Network"
          "WebBrowser"
        ];
        keywords = [
          "browser"
          "vim"
        ];
        mimeTypes = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
      })
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/glide
      cp -R . $out/lib/glide

      mkdir -p $out/bin
      ln -s $out/lib/glide/glide $out/bin/glide

      for size in 16 32 48 64 128; do
        install -Dm644 browser/chrome/icons/default/default$size.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/glide.png
      done

      runHook postInstall
    '';

    preFixup = ''
      # The store path changes on every update, which Gecko's install-hash
      # based profile selection otherwise reads as a brand new install.
      gappsWrapperArgs+=(
        --set MOZ_APP_LAUNCHER "$out/bin/glide"
        --set MOZ_LEGACY_PROFILES 1
        --set MOZ_ALLOW_DOWNGRADE 1
      )
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
