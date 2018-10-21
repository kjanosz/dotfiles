{ ulib }:

self: super:

with ulib;

foldlExtensions [
  (self: super: {
    lib = super.lib // ulib;
  })

  (self: super: {  
    # 2018-10-16T10:33:58+01:00
    unstable = nixpkgsOf {
      rev = "45a419ab5a23c93421c18f3d9cde015ded22e712";
      sha256 = "00mpq5p351xsk0p682xjggw17qgd079i45yj0aa6awawpckfx37s";
    };
  })

  (self: super: {
    brainworkshop = super.callPackage ./pkgs/brainworkshop { };

    browserpass = super.unstable.browserpass;

    calibre = super.calibre.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ super.python27Packages.dns ];
    });

    chromium = super.unstable.chromium;

    desktop_utils = super.callPackage ./pkgs/desktop_utils { };

    firefox = super.unstable.firefox-unwrapped;
  })

  (self: super: foldlExtensions [
    (import ./dev.nix)

    (self: super: {
      albacross = (import ./albacross.nix) self (super.albacross or super);
    })
  ] self super)
] self super