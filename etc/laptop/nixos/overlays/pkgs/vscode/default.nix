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
      version = "0.9.6";
      sha256 = "0waqzr5bzmi7nddvxb9azg6lr1vixq2qxk89lk8vkw81vz4lksdr";
    }
    {
      name = "project-manager";
      publisher = "alefragnani";
      version = "10.3.0";
      sha256 = "09n98dq1lqpai7f4blgy7klix3i0qygwy281nw49qhn8qkyashp3";
    }
    {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "2.0.1";
      sha256 = "1kpjwn4ms9i52qphj8iqq3wc4b5ifasl7yvz4518mh6yd8vl7611";
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
      version = "9.4.1";
      sha256 = "15a39p8wj84hypz0m25chrnqz3zyg4wjnx9z1vv3qqpppybqy2w8";
    }
    {
      name = "vscode-pull-request-github";
      publisher = "GitHub";
      version = "0.3.2";
      sha256 = "0j2yzgxwww49q6l3ava72cpz2swh32msgs8gc9ww3sajm17gz808";
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
      version = "0.5.1";
      sha256 = "10ja2addwp7rhf6cbz8s24pdap6hm8p43rdl2fnvwn56lln90fwj";
    }
    # go
    {
      name = "Go";
      publisher = "ms-vscode";
      version = "0.8.0";
      sha256 = "0q7hf2b0zwn39kc11qny8vaqanvdci3m87nxqafdifm7rjmg4mjf";
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
      version = "0.37.0";
      sha256 = "05i3cdjaqfpnmh6bhan56hmkxymmyr9dymzq8f43b11xha4dpycd";
    }
    {
      name = "vscode-java-debug"; 
      publisher = "vscjava";
      version = "0.16.0";
      sha256 = "0mgkwkcw31lk6arvs7az9jak9vs6mwdz9vkw9f2rdj0fck4mlryz";
    }
    # julia
    {
      name = "language-julia"; 
      publisher = "julialang";
      version = "0.11.4";
      sha256 = "1xjgz0dhfbdy86kbq918869w976w34cwsid39sha5hmcx974sf1c";
    }
    # jupyter
    {
      name = "neuron-IPE"; 
      publisher = "neuron";
      version = "1.0.4";
      sha256 = "1237jg6jbbw8s2xrf151jbhfda25v9bz929hry282796hb1hck85";
    }
    # latex
    {
      name = "latex-workshop"; 
      publisher = "James-Yu";
      version = "5.21.0";
      sha256 = "15apm60c2p4r9w3b1zp2p9z8znzh63gyg4i4wwq8mpislcvasb75";
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
      version = "0.20.7";
      sha256 = "0gr1rm6snsr5yaw1ywgh84h12ib6fzzwnidqs5jkwlfm450hy64a";
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
      version = "2.10.2";
      sha256 = "1598ak1iq0156rmjgmg6cn69pcqvsri0cqmlapjl560sz6wk7siq";
    }
    # python
    {
      name = "python"; 
      publisher = "ms-python";
      version = "2018.12.1";
      sha256 = "1cf3yll2hfililcwq6avscgi35caccv8m8fdsvzqdfrggn5h41h4";
    }
    # rust
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.5.3";
      sha256 = "0nkf6cg1hmmsrvryjs5r0pdwsilfmrmy44wz47jjygyy62ixcad9";
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
      version = "1.2.0";
      sha256 = "12inhy8svqrdii992lfc4y5fn305ix0jxfrh2ni9rxpcf0i24qi3";
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
