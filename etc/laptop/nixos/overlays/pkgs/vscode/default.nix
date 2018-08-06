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
      version = "0.9.3";
      sha256 = "0sg1fb3cy3s711nn8vcdf1k2walciv0693hxd1vx2k6rrdmam39g";
    }
    {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "1.6.0";
      sha256 = "0mfnf210m9ksnf88rbrn8y3xm7n3lgphy7w8ysmzpdlkpj60f027";
    }
    {
      name = "open-in-browser";
      publisher = "techer";
      version = "1.1.0";
      sha256 = "0498f71892vg0j79bpipz2q0ns6rr6d7ijiff3kz2dqjy038xij9";
    }
    {
      name = "quicktype";
      publisher = "quicktype";
      version = "12.0.21";
      sha256 = "0xjxdwx2h5r22rfg9r55pjxkg5jcmr0khf1lxs6h9ry05fwrig99";
    }
    

    # vcs
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "8.5.4";
      sha256 = "1bsj2hdwxvanl07pfnfxp2dxfdyx820a6g2pr0n2z6ayhjdqy3r5";
    }
    {
      name = "git-project-manager";
      publisher = "felipecaputo";
      version = "1.6.1";
      sha256 = "0wam1k6hls2iaia92pcx5q7vv90g7nb35b8141spljdll1s2idyb";
    }
    {
      name = "vscode-github";
      publisher = "KnisterPeter";
      version = "0.30.0";
      sha256 = "1xcq1aszhl334yvg4mmslp55aqc7052djdbpvcspysjh70qyf7j0";
    }

    # bazel
    {
      name = "bazel-code";
      publisher = "DevonDCarew";
      version = "0.1.9";
      sha256 = "0lsb4vlqwqqlm0yzljhl8sl151j41lxlpj9wh82m90v59qibpkkf";
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
      version = "0.1.0";
      sha256 = "0gzwzfhk00f4fbycl79bx11d3gwyjy99hhg369rz9r2ij8ldzsph";
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
      version = "0.0.20";
      sha256 = "0xyml4kxp7y9iiy4ilmn8jiqnl1ywfq6qnd4q73rkpahlzqvnp9c";
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
      version = "0.29.0";
      sha256 = "01ykqs5a3xgnsm8kbjjg6svb90wzp2433zd4ay79nkbmslc64ray";
    }
    {
      name = "vscode-java-debug"; 
      publisher = "vscjava";
      version = "0.11.0";
      sha256 = "03yghl1kgd9ki792h73x9vfcbv8hclmlflm3i15aywwp3zw2nd3m";
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
      version = "0.19.0";
      sha256 = "1lhhsk1l5wba55q35npdzddpm7d0hjk5h3w4vg7j81mc4xlip8rn";
    }
    {
      name = "language-purescript"; 
      publisher = "nwolverson";
      version = "0.1.2";
      sha256 = "1a6l74b4qq7w9izw6fw4lm5ylaksp3svcpmblhacmkq00fd5bb4k";
    }
    # plantuml
    {
      name = "plantuml"; 
      publisher = "jebbs";
      version = "2.8.4";
      sha256 = "171lg6qmhqa6cdbk0v761xpnxvrw00ii2p248dln1lhvf6xmrma4";
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
      version = "2018.7.1";
      sha256 = "0db0f2gkwgc1zwp1jn7xr1jksgsq7j1vcv5125zgglvpr7k148jf";
    }
    # rust
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.4.9";
      sha256 = "1g10kzsm69c5a6s4bqkq242xbwr5jwpan45k539vqm6bncsm84zj";
    }
    # scala
    {
      name = "metals";
      publisher = "scalameta";
      version = "0.1.0";
      sha256 = "1gbq2ymhbkdhq1zwn7zy6vk0v1m0gdkgh91p6j9mgzrqn5rs64c6";
    }
    {
      name = "scala";
      publisher = "scala-lang";
      version = "0.1.2";
      sha256 = "1qsmnlf1vrj0hi6gfp4vfc78s1xgdcb1jrr5mdh3bl243mg72f6j";
    }
    {
      name = "vscode-sbt-scala";
      publisher = "lightbend";
      version = "0.2.2";
      sha256 = "03vdd9ijqcwdxpv3ifz916zjg8a8g55y931382rf205flqs9v52v";
    }
    # terraform
    {
      name = "terraform";
      publisher = "mauve";
      version = "1.3.4";
      sha256 = "1ws2m357r5s24vv2ypp1dqzi41a811s9j7y3fa1yknxzr6fwx69l";
    }
  ];
}
