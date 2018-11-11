{ fetchurl, stdenv, ... }:

stdenv.mkDerivation rec {
  name = "mill-${version}";
  version = "0.3.4";
  src = fetchurl {
    url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}";
    sha256 = "1kcamsqj43gb27zg4njgn6jzsg1ay019f32c67h1jjvp9zz9zw3g";
  };

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/mill
    chmod +x $out/bin/mill
  '';
}
