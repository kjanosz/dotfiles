{ fetchFromGitHub, buildGoPackage, ... }:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "chamber";
  version = "2.0.0";

  goPackagePath = "github.com/segmentio/${pname}";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0y3p52lr59jsqavcgddms201xdbbphgzxx64khyq8mz12qalxry6";
  };
}  
