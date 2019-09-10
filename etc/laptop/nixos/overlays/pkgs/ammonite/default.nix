{ scala ? "2.12", fetchurl, stdenv, ... }:

let 
  checksums = {
    "2.12" = "1fi5j0kcndq00x72d8bkx6qiy9nh2i6c6m29gzfqql52qgbq1fd0";
    "2.13" = "0d8zdy1zkky4w3arvb097vbhnjaz3vicf1c37dn15x0qrhlbn4s8";
  };
in
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "1.6.9";
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
