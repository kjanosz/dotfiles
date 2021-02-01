{ fetchurl, stdenv, ... }:

stdenv.mkDerivation rec {
  name = "mill-${version}";
  version = "0.8.0";
  src = fetchurl {
    url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}-assembly";
    sha256 = "0qi7bzb0dzi89prgy4i4bk137k8hz4j89nixviqpdxawabnhdw00";
  };

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/mill
    chmod +x $out/bin/mill
  '';
}
