{ lib, fetchurl, stdenv, pkgs, ... }:

with lib;

let
  libPath = makeLibraryPath (with pkgs; [ libpulseaudio systemd.lib ]);
in
stdenv.mkDerivation rec {
  name = "mullvad-${version}";
  version = "2019.3";

  src = fetchurl {
    url = "https://mullvad.net/media/app/MullvadVPN-${version}_amd64.deb";
    sha256 = "12y2k7f578z8apklsmpbkwnjyfv8q39crrbjnr6hng87q7kgvb8l";
  };
  unpackCmd = "mkdir root ; dpkg-deb -x $curSrc root";

  nativeBuildInputs = with pkgs; [ dpkg autoPatchelfHook makeWrapper ];
  buildInputs = with pkgs; [ alsaLib atk at-spi2-atk cairo cups dbus glib gtk3 nspr nss pango stdenv.cc.cc xorg.libX11 xorg.libXScrnSaver xorg.libXtst ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/lib/mullvad

    mv usr/bin $out/
    mv usr/share $out/
    mv opt/Mullvad\ VPN/* $out/lib/mullvad/

    mv $out/lib/mullvad/resources $out/lib/mullvad/daemon
    ln -s $out/lib/mullvad/daemon/mullvad-daemon $out/bin/mullvad-daemon
    rm $out/lib/mullvad/daemon/mullvad-daemon.conf
    rm $out/lib/mullvad/daemon/mullvad-daemon.service
    ln -s $out/lib/mullvad/mullvad-vpn $out/bin/mullvad-gui

    substitute $out/share/applications/mullvad-vpn.desktop \
      $out/share/applications/mullvad-vpn.desktop \
      --replace /opt/Mullvad\ VPN/mullvad-vpn $out/bin/mullvad-gui
    wrapProgram $out/lib/mullvad/mullvad-vpn --prefix LD_LIBRARY_PATH : "${libPath}"  
  '';
}
