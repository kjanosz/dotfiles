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
    calibre = super.unstable.calibre.overrideAttrs (old: rec {
      pname = "calibre";
      version = "5.34.0";  

      src = super.fetchurl {
        url = "https://download.calibre-ebook.com/${version}/${pname}-${version}.tar.xz";
        sha256 = "1qypjhl3z34ks8dr14y9vf2wgylzji3z4gsgvx8lhlywzbp03m6l";
      };
    });

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

    libmtp = super.libmtp.overrideAttrs (old: rec {
      pname = "libmtp";
      version = "1.1.19";

      src = super.pkgs.fetchFromGitHub {
        owner = pname;
        repo = pname;
        rev = "${pname}-${builtins.replaceStrings [ "." ] [ "-" ] version}";
        sha256 = "0fy99cn4r0cmwggp8rnzgsvmfnghbad2irrh3pklz9adlnh4mhm3";
      };
    });

    mullvad-vpn = super.unstable.mullvad-vpn;

    python3 = super.python3.override {
      packageOverrides = python-self: python-super: {
        beancount_interpolate = super.callPackage ./pkgs/beancount-interpolate { pythonPackages = super.python3Packages; };

        beancount_plugin_utils =  super.callPackage ./pkgs/beancount-plugin-utils { pythonPackages = super.python3Packages; };
      };
    };

    mzd-aio = super.callPackage ./pkgs/mzd-aio { };
  })

  (self: super: foldlExtensions [
    (import ./dev.nix)

    (self: super: {
      adcolony = (import ./adcolony.nix) self (super.adcolony or super);
    })
  ] self super)
] self super
