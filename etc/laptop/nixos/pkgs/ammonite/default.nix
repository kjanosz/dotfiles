{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.10" = "0swnf42j47c6ybrqq87fspgssr21yvvx7nvcx8a5ki92lxs3xr2i";
    "2.11" = "0gq7x015bhz7lw0v36b9ka6r4c5i244fh0v4xnvi8qbyhpqml8f5";
    "2.12" = "11xn84q947qrf0p2p37pyx9nphl6542jbdan3mjcmdi4p29qgds8";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "1.0.2";
  src = fetchurl {
    url = "https://github.com/lihaoyi/Ammonite/releases/download/${version}/${scala}-${version}";
    sha256 = checksums."${scala}";
  };

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/amm${scala}
    chmod +x $out/bin/amm${scala}
  '';
}
