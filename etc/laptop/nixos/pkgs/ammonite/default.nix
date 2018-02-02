{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.10" = "0s4283l7bx013dg31lbbsbcv9rr7s0kan39ihkqbi1j0hrg6yixl";
    "2.11" = "085qsghsmax4fllaa5g064mz0cdcnpjdpsbx8dbray9myryzvazf";
    "2.12" = "0g5fdf9pk0v2l2mbwbs5chj2fzpq4lrpm22l1i44cmfbcyq91vk9";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "1.0.3";
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
