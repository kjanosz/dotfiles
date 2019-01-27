{ fetchFromGitHub, buildGoPackage, ... }:

buildGoPackage rec {
  name = "chamber-${version}";
  version = "2.3.1";

  goPackagePath = "github.com/segmentio/chamber";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "chamber";
    rev = "v${version}";
    sha256 = "1l63nb0kz0dnn10iggcrs4pzd6k577vprvsfrv9l1516829xip1r";
  };
}  
