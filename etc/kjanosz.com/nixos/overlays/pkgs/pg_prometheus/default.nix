{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  name = "pg_prometheus";
  version = "HEAD";

  buildInputs = [ postgresql ];

  patches = [ ./postgresql_11.patch ];

  installPhase = ''
    mkdir -p $out/{lib,share/extension}
    cp *.so      $out/lib
    cp sql/*.sql     $out/share/extension
    cp *.control $out/share/extension
  '';

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "pg_prometheus";
    rev = "2e8d43a0972d41a82cf72983b3d2f86c489f6c1a";
    sha256 = "1zhlx3nlhwd3if6fazikww55lllpbmyi0avzqa7imx78jdcv3l74";
  };
}
