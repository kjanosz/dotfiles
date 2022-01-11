{ autoPatchelfHook, dpkg, wrapGAppsHook, fetchurl, buildFHSUserEnv, lib, pkgs, stdenv, ... }:

let 
  pkg = stdenv.mkDerivation rec {
    name = "mzd-aio-${version}";
    version = "2.8.6";
    src = fetchurl {
      url = "https://github.com/Trevelopment/MZD-AIO/releases/download/v${version}/MZD-AIO-TI-linux_${version}.deb";
      sha256 = "0m3chpmkm9grwphnlav65av8nmmvskxgnjqg2xlgvc8pimw9rziw";
    };

    nativeBuildInputs = [
      dpkg
    ];

    dontUnpack = true;
    installPhase = ''
      mkdir -p $out $out/bin $out/lib
      dpkg -x $src $out
      cp -av $out/usr/* $out
      rm -rf $out/usr
    '';

    postFixup = ''
      # Fix the desktop link
      mv $out/share/applications/AIO.desktop $out/share/applications/MZD-AIO.desktop 
      substituteInPlace $out/share/applications/MZD-AIO.desktop \
        --replace /opt/MZD-AIO-TI/AIO /run/current-system/sw/bin/mzd-aio
    '';
  };
in
buildFHSUserEnv {
  inherit (pkg) name;

  targetPkgs = pkgs: with pkgs; [
    alsaLib
    atk    
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    gdk_pixbuf
    glib
    gtk3
    libuuid
    nspr
    nss
    pango
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage 
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    xorg.libxcb
    wget
  ];

  extraInstallCommands = ''
    mv $out/bin/$name $out/bin/mzd-aio
  '';

  runScript = "${pkg}/opt/MZD-AIO-TI/AIO";
}
