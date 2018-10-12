{ fetchFromGitHub, buildGoPackage, ... }:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "chamber";
  version = "2.2.0";

  goPackagePath = "github.com/segmentio/${pname}";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0cb3ndqzfarnsfrpwsga06ynyd7myv6cm1l0mhmnmcmiwds3wbi5";
  };
}  
