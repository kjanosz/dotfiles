{ ulib }:

self: super:

with ulib;

rec {
  unstable = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs-channels";
    ref = "nixos-unstable";
  }) {};
}
