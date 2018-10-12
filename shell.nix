{ pkgs ? import <nixpkgs> { overlays = [ (self: super: (import ./etc/laptop/nixos/overlays/all.nix { ulib = (import ./etc/nixos/nixos/lib.nix super); } self super)) ]; } }:

with pkgs;

stdenv.mkDerivation {
  name = "dotfiles";

  buildInputs = [ tomb ];
}
