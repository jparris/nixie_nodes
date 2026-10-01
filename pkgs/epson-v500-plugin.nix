# https://github.com/RobbieJennings/nix-config/
# License: GPL3
# Based on
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  rpm,
  cpio,
}:

let
  pname = "epson-v500-plugin";
  version = "2.30.4";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    urls = [
      "https://www.hamrick.com/files/iscan-gt-x770-bundle-${version}.x64.rpm.tar.gz"
      "https://web.archive.org/web/20260401195429/https://www.hamrick.com/files/iscan-gt-x770-bundle-${version}.x64.rpm.tar.gz"
    ];
    sha256 = "03c83760712f1895d66853df7d7c6c82e40d9aef894a612f094decaa4d6d1db2";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    rpm
    cpio
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    cd plugins
    rpm2cpio iscan-plugin-gt-x770-*.x86_64.rpm | cpio -idm

    mkdir -p $out/share $out/lib
    cp -r usr/share/* $out/share
    cp -r usr/lib64/* $out/lib

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.hamrick.com/iscan.html";
    description = "plugin files for epson perfection v500 scanner";
    license = licenses.epson;
    platforms = [ "x86_64-linux" ];
  };
}
