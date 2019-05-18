{ fetchFromGitHub, buildGoPackage, pkgs, ... }:

buildGoPackage rec {
  name = "prometheus-postgresql-adapter-${version}";
  version = "HEAD";

  buildInputs = with pkgs; [ dep ];

  goPackagePath = "github.com/timescale/prometheus-postgresql-adapter";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "prometheus-postgresql-adapter";
    rev = "c857476921d4455c4756dd13714964c6c4d2c192";
    sha256 = "0gg855c6vv8sq0y0s1jri9bz9gyzjj9nrd9v1098xif9z73mdva9";
  };
}  
