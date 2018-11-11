{ pkgs, ... }:

with pkgs;

vscode-with-extensions.override {
  vscodeExtensions = vscode-utils.extensionsFromVscodeMarketplace [
    # general
    {
      name = "auto-run-command";
      publisher = "gabrielgrinberg";
      version = "1.5.0";
      sha256 = "1dp4rsyd2047z2pb30v93qfaccf0jrrl73j4b61a589hhh1kdn7y";
    }
    {
      name = "code-runner";
      publisher = "formulahendry";
      version = "0.9.5";
      sha256 = "0z6pfh21dzwcv81dcsi4v6x71fxl6aalnhbj033w4zs4sxryzjq8";
    }
    {
      name = "project-manager";
      publisher = "alefragnani";
      version = "9.1.0";
      sha256 = "0z525nln4gr3may1mm9agxmvvlrl7118x40s2pj9l0df3l02j51z";
    }
    {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "1.7.0";
      sha256 = "15606y2ci79i7sw2j3w14zlxs23w4y4y7c552ah9fmhrjmzmv44y";
    }
    {
      name = "open-in-browser";
      publisher = "techer";
      version = "2.0.0";
      sha256 = "1s5mgw0jaasis0ish3da3dl7vqsgkx9cgrp1mmpgh9c4wlr12xnx";
    }
    {
      name = "quicktype";
      publisher = "quicktype";
      version = "12.0.46";
      sha256 = "0mzn1favvrzqcigr74gmy167qak5saskhwcvhf7f00z7x0378dim";
    }
    

    # vcs
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "8.5.6";
      sha256 = "1vn6fvxn4g3759pg9rp8hqdc58pgyvcdma1ylfwmdnipga37xfd3";
    }
    {
      name = "vscode-pull-request-github";
      publisher = "GitHub";
      version = "0.2.3";
      sha256 = "02cc1wzaairsvfam5hrg329l3qh5087sgfn6gm1wfl9zm3dybcyr";
    }

    # coq
    {
      name = "vscoq";
      publisher = "siegebell";
      version = "0.2.7";
      sha256 = "1kp24f7fg7cf0xyclhikj2lngw3qaxfklap2scqkvcf0g09zz1n6";
    }
    # docker
    {
      name = "vscode-docker";
      publisher = "PeterJausovec";
      version = "0.3.1";
      sha256 = "13rkgc45vk25nphnkjdqrjm1zy32s2v54ycy9vm6kvi9na71fl7d";
    }
    # haskell
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "2.5.0";
      sha256 = "10jqj8qw5x6da9l8zhjbra3xcbrwb4cpwc3ygsy29mam5pd8g6b3";
    }
    {
      name = "vscode-hie-server";
      publisher = "alanz";
      version = "0.0.24";
      sha256 = "06dm6x6jnqgraims38qzf06yk9acr0ws2hx8i9fsrilv99pc9ryr";
    }
    # idris
    {
      name = "Idris"; 
      publisher = "zjhmale";
      version = "0.9.8";
      sha256 = "1dfh1rgybhnf5driwgxh69a1inyzxl72njhq93qq7mhacwnyfsdp";
    }
    # java
    {
      name = "java"; 
      publisher = "redhat";
      version = "0.33.0";
      sha256 = "0fgy34iwdckdkhvhxx19v07cy7501950i69dkgb432dr361cyg99";
    }
    {
      name = "vscode-java-debug"; 
      publisher = "vscjava";
      version = "0.15.0";
      sha256 = "1p0jf3jf7smf0xxbbzjfj4kg3dq6wxdwilk5b5c7kjd24il210b4";
    }
    # nix
    {
      name = "Nix"; 
      publisher = "bbenoist";
      version = "1.0.1";
      sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    }
    # purescript
    {
      name = "ide-purescript"; 
      publisher = "nwolverson";
      version = "0.19.1";
      sha256 = "1xjyqfvrrwhfpprd6x8waigjz11szjfcjcg2707rdpl6a4k38vq3";
    }
    {
      name = "language-purescript"; 
      publisher = "nwolverson";
      version = "0.2.0";
      sha256 = "14vrj35bw0k333wdv3x9brpxhwqfls882smzlq0ks24lvf510qa8";
    }
    # plantuml
    {
      name = "plantuml"; 
      publisher = "jebbs";
      version = "2.9.8";
      sha256 = "0zbhlwj1hnr38wbhlap2pvjl7kh4rinp4jp150lwi4rqi6b954vw";
    }
    # python
    {
      name = "jupyter"; 
      publisher = "donjayamanne";
      version = "1.1.4";
      sha256 = "02ldh8p6sd9x83j7xvs1lp4caxnrnxkrsixig9gadqfxh12p24cy";
    }
    {
      name = "nbpreviewer"; 
      publisher = "jithurjacob";
      version = "1.0.0";
      sha256 = "0wm56bd21halpysc86ngfn4wga0hx0jpbkh55pi59dnkksdhh6ig";
    }
    {
      name = "python"; 
      publisher = "ms-python";
      version = "2018.10.1";
      sha256 = "1j9nf09v31lmrjkxf7p1d78d064x6afzh0dvssmk3sjm2c5r432k";
    }
    # rust
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.4.10";
      sha256 = "1y7sb3585knv2pbq7vf2cjf3xy1fgzrqzn2h3fx2d2bj6ns6vpy3";
    }
    # scala
    {
      name = "scala";
      publisher = "scala-lang";
      version = "0.2.0";
      sha256 = "0z2knfgn1g5rvanssnz6ym8zqyzzk5naaqsggrv77k6jzd5lpw49";
    }
    {
      name = "scala-lsp";
      publisher = "dragos";
      version = "0.2.3";
      sha256 = "1xp8iv83rdzd8xq590n5b8wpvv99fb97sxwcvarapcp4rp8nas4n";
    }
    {
      name = "vscode-sbt-scala";
      publisher = "lightbend";
      version = "0.2.3";
      sha256 = "0zfz7nwywa8i8yvjndiqdv5a9m2kls8z8zavr79ks0xlpd6majg0";
    }
    # scheme
    {
      name = "vscode-scheme";
      publisher = "sjhuangx";
      version = "0.3.2";
      sha256 = "0v6a6dzjw6zkpjc92jaiah5nbk9c85f4jfbzhwwcm0q1lbj0wyjq";
    }
    # terraform
    {
      name = "terraform";
      publisher = "mauve";
      version = "1.3.7";
      sha256 = "07yn4x2ad5bcxzrxfji8vq9z416551v4ad41b4id389zg886am86";
    }
  ];
}
