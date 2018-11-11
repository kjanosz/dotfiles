{ fetchFromGitHub, buildGoPackage, ... }:

buildGoPackage rec {
  name = "summon-aws-secrets-${version}";
  version = "0.2.0";
  goPackagePath = "github.com/cyberark/summon-aws-secrets";

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon-aws-secrets";
    rev = "v${version}";
    sha256 = "0mz6fnm1s40px9vlxrgl2ch38w1q8mnx2xfmqv7f97jdmna5ih1s";
  };
}
