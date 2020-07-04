{ fetchurl, stdenv, ... }:

stdenv.mkDerivation rec {
  name = "mill-${version}";
  version = "0.7.3";
  src = fetchurl {
    url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}-assembly";
    sha256 = "0qwlj8x7gpm9shvxfy22ij575n923xqhha16scdxi767vv5fj4gg";
  };

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/mill
    chmod +x $out/bin/mill
  '';
}
