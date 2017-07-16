{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.10" = "b612e4c642b29dc1b7f652e2150383fe9fa2f57300b7751837bf6150dd32bad0";
    "2.11" = "390bd4e8d1c443b3ce66096b9125dbc4f4aa7486a898617a52d2a2654fea6cd2";
    "2.12" = "4084101271944253d0528587d437e9f15c2661c3289b50bb69925a3077c3fc39";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "0.8.2";
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
