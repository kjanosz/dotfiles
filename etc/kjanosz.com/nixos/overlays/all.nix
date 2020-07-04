{ ulib }:

self: super:

with ulib;

rec {
  unstable = import (builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs-channels";
    ref = "nixos-unstable";
  }) {};

  kanboard = super.callPackage ./pkgs/kanboard { };

  kanboardPlugins = super.callPackage ./pkgs/kanboard/plugins.nix { };
}
