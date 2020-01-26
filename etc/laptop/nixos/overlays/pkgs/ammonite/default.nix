{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.12" = "068lcdi1y3zcspr0qmppflad7a4kls9gi321rp8dc5qc6f9nnk04";
    "2.13" = "0fa0q9nk00crr2ws2mmw6pp4vf0xy53bqqhnws524ywwg6zwrl9s";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "2.0.4";
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
