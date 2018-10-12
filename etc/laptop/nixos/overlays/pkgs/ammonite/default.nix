{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.11" = "0cvqjgqjkjg7sl8yrjqp8v172ibhg0x7i1r5wy65921xjhg0sw4m";
    "2.12" = "096xychdq1pmyjfv4cv4pvm29dk539rxpq3iaz9rpznp01af4mjf";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "1.2.1";
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
