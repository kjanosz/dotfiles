{ pkgs, system, nodejs }:

let
  nodePackages = import ./package.nix {
    inherit pkgs system nodejs;
  };
in nodePackages.base16-builder
