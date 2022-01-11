{ stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  name = "aws-vpn-client-${version}";
  version = "HEAD";
  
  src = fetchFromGitHub {
    owner = "samm-git";
    repo = "aws-vpn-client";
    rev = "71706db15dc0f96d0c6fc30a80dfb40f46f28219";
    sha256 = "1cs3h64n1qqvwprfq5g1dwjkn5mzqdsnjfyw753p6c8qflh2iqmm";
  };

 }
