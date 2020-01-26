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

    gopass = super.unstable.gopass.overrideAttrs (oldAttrs: rec {
      postInstall = ''
        ${oldAttrs.postInstall}
        mkdir -p $bin/lib/summon
        ln -sf $bin/bin/gopass $bin/lib/summon/gopass
      '';
    });

    mopidy-mpris = super.callPackage ./pkgs/mopidy-mpris { };

    mullvad-vpn = super.unstable.mullvad-vpn.overrideAttrs (oldAttrs: rec {
        name = "mullvad-vpn-${version}";
        version = "2019.10";
        src = super.pkgs.fetchurl {
          url = "https://www.mullvad.net/media/app/MullvadVPN-${version}_amd64.deb";
          sha256 = "0nckbhfpf4r5l5h22jcv93b5i9y2sc8lhcaffsg2ld804h5ygbbq";
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
