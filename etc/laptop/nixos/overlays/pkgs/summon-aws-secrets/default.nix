{ buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "summon-aws-secrets";
  version = "0.4.0";
  
  vendorSha256 = "1ri65jq2ykiw907ynqqsm3764wp284pl0d5b75ac48dvczvhlkn0";

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon-aws-secrets";
    rev = "v${version}";
    sha256 = "04y5pmb6gx1f4l6mrwlbpi6hxsfxjw9scfy81ndfjifwgzjppfmv";
  };

  postInstall = ''
    mkdir -p $out/lib/summon
    ln -sf $out/bin/summon-aws-secrets $out/lib/summon/summon-aws-secrets
  '';

  doCheck = false;
}
