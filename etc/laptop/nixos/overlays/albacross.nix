self: super:

{
    summon-aws-secrets = super.callPackage ./pkgs/summon-aws-secrets { };

    terraform_0_12 = super.unstable.terraform_0_12.overrideAttrs (oldAttrs: rec {
        name = "terraform-${version}";
        version = "0.12.29";
        src = super.pkgs.fetchFromGitHub {
            owner  = "hashicorp";
            repo   = "terraform";
            rev    = "v${version}";
            sha256 = "18i7vkvnvfybwzhww8d84cyh93xfbwswcnwfrgvcny1qwm8rsaj8";
        };

        postInstall = ''
            ${oldAttrs.postInstall}
            mv $out/bin/terraform $out/bin/terraform_0_12
        '';
    });


    terraform_0_13 = super.unstable.terraform_0_13.overrideAttrs (oldAttrs: rec {
        name = "terraform-${version}";
        version = "0.13.5";
        src = super.pkgs.fetchFromGitHub {
            owner  = "hashicorp";
            repo   = "terraform";
            rev    = "v${version}";
            sha256 = "1fnydzm5h65pdy2gkq403sllx05cvpldkdzdpcy124ywljb4x9d8";
        };
    });
}
