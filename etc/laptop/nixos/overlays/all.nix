{ ulib }:

self: super:

with ulib;

foldlExtensions [
  (self: super: {
    lib = super.lib // ulib;
  })

  (self: super: {
    unstable = import (builtins.fetchGit {
      url = "https://github.com/NixOS/nixpkgs-channels";
      ref = "nixos-unstable";
    }) { config = { allowUnfree = true; }; };
  })

  (self: super: {
    calibre = super.calibre.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ (with super.python2Packages; [ pycrypto ]);
    });

    desktop_utils = super.callPackage ./pkgs/desktop_utils { };
  })

  (self: super: foldlExtensions [
    (import ./dev.nix)

    (self: super: {
      albacross = (import ./albacross.nix) self (super.albacross or super);
    })
  ] self super)
] self super
