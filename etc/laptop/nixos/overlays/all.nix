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
    desktop_utils = super.callPackage ./pkgs/desktop_utils { };

    gopass = super.unstable.gopass.overrideAttrs (old: rec {
      postInstall = ''
        ${old.postInstall}
        mkdir -p $out/lib/summon
        ln -sf $out/bin/gopass $out/lib/summon/gopass
      '';
    });

    mullvad-vpn = super.unstable.mullvad-vpn.overrideAttrs (old: rec {
        name = "mullvad-vpn-${version}";
        version = "2020.6";
        src = super.pkgs.fetchurl {
          url = "https://www.mullvad.net/media/app/MullvadVPN-${version}_amd64.deb";
          sha256 = "0d9rv874avx86jppl1dky0nfq1633as0z8yz3h3f69nhmcbwhlr3";
        };
    });

    steam = super.unstable.steam.override { 
      extraPkgs = pkgs: with pkgs; [ libffi qt5.qtbase qt5.qttools qt5.qtsvg ]; 
    };
  })

  (self: super: foldlExtensions [
    (import ./dev.nix)

    (self: super: {
      albacross = (import ./albacross.nix) self (super.albacross or super);
    })
  ] self super)
] self super
