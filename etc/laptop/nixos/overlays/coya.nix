self: super:

{
  aws-vault = super.unstable.aws-vault.overrideAttrs (oldAttrs: rec {
    version = "4.2.0";

    src = self.fetchFromGitHub {
      owner = "99designs";
      repo = "aws-vault";
      rev = "v${version}";
      sha256 = "0r8kwzv25jnlh0w13z0j83pijhzjpjcg555fp45jb7x4ac3ya53g";
    };
  });

  blessclient = self.callPackage pkgs/blessclient { };

  chamber = self.callPackage pkgs/chamber { };

  pre-commit = self.callPackage pkgs/pre-commit { };

  slack = super.unstable.slack;
}
  
