{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.11" = "15abz6wrza3nwkiqv3a7s8niczpjymlp6n8h8xhirj5kwn14r670";
    "2.12" = "10m6nnvrwzkbyhiq77wlqgzvqfqmn16y4sp983dyihjljxalygax";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "1.4.2";
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
