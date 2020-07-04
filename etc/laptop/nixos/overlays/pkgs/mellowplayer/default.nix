{ fetchurl, lib, pkgs, qt5, stdenv, ... }:

qt5.mkDerivation rec {
  name = "mellowplayer-${version}";
  version = "3.6.2";

  src = fetchurl {
    url = "https://gitlab.com/ColinDuquesnoy/MellowPlayer/-/archive/${version}/MellowPlayer-${version}.tar.gz";
    sha256 = "15biw5b86arq0ayhssf19mik644fhshbcsrkwimwlfsjm9m6sbzd";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    python3Packages.mesa
    ninja
    pkgconfig
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
    libevent
    libnotify
    qt5.qtbase
    qt5.qtwebengine
    qt5.qtsvg
    qt5.qtquickcontrols2
    qt5.qtquickcontrols
    qt5.qttranslations
    qt5.qtgraphicaleffects
    vivaldi-widevine
    xdg_utils
  ];

  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp "$out/bin/MellowPlayer" --set QTWEBENGINE_CHROMIUM_FLAGS "--widevine-path=${pkgs.vivaldi-widevine}/lib/libwidevinecdm.so --no-sandbox"
  '';
}
