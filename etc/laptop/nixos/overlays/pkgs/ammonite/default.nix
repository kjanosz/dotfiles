{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.11" = "1yy4qpqjyzq56y9lvay8gslyfqi63q8cvn7g7kfh8s3y52b6hlla";
    "2.12" = "16mx2394wmm4jvy26rlp46mb2nf8cayvxclpa6fn0sb4klqs7mc2";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "1.6.4";
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
