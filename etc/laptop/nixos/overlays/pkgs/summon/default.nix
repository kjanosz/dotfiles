{ fetchFromGitHub, buildGoPackage, ... }:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "summon";
  version = "0.6.6";

  goPackagePath = "github.com/cyberark/${pname}";

  goDeps = ./deps.nix;
  
  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1l0qkf0i3vcv53h31hy7699xa3km9krqn2qabzi4v95hgkri4mr2";
  };
}  
