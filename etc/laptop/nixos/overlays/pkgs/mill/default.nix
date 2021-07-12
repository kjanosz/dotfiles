{ fetchurl, stdenv, ... }:

stdenv.mkDerivation rec {
  name = "mill-${version}";
  version = "0.9.8";
  src = fetchurl {
    url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}-assembly";
    sha256 = "1dpp8qssvns9qny5mj93hj4rbzd7fhywh5hryc1p1la3qykfnih2";
  };

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/mill
    chmod +x $out/bin/mill
  '';
}
