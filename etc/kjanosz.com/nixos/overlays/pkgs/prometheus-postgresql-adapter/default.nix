{ fetchFromGitHub, buildGoPackage, ... }:

buildGoPackage rec {
  name = "prometheus-postgresql-adapter-${version}";
  version = "0.4.1";

  goPackagePath = "github.com/timescale/prometheus-postgresql-adapter";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "prometheus-postgresql-adapter";
    rev = "${version}";
    sha256 = "0fflph6wsibs9ylp5m3v4l5bspn8mbxdaffvakzl3s1pj19q3g1x";
  };
}  
