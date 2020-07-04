{ pkgs, ... }:

with pkgs;

let
  extensions = [
    {
      name = "vscode-openapi";
      publisher = "42Crunch";
      version = "3.3.0";
      sha256 = "0kaa4mjps2yv0pmpsi49xz9vwmxlhggj6n3ihf3ns7x8wkkrmqd5";
    }
    {
      name = "vscode-pull-request-github";
      publisher = "GitHub";
      version = "0.17.0";
      sha256 = "1ga1fs3kihy70sgz2nfzdmq7162p7vav2g1p0kmbas5vszs12g0a";
    }
    {
      name = "latex-workshop";
      publisher = "James-Yu";
      version = "8.10.0";
      sha256 = "0kcrxykvv21ra1xwws6s2clxfnjngpais1ddlimmmcia0y426dxg";
    }
    {
      name = "vscode-data-preview";
      publisher = "RandomFractalsInc";
      version = "2.0.0";
      sha256 = "0k8i1wx182fn0lcsn758f3w0b10radssndhgg4jqbasff5grfc27";
    }
    {
      name = "vscode-hie-server";
      publisher = "alanz";
      version = "0.0.40";
      sha256 = "1cmlgidjma41s5zq5161gcxxmk5lfzcm8dvznls04y5l7q9b0gca";
    }
    {
      name = "project-manager";
      publisher = "alefragnani";
      version = "11.0.1";
      sha256 = "1gajm70dc8qic5kz28mgddcv7bg3647sa10yycfbyzrbl6jkxbj5";
    }
    {
      name = "vscode-tlaplus";
      publisher = "alygin";
      version = "1.5.0";
      sha256 = "1nndqwa16y7a1mhg0n6vg9ikj4pzc9jvswhd158xms61a2q3kh88";
    }
    {
      name = "Nix";
      publisher = "bbenoist";
      version = "1.0.1";
      sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    }
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "10.2.2";
      sha256 = "00fp6pz9jqcr6j6zwr2wpvqazh1ssa48jnk1282gnj5k560vh8mb";
    }
    {
      name = "code-runner";
      publisher = "formulahendry";
      version = "0.10.0";
      sha256 = "0r8vv1whvn7y05pbfp2hpvjx44bzrdz2kwjm76al9354pc0wdgry";
    }
    {
      name = "auto-run-command";
      publisher = "gabrielgrinberg";
      version = "1.6.0";
      sha256 = "0zp5xq24f2yc7j7ir0qhmfimc48dkma1kq7cyyq22ydy42y45hn6";
    }
    {
      name = "Go";
      publisher = "golang";
      version = "0.14.4";
      sha256 = "1rid3vxm4j64kixlm65jibwgm4gimi9mry04lrgv0pa96q5ya4pi";
    }
    {
      name = "terraform";
      publisher = "hashicorp";
      version = "2.0.1";
      sha256 = "1jjay81pxzwcc2yxcnlpa8yp5iv9aq6735p058mpf51dpsgng4hd";
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
      version = "2.13.12";
      sha256 = "1qy5vvg1vn75ffznyc704ldz43qry4jq6zdlw7ryp3inyk65ic6c";
    }
    {
      name = "asciidoctor-vscode";
      publisher = "joaompinto";
      version = "2.7.15";
      sha256 = "0qzc8d76dfkzf6q4gm4as8pgf5ijq0x2hbz9igfi28ndhi7mg3z7";
    }
    {
      name = "language-julia";
      publisher = "julialang";
      version = "0.16.7";
      sha256 = "1hz76varcilc7xf7zqz3rwkh7pdl8rpbwjc74dssqa6vcabii2jh";
    }
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.2.1";
      sha256 = "0lxp8xz17ciy93nj4lzxqvz71vw1zdyamrnh2n792yair8890rr6";
    }
    {
      name = "vscoq";
      publisher = "maximedenes";
      version = "0.3.1";
      sha256 = "1wjkb1kac7x28zjxg809dsb54xhqk2r5iqmfjczrw8h1iskjvn69";
    }
    {
      name = "vscode-docker";
      publisher = "ms-azuretools";
      version = "1.3.1";
      sha256 = "17q4727ah129hxdvrw1x0fcki7hidphmlnznxx7xvylcw937h6ch";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2020.6.88468";
      sha256 = "1hiaxqzprswvqx864wjy286g0d6nbgj1pjyrcclplkysvhbrahmv";
    }
    {
      name = "sqltools";
      publisher = "mtxr";
      version = "0.22.7";
      sha256 = "0xlfbiir88gnghz07i99gq8hhvzrdicwbgrjdibbm9dhrkrmbvn5";
    }
    {
      name = "ide-purescript";
      publisher = "nwolverson";
      version = "0.20.15";
      sha256 = "0m2dxhqw1slcw051vdknwpkpadlpnfarhrxn1rfxwqdx0yxadfil";
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
      version = "0.63.0";
      sha256 = "0zwgfriahjriifv4jkrnn4p9zxamkvid97yvrckp495rh31j4nnq";
    }
    {
      name = "vscode-yaml";
      publisher = "redhat";
      version = "0.8.0";
      sha256 = "08dy5wm24c3bga698925pjwbymdmxi00a84d6xajj750pax7grz0";
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
      version = "0.3.9";
      sha256 = "0l6zrpp2klqdym977zygmbzf0478lbqmivcxa2xmqyi34c9vwli7";
    }
    {
      name = "metals";
      publisher = "scalameta";
      version = "1.9.0";
      sha256 = "0p2wbnw98zmjbfiz4mi1mh131s78r01kjnja339lwdigqxg88gi6";
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
      version = "0.26.0";
      sha256 = "1vymb8ivnv05jarjm2l03s9wsqmakgsrlvf3s3d43jd3ydpi2jfy";
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
      version = "3.0.0";
      sha256 = "0n2j2wf25az8f1psss8p9wkkbk3s630pw24qv54fv97sgxisn5r3";
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
      version = "0.4.2";
      sha256 = "05da62iahnnjxkgdav14c1gn90lkgyk9gc5rardsqijx2x6dgjn0";
    }
  ];
in
vscode-with-extensions.override {
  vscodeExtensions = vscode-utils.extensionsFromVscodeMarketplace extensions;
}
