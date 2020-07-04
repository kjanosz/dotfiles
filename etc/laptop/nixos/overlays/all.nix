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
        mkdir -p $out/lib/summon
        ln -sf $out/bin/gopass $out/lib/summon/gopass
      '';
    });

    mellowplayer = super.callPackage ./pkgs/mellowplayer { };

    mullvad-vpn = super.unstable.mullvad-vpn.overrideAttrs (oldAttrs: rec {
        name = "mullvad-vpn-${version}";
        version = "2020.4";
        src = super.pkgs.fetchurl {
          url = "https://www.mullvad.net/media/app/MullvadVPN-${version}_amd64.deb";
          sha256 = "17xi8g2k89vi4d0j7pr33bx9zjapa2qh4pymbrqvxwli3yhq6zwr";
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
