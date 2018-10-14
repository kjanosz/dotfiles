{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "terraform-provider-vultr-${version}";
  version = "0.1.8";
  goPackagePath = "github.com/squat/terraform-provider-vultr";
  
  src = fetchFromGitHub {
    owner = "squat";
    repo = "terraform-provider-vultr";
    ev = "v${version}";
    sha256 = "0za8p4bs55jv666ggwm48c9mmgk7lqn46h7rwy9zpfnnv75py10l";
  };

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/terraform-provider-vultr{,_v${version}}";
}
