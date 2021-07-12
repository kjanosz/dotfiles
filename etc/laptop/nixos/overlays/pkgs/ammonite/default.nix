{ scala ? "3.0", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.12" = "1l1dlbhgiiixdqlbqwcbaczyxcj8d9rnngb465ip16l0lhilihib";
    "2.13" = "186z1h16h8ap354cdv4dmkbkbalyycq6aza8z1di7sl82nmgjpfq";
    "3.0"  = "0c62y5hphyw4lvynp1lgpmp69m39gncaz53dvr4rii8k4lmj5fri";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "2.4.0";
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
