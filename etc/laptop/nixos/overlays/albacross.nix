self: super:

{
    summon-aws-secrets = super.callPackage ./pkgs/summon-aws-secrets { };

    terraform_0_12 = super.unstable.terraform.overrideAttrs (oldAttrs: rec {
        name = "terraform-${version}";
        version = "0.12.20";
        src = super.pkgs.fetchFromGitHub {
            owner  = "hashicorp";
            repo   = "terraform";
            rev    = "v${version}";
            sha256 = "1k94iwhdvp1ifg9w7y26cl89ihki2w9kxv8mz06pp9bnfwfw67x5";
        };
    });
}
