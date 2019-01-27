{ ulib }:

self: super:

with ulib;

foldlExtensions [
  (self: super: {
    lib = super.lib // ulib;
  })

  (self: super: {  
    # 2019-01-20T18:32:34+01:00
    unstable = nixpkgsOf {
      rev = "bc41317e24317b0f506287f2d5bab00140b9b50e";
      sha256 = "1skl7icprfdq9wj1nivqyhylimgq7vy950h2m1lpbz2xjb3dk15k";
    };
  })

  (self: super: {
    calibre = super.calibre.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ super.python27Packages.dns ];
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