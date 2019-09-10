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
      version = "0.9.14";
      sha256 = "15y5ngcncbhssikx90sx9v3z108w2q3bgvk3j7i7w1v04p5i6wsw";
    }
    {
      name = "project-manager";
      publisher = "alefragnani";
      version = "10.7.0";
      sha256 = "00ab62m0cky52w87y0miaivf6969fvmdafm484fw9jp55l8lfj2g";
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
      version = "9.9.3";
      sha256 = "04rns3bwc9cav5rdk5bjm6m0lzjqpm9x99539bhk319l83ksffyv";
    }
    {
      name = "vscode-pull-request-github";
      publisher = "GitHub";
      version = "0.10.0";
      sha256 = "07ii3j0h106xhg3mdy1d08447yx9c4db189h86qsdmdjbygvry8s";
    }

    # coq
    {
      name = "vscoq";
      publisher = "siegebell";
      version = "0.2.7";
      sha256 = "1kp24f7fg7cf0xyclhikj2lngw3qaxfklap2scqkvcf0g09zz1n6";
    }
    # database
    {
      name = "vscode-database";
      publisher = "bajdzis";
      version = "2.2.0";
      sha256 = "1n3plggrkiy7siwlqzgb00axzlaylr5b2mwjkk7vny0k5rb02iw6";
    }
    # docker
    {
      name = "vscode-docker";
      publisher = "ms-azuretools";
      version = "0.7.0";
      sha256 = "0bgs6dy429m5yn10dd8m321slf5mqgsbr86ip61kvjwh67q9glcr";
    }
    # go
    {
      name = "Go";
      publisher = "ms-vscode";
      version = "0.11.4";
      sha256 = "0h0z4kgm0d2milbmna2j0saic3yq5p07l18dflyqwvm9zvjx9x5f";
    }
    # haskell
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "2.6.0";
      sha256 = "1891pg4x5qkh151pylvn93c4plqw6vgasa4g40jbma5xzq8pygr4";
    }
    {
      name = "vscode-hie-server";
      publisher = "alanz";
      version = "0.0.28";
      sha256 = "1gfwnr5lgwdgm6hs12fs1fc962j9hirrz2am5rmhnfrwjgainkyr";
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
      version = "0.48.0";
      sha256 = "0akvy4ryf2zvfy4pgxdh94f9dprv1hx75c87i9cgv0flm89rwmp3";
    }
    {
      name = "vscode-java-debug"; 
      publisher = "vscjava";
      version = "0.21.0";
      sha256 = "0gxrz8w97ksrqyim62hx02rfq91dvw4msn5a4mqd5kw27gqfc26x";
    }
    # julia
    {
      name = "language-julia"; 
      publisher = "julialang";
      version = "0.12.2";
      sha256 = "0dpiirm1zwszn3dmh44sfxkdkbrsbfgc2zz9k6fx4wgrgl82z79x";
    }
    # nix
    {
      name = "Nix"; 
      publisher = "bbenoist";
      version = "1.0.1";
      sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    }
    # openapi
    {
      name = "vscode-openapi";
      publisher = "42Crunch";
      version = "1.8.12";
      sha256 = "041mi13ql0lqz4w248ywjxiz4l05layxdlsn457883293kfnqfip";
    }
    # purescript
    {
      name = "ide-purescript"; 
      publisher = "nwolverson";
      version = "0.20.8";
      sha256 = "16avxmb1191l641r6pd99lw2cgq8gdfipb9n7d0czx1g9vfjr3ip";
    }
    {
      name = "language-purescript"; 
      publisher = "nwolverson";
      version = "0.2.1";
      sha256 = "18n35wp55c6k1yr2yrgg2qjmzk0vhz65bygfdk0z2p19pa4qhxzs";
    }
    # plantuml
    {
      name = "plantuml"; 
      publisher = "jebbs";
      version = "2.12.0";
      sha256 = "0jbgd8frp5bfkyskjy1visb6v6c7sfsrxig5xgf4jfircw4rs93m";
    }
    # python
    {
      name = "python"; 
      publisher = "ms-python";
      version = "2019.9.34911";
      sha256 = "18c806dk1chmcnklr8v74fawaal2lkd644yq27pbvffriwj98fib";
    }
    # rust
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.6.3";
      sha256 = "1r5q1iclr64wmgglsr3na3sv0fha5di8xyccv7xwcv5jf8w5rz5y";
    }
    # scala
    {
      name = "scala";
      publisher = "scala-lang";
      version = "0.3.4";
      sha256 = "1p2ldayaxyz9q7azlwi9b25a37d6w03q4yrzdpmixklxj5d67pch";
    }
    {
      name = "metals";
      publisher = "scalameta";
      version = "1.5.3";
      sha256 = "1cwn51z4r8znlldaxn8jq9m8333dk751wl2wrskgah71haixj6m4";
    }
    # scheme
    {
      name = "vscode-scheme";
      publisher = "sjhuangx";
      version = "0.4.0";
      sha256 = "07vjfymvfv98s5r5a4b5iqhgfz1wpgq2l8h3wlq1bnhhhvmq5pq4";
    }
    # terraform
    {
      name = "terraform";
      publisher = "mauve";
      version = "1.4.0";
      sha256 = "0b3cqxaay85ab10x1cg7622rryf4di4d35zq9nqcjg584k6jjb34";
    }
    # tla+
    {
      name = "vscode-tlaplus";
      publisher = "alygin";
      version = "0.7.0";
      sha256 = "1apw25np1l3nxmgvq8azjk8dkg35wpwhjd6mz81x16ywzq0nflma";
    }
    # view
    {
      name = "vscode-data-preview";
      publisher = "RandomFractalsInc";
      version = "1.40.0";
      sha256 = "01q5hard0ykf7zf02r1bi394q8f3sw9kb5va0g12gf53mq597qq4";
    }
    {
      name = "vscode-yaml";
      publisher = "redhat";
      version = "0.5.2";
      sha256 = "1c42nbnmiif2am76rrk7x1f0b0q48596h4whqdwy6b926y8rpy89";
    }

    # text
    {
      name = "asciidoctor-vscode";
      publisher = "joaompinto";
      version = "2.7.6";
      sha256 = "1mklszqcjn9sv6yv1kmbmswz5286mrbnhazs764f38l0kjnrx7qm";
    }
    {
      name = "latex-workshop"; 
      publisher = "James-Yu";
      version = "8.1.0";
      sha256 = "1hf2slx3pwa8zllh18lhnzni4z7w3ja50qybp9smprbjpvq43zdf";
    }
    {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "2.4.2";
      sha256 = "11rmrdzqbws92wi9xbnr9xjc1kzdglnqyzcf2nnksy2c5vg9ixz5";
    }
    {
      name = "org-mode";
      publisher = "vscode-org-mode";
      version = "1.0.0";
      sha256 = "1dp6mz1rb8awrrpig1j8y6nyln0186gkmrflfr8hahaqr668il53";
    }
  ];
}
