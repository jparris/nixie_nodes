{
  lib,
  stdenv,
  fetchurl,
  gnutar,
  autoPatchelfHook,
  glibc,
  gtk3,
  glib,
  pango,
  cairo,
  gdk-pixbuf,
  libxkbcommon,
  libuuid,
  systemdLibs,
  zlib,
  libx11,
  makeDesktopItem,
}:
let
  pname = "vuescan";
  version = "9.8.59";
  desktopItem = makeDesktopItem {
    name = "VueScan";
    desktopName = "VueScan";
    genericName = "Scanning Program";
    comment = "Scanning Program";
    icon = "vuescan";
    terminal = false;
    type = "Application";
    startupNotify = true;
    categories = [
      "Graphics"
      "Utility"
    ];
    keywords = [
      "scan"
      "scanner"
    ];

    exec = "vuescan";
  };
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://files.hamrick.com/vuex6498.tgz";
    sha256 = "a7128a0b718d939b803417c12578fc28dd7773bd55b9429be65c7348df59eba7";
  };

  # Stripping breaks the program
  dontStrip = true;

  nativeBuildInputs = [
    gnutar
    autoPatchelfHook
  ];

  buildInputs = [
    glibc
    stdenv.cc.cc.lib # libstdc++, libgcc_s, libgomp
    gtk3
    glib
    pango
    cairo
    gdk-pixbuf
    libxkbcommon
    libuuid
    systemdLibs # libudev
    zlib
    libx11
  ];

  unpackPhase = ''
    tar xfz $src
  '';

  installPhase = ''
    runHook preInstall

    install -m755 -D VueScan/vuescan $out/bin/vuescan

    mkdir -p $out/share/icons/hicolor/scalable/apps/
    cp VueScan/vuescan.svg $out/share/icons/hicolor/scalable/apps/vuescan.svg

    mkdir -p $out/lib/udev/rules.d/
    cp VueScan/vuescan.rul $out/lib/udev/rules.d/60-vuescan.rules

    mkdir -p $out/share/applications/
    ln -s ${desktopItem}/share/applications/* $out/share/applications

    runHook postInstall
  '';

  meta = {
    description = "Scanning program supporting a wide range of scanners";
    homepage = "https://www.hamrick.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "vuescan";
  };
}
