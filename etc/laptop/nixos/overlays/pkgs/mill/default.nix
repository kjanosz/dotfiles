{ fetchurl, stdenv, ... }:

stdenv.mkDerivation rec {
  name = "mill-${version}";
  version = "0.4.2";
  src = fetchurl {
    url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}";
    sha256 = "0mn640k6qzhl59maa9riyl017xw6x2sl56faakjw12ikazgq1h1r";
  };

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/mill
    chmod +x $out/bin/mill
  '';
}
