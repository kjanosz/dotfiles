{ scala ? "3.0", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.13" = "1mmzpl71jllap9a1wrc90nl357k3h2bz3bnyxasqif9dzwy0d6cp";
    "3.0"  = "0q6m9lryl1pcz5klq9q7wx5gzcwk7vsfh3a27sgizw3pzpvwxa1z";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "2.5.0";
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
