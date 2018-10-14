{ ulib }:

self: super:

with ulib;

foldlExtensions [
  (self: super: {
    lib = super.lib // ulib;
  })

  (self: super: {  
    # 2018-10-04T16:33:36+02:00
    unstable = nixpkgsOf {
      rev = "0a7e258012b60cbe530a756f09a4f2516786d370";
      sha256 = "1qcnxkqkw7bffyc17mqifcwjfqwbvn0vs0xgxnjvh9w0ssl2s036";
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