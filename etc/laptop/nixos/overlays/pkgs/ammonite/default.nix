{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.11" = "0y62f4wmnka6hmdkvp3zc7hb90r4y3pqq0blgijp3i8mklmkrnbi";
    "2.12" = "1balr7ya7xlyq32jwb0w9c4klnw13mdn2c5azkwngq5cp29yrfrc";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "1.1.2";
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
