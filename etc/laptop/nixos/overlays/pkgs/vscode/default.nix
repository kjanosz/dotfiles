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
      version = "0.9.15";
      sha256 = "1yc8zcfns26rv90k9y7pkcahyf0badpimsh1s3ky490jp4y0vcad";
    }
    {
      name = "project-manager";
      publisher = "alefragnani";
      version = "10.9.1";
      sha256 = "1wm47cvzb042kqmaidwgpvwlpsm73xy9pwm7dk99wc8pvl0x47sb";
    }
    {
      name = "open-in-browser";
      publisher = "igordvlpr";
      version = "1.0.2";
      sha256 = "1174rify25haa7mgr5dj8zkdpnvrp0kmwp91nmwxhgcfrisdls7a";
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
      version = "10.2.0";
      sha256 = "0qnq9lr4m0j0syaciyv0zbj8rwm45pshpkagpfbf4pqkscsf80nr";
    }
    {
      name = "vscode-pull-request-github";
      publisher = "GitHub";
      version = "0.14.0";
      sha256 = "00x2nls2nmz9qc8hyp4nfgw300snr7l2dx5mc7y9ll11429iba6j";
    }

    # coq
    {
      name = "vscoq";
      publisher = "maximedenes";
      version = "0.3.0";
      sha256 = "0ijczlf8mzhpqd3fg951nx53isv9xffix1id43waxmy9djy23rf9";
    }
    # database
    {
      name = "sqltools";
      publisher = "mtxr";
      version = "0.21.6";
      sha256 = "0iyxmj29p6ymnvjwraxxh883gm3asn25azbg1v6dqam700bjlgr2";
    }
    # docker
    {
      name = "vscode-docker";
      publisher = "ms-azuretools";
      version = "0.9.0";
      sha256 = "0wka4sgq5xjgqq2dc3zimrdcbl9166lavscz7zm6v4n6f9s2pfj0";
    }
    # go
    {
      name = "Go";
      publisher = "ms-vscode";
      version = "0.12.0";
      sha256 = "10gib1id3g7w2lg5zrvf77lczw7bm5878gns54b1ck2hajninbgv";
    }
    # haskell
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "2.7.0";
      sha256 = "1z6nxbg1a0yvbdicib3kxl04hrxwxi3p1hmc0qfahqkf6xwcmlc5";
    }
    {
      name = "vscode-hie-server";
      publisher = "alanz";
      version = "0.0.34";
      sha256 = "0cipm36l3219r1yhk4j7l02mc2c0chfnv7wl44n1h0966jp1sda3";
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
      version = "0.55.1";
      sha256 = "1vj6brvh4y0cc9dca100xzawgmy1v127yy24wfxk8fm58a00ysv9";
    }
    {
      name = "vscode-java-debug"; 
      publisher = "vscjava";
      version = "0.24.0";
      sha256 = "0azm9q0adrdhzansz0aywcrnd40jinsvz9yj0n8mmr15nbqx2kbd";
    }
    # julia
    {
      name = "language-julia"; 
      publisher = "julialang";
      version = "0.13.1";
      sha256 = "1aix7sx17nschfp3h7n0np6n3rs56q64s8gy4p54pndlqc1c45lf";
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
      version = "2.1.0";
      sha256 = "1swrxgsv44y6bk56kg6jnnxh64qnx802wgwhz6z7zf7plhl9v21q";
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
      version = "0.2.2";
      sha256 = "0jid62n1swf8ldq096722jxy6p7b0jhaf7qjbbbiqh67yqr3cprz";
    }
    # plantuml
    {
      name = "plantuml"; 
      publisher = "jebbs";
      version = "2.13.6";
      sha256 = "1kf13spsyr1x9shzr9mskx1bxfj7n5qbh80ijcyig34xnlas3nhy";
    }
    # python
    {
      name = "python"; 
      publisher = "ms-python";
      version = "2020.1.58038";
      sha256 = "09iawy1p2akan090461137d4p5gqqf0aanm9i534p0kmbxmjfpqv";
    }
    # rust
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.7.0";
      sha256 = "16n787agjjfa68r6xv0lyqvx25nfwqw7bqbxf8x8mbb61qhbkws0";
    }
    # scala
    {
      name = "scala";
      publisher = "scala-lang";
      version = "0.3.8";
      sha256 = "17dl10m3ayf57sqgil4mr9fjdm7i8gb5clrs227b768pp2d39ll9";
    }
    {
      name = "metals";
      publisher = "scalameta";
      version = "1.7.2";
      sha256 = "0d4a1648g7ziqgz0mj2n2gd0vzhgmd3nbwfsmfxn9l50zwxgvz6p";
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
      version = "1.3.2";
      sha256 = "0maa893q80a18vgxc3wpq19wmzc369874mq7pchwahscbmx9cv7m";
    }
    # view
    {
      name = "vscode-data-preview";
      publisher = "RandomFractalsInc";
      version = "1.49.0";
      sha256 = "0kc7c53vypsnba6ikmxzy7y58zrha9bfyky1vkbz0nn3zp9yi48x";
    }
    {
      name = "vscode-yaml";
      publisher = "redhat";
      version = "0.6.1";
      sha256 = "039f3jxqhlvxl56hg94awz6mwf2c4mqzgb5xrix5p0ac66jfaabm";
    }

    # text
    {
      name = "asciidoctor-vscode";
      publisher = "joaompinto";
      version = "2.7.8";
      sha256 = "0j1m8s3czpd16ybsfm4gf9xymyip02jin9y6ksrpddgvr5kr17ch";
    }
    {
      name = "latex-workshop"; 
      publisher = "James-Yu";
      version = "8.6.0";
      sha256 = "1zalfb86xlfk1prh2m9550q0g07h0hm4dxhim3qhsn1ncp93wk2q";
    }
    {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "2.7.0";
      sha256 = "1hrxw4ilm2r48kd442j2i7ar43w463612bx569pdhz80mapr1z9k";
    }
    {
      name = "org-mode";
      publisher = "vscode-org-mode";
      version = "1.0.0";
      sha256 = "1dp6mz1rb8awrrpig1j8y6nyln0186gkmrflfr8hahaqr668il53";
    }
  ];
}
