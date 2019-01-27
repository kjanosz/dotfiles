{ lib, fetchFromGitHub, stdenv, ... }:

with lib;

stdenv.mkDerivation rec {
  name = "pg_prometheus-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "pg_prometheus";
    rev = "${version}";
    sha256 = "1k2wbx10flgqq2rlp5ccqjbyi2kgkbcr5xyh4qbwpr4zyfbadbqr";
  };
}