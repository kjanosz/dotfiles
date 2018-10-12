{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "terraform-provider-vultr-${version}";
  version = "0.1.7";
  goPackagePath = "github.com/squat/terraform-provider-vultr";
  
  src = fetchFromGitHub {
    owner = "squat";
    repo = "terraform-provider-vultr";
    ev = "v${version}";
    sha256 = "0kddln7v0h0y1qa3szjn8ifg65bhql123d5cv0mqfdklqsy2f4b0";
  };

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/terraform-provider-vultr{,_v${version}}";
}
