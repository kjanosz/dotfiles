{ ulib }:

self: super:

with ulib;

foldlExtensions [
  (self: super: {
    lib = super.lib // ulib;
  })

  (self: super: {  
    # 2018-11-07T00:05:22+01:00
    unstable = nixpkgsOf {
      rev = "6141939d6e0a77c84905efd560c03c3032164ef1";
      sha256 = "1nz2z71qvjna8ki5jq4kl6pnl716hj66a0gs49l18q24pj2kbjwh";
    };
  })

  (self: super: foldlExtensions [
    (import ./common.nix)
  ] self super)
] self super