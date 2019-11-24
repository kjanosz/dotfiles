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

    mullvad-vpn = super.unstable.mullvad-vpn.overrideAttrs (oldAttrs: rec {
        name = "mullvad-vpn-${version}";
        version = "2019.9";
        src = super.pkgs.fetchurl {
          url = "https://www.mullvad.net/media/app/MullvadVPN-${version}_amd64.deb";
          sha256 = "1q833zw5870grblia66hkl9xywpasyyi6x5krzdxmbxmgk4b39ab";
        };
    });
  })

  (self: super: foldlExtensions [
    (import ./dev.nix)

    (self: super: {
      albacross = (import ./albacross.nix) self (super.albacross or super);
    })
  ] self super)
] self super
