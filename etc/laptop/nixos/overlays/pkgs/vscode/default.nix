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
      version = "0.9.8";
      sha256 = "13w43480mpcvimlfxws0vxnq1r8wjaxfwxf8i7k1j3l7c562i83n";
    }
    {
      name = "project-manager";
      publisher = "alefragnani";
      version = "10.5.1";
      sha256 = "1k8l5pyacpld9r76fqynpdx0zkzylvb5lickvxlnql2zb70cxk05";
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
      version = "9.6.3";
      sha256 = "0psgvlf3945724l2lf3znr4xlmsk0zcrig48lap2bck43lr7xxfw";
    }
    {
      name = "vscode-pull-request-github";
      publisher = "GitHub";
      version = "0.6.0";
      sha256 = "05csvsbbc6g43c6zkyh36vzr9a47gk2vdyvi1kvz7vcfpnmp4459";
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
      version = "0.6.1";
      sha256 = "0clxy66qi5c3k5di5xsjm3vjib525xq89z1q2h3a5x5qwvbvd0mj";
    }
    # go
    {
      name = "Go";
      publisher = "ms-vscode";
      version = "0.10.2";
      sha256 = "030rgzilq0r6k4502lgrhm86bwfwnqkbq9hbz7v0dmhbn3mrrn3k";
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
      version = "0.0.27";
      sha256 = "1mz0h5zd295i73hbji9ivla8hx02i4yhqcv6l4r23w3f07ql3i8h";
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
      version = "0.43.0";
      sha256 = "1j3sk38hh9iga9cbdsripk93sxw06raklk0xzknxdd98lai963d0";
    }
    {
      name = "vscode-java-debug"; 
      publisher = "vscjava";
      version = "0.18.0";
      sha256 = "106r2w5k889q6m3glchvk4vy7vnllzsr10fzzwzbdqnv8cac12cr";
    }
    # julia
    {
      name = "language-julia"; 
      publisher = "julialang";
      version = "0.11.5";
      sha256 = "0sz1rz49p6bbgjsy9n7qqrvpw18j1ya5skihj09aw0bapk8pm2lw";
    }
    # jupyter
    {
      name = "neuron-IPE"; 
      publisher = "neuron";
      version = "1.0.4";
      sha256 = "1237jg6jbbw8s2xrf151jbhfda25v9bz929hry282796hb1hck85";
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
      version = "0.20.8";
      sha256 = "16avxmb1191l641r6pd99lw2cgq8gdfipb9n7d0czx1g9vfjr3ip";
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
      version = "2.10.9";
      sha256 = "01kvdr31h6v429jbcvkhszkdkywvcbj8rwlgnd40yc6h5d48zq5h";
    }
    # python
    {
      name = "python"; 
      publisher = "ms-python";
      version = "2019.4.12954";
      sha256 = "1i89jmff2mm6i5myriw0709nbhj3sasqzwvnw3dpqlnasg53mx2v";
    }
    # rust
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.6.1";
      sha256 = "0f66z6b374nvnrn7802dg0xz9f8wq6sjw3sb9ca533gn5jd7n297";
    }
    # scala
    {
      name = "scala";
      publisher = "scala-lang";
      version = "0.2.0";
      sha256 = "0z2knfgn1g5rvanssnz6ym8zqyzzk5naaqsggrv77k6jzd5lpw49";
    }
    {
      name = "metals";
      publisher = "scalameta";
      version = "1.3.2";
      sha256 = "1cl3ipgm4zj86rklbdnw94a5i1fbkyvprmx5a7lg96l3hlmrjxkn";
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
      version = "1.3.11";
      sha256 = "0di7psqcn7gmdl604cxra2xnc8rc6izandqz44qrgjl3j41vp8jr";
    }
    
    # text
    {
      name = "latex-workshop"; 
      publisher = "James-Yu";
      version = "6.5.1";
      sha256 = "01l6j0mlxkyni27qqk8kp6sh6v7ya983ynb3zqfbkjdq1g0fggfd";
    }
    {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "2.3.1";
      sha256 = "0dqq1kjwb95cn7g4vlr63vqvfmvad2flkg3av564x4iqxl00iyj4";
    }
    {
      name = "org-mode";
      publisher = "vscode-org-mode";
      version = "1.0.0";
      sha256 = "1dp6mz1rb8awrrpig1j8y6nyln0186gkmrflfr8hahaqr668il53";
    }
  ];
}
