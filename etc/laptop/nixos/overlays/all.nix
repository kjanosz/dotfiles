{ ulib }:

self: super:

with ulib;

foldlExtensions [
  (self: super: {
    lib = super.lib // ulib;
  })

  (self: super: {
    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  })

  (self: super: rec {
    desktop-utils = super.callPackage ./pkgs/desktop-utils { };

    fava = super.fava.overrideAttrs (old: rec {
      propagatedBuildInputs = old.propagatedBuildInputs ++ [
        super.python3Packages.beancount_docverif
        super.python3Packages.beancount_interpolate
      ];
    });

    gopass = super.unstable.gopass.overrideAttrs (old: rec {
      postInstall = ''
        ${old.postInstall}
        mkdir -p $out/lib/summon
        ln -sf $out/bin/gopass $out/lib/summon/gopass
      '';
    });

    mullvad-vpn = super.unstable.mullvad-vpn.overrideAttrs (old: rec {
      name = "mullvad-vpn-${version}";
      version = "2021.4";
      src = super.pkgs.fetchurl {
        url = "https://www.mullvad.net/media/app/MullvadVPN-${version}_amd64.deb";
        sha256 = "0kdbvjajmp0d3m65pc6cdb9fgk2jzdk1x60hxnjpv77sl3iccw96";
      };
    });

    python3 = super.python3.override {
      packageOverrides = python-self: python-super: {
        beancount_interpolate = super.callPackage ./pkgs/beancount-interpolate { pythonPackages = super.python3Packages; };

        beancount_plugin_utils =  super.callPackage ./pkgs/beancount-plugin-utils { pythonPackages = super.python3Packages; };
      };
    };

    steam = super.unstable.steam.override { 
      extraPkgs = pkgs: with pkgs; [ libffi qt5.qtbase qt5.qttools qt5.qtsvg ]; 
    };
  })

  (self: super: foldlExtensions [
    (import ./dev.nix)

    (self: super: {
      adcolony = (import ./adcolony.nix) self (super.adcolony or super);
    })
  ] self super)
] self super
