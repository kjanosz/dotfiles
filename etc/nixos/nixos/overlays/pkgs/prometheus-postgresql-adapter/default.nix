{ lib, fetchFromGitHub, buildGoPackage, makeWrapper, ... }:

with lib;

buildGoPackage rec {
  name = "prometheus-postgresql-adapter-${version}";
  version = "0.2.1";

  goPackagePath = "github.com/timescale/prometheus-postgresql-adapter";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "prometheus-postgresql-adapter";
    rev = "v${version}";
    sha256 = "05wa64n3j8yc57j6lbgjfj60ih4xg8dc9x4f4paj41pfni1mgi5l";
  };
}