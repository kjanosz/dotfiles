{ buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  name = "summon-aws-secrets-${version}";
  version = "0.3.0";
  
  modSha256 = "1xfhp8jqsx32axk6blcwjbs2h11q5pb6c9yiwibw14j9hx6a15jp"; 

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon-aws-secrets";
    rev = "v${version}";
    sha256 = "1x73dc2j855rapb3a08hwvx42s2i0jdz62cbkqy27n52yy0wij61";
  };

  postInstall = ''
    mkdir -p $out/lib/summon
    ln -sf $out/bin/summon-aws-secrets $out/lib/summon/summon-aws-secrets
  '';
}
