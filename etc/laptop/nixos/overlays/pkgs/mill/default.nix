{ fetchurl, stdenv, ... }:

stdenv.mkDerivation rec {
  name = "mill-${version}";
  version = "0.5.9";
  src = fetchurl {
    url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}";
    sha256 = "003rm2qqzzxf3g59fxd8vlll9payw1gcvjqvvf5axdyfr0sg4z1z";
  };

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/mill
    chmod +x $out/bin/mill
  '';
}
