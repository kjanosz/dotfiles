self: super:

{
    summon-aws-secrets = super.callPackage ./pkgs/summon-aws-secrets { };

    terraform = super.unstable.terraform.overrideAttrs (oldAttrs: rec {
        name = "terraform-${version}";
        version = "0.11.10";
        src = super.pkgs.fetchFromGitHub {
            owner  = "hashicorp";
            repo   = "terraform";
            rev    = "v${version}";
            sha256 = "08mapla89g106bvqr41zfd7l4ki55by6207qlxq9caiha54nx4nb";
        };
    });
}
