{ ulib }:

self: super:

with ulib;

foldlExtensions [
  (self: super: {
    lib = super.lib // ulib;
  })

  (self: super: {
    # 2019-05-15T19:54:37-04:00
    unstable = nixpkgsOf {
      rev = "bc9df0f66110039e495b6debe3a6cda4a1bb0fed";
      sha256 = "0y2w259j0vqiwjhjvlbsaqnp1nl2zwz6sbwwhkrqn7k7fmhmxnq1";
    };
  })

  (self: super: {
    calibre = super.calibre.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ super.python27Packages.dns ];
    });

    desktop_utils = super.callPackage ./pkgs/desktop_utils { };

    mullvad = super.callPackage ./pkgs/mullvad { };
  })

  (self: super: foldlExtensions [
    (import ./dev.nix)

    (self: super: {
      albacross = (import ./albacross.nix) self (super.albacross or super);
    })
  ] self super)
] self super
