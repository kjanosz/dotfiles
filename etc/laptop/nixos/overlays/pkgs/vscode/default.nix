{ pkgs, ... }:

with pkgs;

let
  extensions = [
    {
      name = "vscode-openapi";
      publisher = "42Crunch";
      version = "3.10.0";
      sha256 = "1skp3ybhbk4y45n0llrqcys362lsw43343b2krvwgr46canw7kky";
    }
    {
      name = "vscode-pull-request-github";
      publisher = "GitHub";
      version = "0.22.0";
      sha256 = "13p3z86vkra26npp5a78pxdwa4z6jqjzsd38arhgdnjgwmi6bnrw";
    }
    {
      name = "latex-workshop";
      publisher = "James-Yu";
      version = "8.15.0";
      sha256 = "0v4pq3l6g4dr1qvnmgsw148061lngwmk3zm12q0kggx85blki12d";
    }
    {
      name = "beancount";
      publisher = "Lencerf";
      version = "0.5.6";
      sha256 = "0ww3lpvj1ii7vy3vkz6sbxx6jf2niy434ql6ah427h0nmqp0wixn";
    }
    {
      name = "vscode-data-preview";
      publisher = "RandomFractalsInc";
      version = "2.2.0";
      sha256 = "1vjrncyyhqcqyi4c52w81iy2ayx3q4ssx5kyk2xhw7c1dqxxgiwf";
    }
    {
      name = "vscode-hie-server";
      publisher = "alanz";
      version = "0.2.1";
      sha256 = "1ql3ynar7fm1dhsf6kb44bw5d9pi1d8p9fmjv5p96iz8x7n3w47x";
    }
    {
      name = "project-manager";
      publisher = "alefragnani";
      version = "12.0.1";
      sha256 = "1bckjq1dw2mwr1zxx3dxs4b2arvnxcr32af2gxlkh4s26hvp9n1v";
    }
    {
      name = "vscode-tlaplus";
      publisher = "alygin";
      version = "1.5.2";
      sha256 = "183fd7j9zncyn8lrq25wwx2pcvdimj0vphisx6d3pzj1hrdxlk21";
    }
    {
      name = "Nix";
      publisher = "bbenoist";
      version = "1.0.1";
      sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    }
    {
      name = "vagrant";
      publisher = "bbenoist";
      version = "0.5.0";
      sha256 = "1fkrv6ncw752n5ni7c3p9hd7l9f2msw7rgxw07x2wigp3zd5y06x";
    }
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "11.1.3";
      sha256 = "1x9bkf9mb56l84n36g3jmp3hyfbyi8vkm2d4wbabavgq6gg618l6";
    }
    {
      name = "code-runner";
      publisher = "formulahendry";
      version = "0.11.2";
      sha256 = "0qwcxr6m1xwhqmdl4pccjgpikpq1hgi2hgrva5abn8ixa2510hcy";
    }
    {
      name = "auto-run-command";
      publisher = "gabrielgrinberg";
      version = "1.6.0";
      sha256 = "0zp5xq24f2yc7j7ir0qhmfimc48dkma1kq7cyyq22ydy42y45hn6";
    }
    {
      name = "go";
      publisher = "golang";
      version = "0.20.1";
      sha256 = "0hhxgkv7p2hbjqj9q9xdlkcnva6b2lcszcpxj7fy4wfqz1w9lcaj";
    }
    {
      name = "terraform";
      publisher = "hashicorp";
      version = "2.3.0";
      sha256 = "0696q8nr6kb5q08295zvbqwj7lr98z18gz1chf0adgrh476zm6qq";
    }
    {
      name = "open-in-browser";
      publisher = "igordvlpr";
      version = "1.0.2";
      sha256 = "1174rify25haa7mgr5dj8zkdpnvrp0kmwp91nmwxhgcfrisdls7a";
    }
    {
      name = "plantuml";
      publisher = "jebbs";
      version = "2.14.1";
      sha256 = "0phwv3iapzx4xwx0l6axwnhmph969gwn5lfa02a8yd5lj92sak7j";
    }
    {
      name = "asciidoctor-vscode";
      publisher = "joaompinto";
      version = "2.8.0";
      sha256 = "06nx627fik3c3x4gsq01rj0v59ckd4byvxffwmmigy3q2ljzsp0x";
    }
    {
      name = "language-julia";
      publisher = "julialang";
      version = "1.0.10";
      sha256 = "04mc4z5x72v8g25b60zjxn3wpjhbp9s6wa50bvx5cdbrvcfg5ngs";
    }
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.3.0";
      sha256 = "1285bs89d7hqn8h8jyxww7712070zw2ccrgy6aswd39arscniffs";
    }
    {
      name = "vscoq";
      publisher = "maximedenes";
      version = "0.3.2";
      sha256 = "1k55azavxhb2jxhk06f2rgkvf66bm1kwnmvyrjxp00xq3dai39bb";
    }
    {
      name = "vscode-docker";
      publisher = "ms-azuretools";
      version = "1.9.0";
      sha256 = "10xih3djdbxvndlz8s98rf635asjx8hmdza49y67v624i59jdn3x";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2020.12.424452561";
      sha256 = "0zd0wdaip4nd9awr0h0m5afarzwhkfd8n9hzdahwf43sh15lqblf";
    }
    {
      name = "sqltools";
      publisher = "mtxr";
      version = "0.23.0";
      sha256 = "0gkm1m7jss25y2p2h6acm8awbchyrsqfhmbg70jaafr1dfxkzfir";
    }
    {
      name = "ide-purescript";
      publisher = "nwolverson";
      version = "0.23.3";
      sha256 = "1qg7qvkirp2hmf6agplprw0hxl3zg0z83fw04agdmgy8dmpmn0ih";
    }
    {
      name = "language-purescript";
      publisher = "nwolverson";
      version = "0.2.4";
      sha256 = "16c6ik09wj87r0dg4l0swl2qlqy48jkavpp5i90l166x2mjw2b7w";
    }
    {
      name = "quicktype";
      publisher = "quicktype";
      version = "12.0.46";
      sha256 = "0mzn1favvrzqcigr74gmy167qak5saskhwcvhf7f00z7x0378dim";
    }
    {
      name = "java";
      publisher = "redhat";
      version = "0.73.0";
      sha256 = "0hs45133kwpq8c2bp1gwpggf2xnbnkxrmswbivpk4x9fml8yw9rg";
    }
    {
      name = "vscode-yaml";
      publisher = "redhat";
      version = "0.13.0";
      sha256 = "046kdk73a5xbrwq16ff0l64271c6q6ygjvxaph58z29gyiszfkig";
    }
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.7.8";
      sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
    }
    {
      name = "scala";
      publisher = "scala-lang";
      version = "0.5.0";
      sha256 = "0rhdnj8vfpcvy771l6nhh4zxyqspyh84n9p1xp45kq6msw22d7rx";
    }
    {
      name = "metals";
      publisher = "scalameta";
      version = "1.9.10";
      sha256 = "1afmqzlw3bl9bv59l9b2jrljhbq8djb7vl8rjv58c5wi7nvm2qab";
    }
    {
      name = "vscode-scheme";
      publisher = "sjhuangx";
      version = "0.4.0";
      sha256 = "07vjfymvfv98s5r5a4b5iqhgfz1wpgq2l8h3wlq1bnhhhvmq5pq4";
    }
    {
      name = "vscode-java-debug";
      publisher = "vscjava";
      version = "0.30.0";
      sha256 = "0dawszx8bclvn6qg9vagxhjfh8d2h9paas6775m6p182flq7ap38";
    }
    {
      name = "org-mode";
      publisher = "vscode-org-mode";
      version = "1.0.0";
      sha256 = "1dp6mz1rb8awrrpig1j8y6nyln0186gkmrflfr8hahaqr668il53";
    }
    {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "3.4.0";
      sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
    }
    {
      name = "Idris";
      publisher = "zjhmale";
      version = "0.9.8";
      sha256 = "1dfh1rgybhnf5driwgxh69a1inyzxl72njhq93qq7mhacwnyfsdp";
    }
    {
      name = "vscode-proto3";
      publisher = "zxh404";
      version = "0.5.3";
      sha256 = "1piih7q2fp81hh356h10xi0v0xvicc9698yp9hj7c08xws3s4i51";
    }
  ];
in
vscode-with-extensions.override {
  vscodeExtensions = vscode-utils.extensionsFromVscodeMarketplace extensions;
}
