{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.12" = "12pxpjdjlqjwb1m393bclbhyn303y87yyw5jg7h5pign7g3kn0mc";
    "2.13" = "1sv6v2fr1y6xv6y9jmdql32389ml78ymk53qbmh2clwbxgszc0h7";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "2.1.4";
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
