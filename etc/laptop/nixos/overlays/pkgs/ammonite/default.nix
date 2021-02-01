{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.12" = "0nclfqwy3jfn1680z1hd0zzmc0b79wpvx6gn1jnm19aq7qcvh5zp";
    "2.13" = "104bnahn382sb6vwjvchsg0jrnkkwjn08rfh0g5ra7lwhgcj2719";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "2.2.0";
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
