{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.11" = "0m3a0byxyg5mazj298qbznq2yw8qpkqqrivlkm99x7nfyvg7h4dy";
    "2.12" = "0wdicgf41ysxcdly4hzpav52yhjx410c7c7nfbq87p0cqzywrbxd";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "1.6.3";
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
