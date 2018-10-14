{ lib, pkgs, python27, python27Packages, ... }:

let
  src = pkgs.fetchFromGitHub {
    owner = "samcv";
    repo = "brainworkshop";
    rev = "a4b52df6839d345654a114f2cf3e216d214c68f5";
    sha256 = "0b0xgz3q130v8k3rkwi3bldcagfn4zzff543slxxllpz83aibk30";
  };

  script = pkgs.writeScript "brainworkshop" ''
    #!/bin/sh

    ${python27}/bin/python ${src}/brainworkshop.pyw
  '';
in
pkgs.buildEnv rec {
  name = "brainworkshop-HEAD";
  paths = lib.closePropagation (with python27Packages; [ pyglet urllib3 ]);
  pathsToLink = [ "/${python27.sitePackages}" ];
  buildInputs = with pkgs; [ makeWrapper ];
  postBuild = ''
    makeWrapper ${script} $out/bin/brainworkshop \
      --prefix PYTHONPATH : $out/${python27.sitePackages}
  '';  
}