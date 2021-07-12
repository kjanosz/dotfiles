{ pkgs, ... }:

with pkgs;

let
  extensions = [
    {
      name = "vscode-openapi";
      publisher = "42Crunch";
      version = "4.5.2";
      sha256 = "0l0678y6rrcd0syvn8yh5rijpz0mm8p4cm3xgr7v9czx9f4bqkrc";
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
      version = "12.2.0";
      sha256 = "0wc6av3y6j0lk2zlcir8b1xcj2yhav011224kav9jg9dpvyw3s7b";
    }
    {
      name = "vscode-tlaplus";
      publisher = "alygin";
      version = "1.5.4";
      sha256 = "0mf98244z6wzb0vj6qdm3idgr2sr5086x7ss2khaxlrziif395dx";
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
      version = "11.5.1";
      sha256 = "0wy23fnd21jfqw88cyspzf09yvz2bpnlxniz4bc61n4pqm7xxki1";
    }
    {
      name = "code-runner";
      publisher = "formulahendry";
      version = "0.11.4";
      sha256 = "0igxrdmd1jpyx7r2p7nss367pghk7hq46m0yr7whiviq42nzw5g6";
    }
    {
      name = "auto-run-command";
      publisher = "gabrielgrinberg";
      version = "1.6.0";
      sha256 = "0zp5xq24f2yc7j7ir0qhmfimc48dkma1kq7cyyq22ydy42y45hn6";
    }
    {
      name = "vscode-pull-request-github";
      publisher = "GitHub";
      version = "0.27.1";
      sha256 = "1y89yz7k2i81006p6pkwmhqhmxpdp83pwpajrnfcisadd91l4nfv";
    }
    {
      name = "go";
      publisher = "golang";
      version = "0.26.0";
      sha256 = "1lhpzz68vsxkxwp12rgwiqwm1rmlwn6anmz6z4alr100hxxx31h7";
    }
    {
      name = "terraform";
      publisher = "hashicorp";
      version = "2.13.0";
      sha256 = "1wc4jl4h3ja4ivynf20yxzwqssi6yd7alvqvcjrkksic98480qcz";
    }
    {
      name = "open-in-browser";
      publisher = "igordvlpr";
      version = "1.0.2";
      sha256 = "1174rify25haa7mgr5dj8zkdpnvrp0kmwp91nmwxhgcfrisdls7a";
    }
    {
      name = "latex-workshop";
      publisher = "James-Yu";
      version = "8.19.2";
      sha256 = "17jmwvj36pf207bv8nyi70vi5snskfnk7rbfcan79zl92g29id5z";
    }
    {
      name = "plantuml";
      publisher = "jebbs";
      version = "2.15.1";
      sha256 = "030rrzadp39byjh792r0wz4mms622plsf9amkics843nf09zzgkv";
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
      version = "1.2.5";
      sha256 = "0fjh0dygpi779c67ly2v3saijr4h99rjdbcbif5xgpwa1301l0zv";
    }
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.4.0";
      sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
    }
    {
      name = "beancount";
      publisher = "Lencerf";
      version = "0.7.0";
      sha256 = "06dck6yc9sfka97nricdyrp2vccmfk4c7gcj8jhw02ylcshfss8r";
    }
    {
      name = "vscoq";
      publisher = "maximedenes";
      version = "0.3.5";
      sha256 = "05w4d4cr40xsr0pkry1cg3p5q2ji3dqld0p560grhrjlq27clj4r";
    }
    {
      name = "vscode-docker";
      publisher = "ms-azuretools";
      version = "1.14.0";
      sha256 = "0wc0k3hf9yfjcx7cw9vm528v5f4bk968bgc98h8fwmlx14vhapzp";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2021.6.944021595";
      sha256 = "17p1j0xd0crqv4wbs9qapvv4i8j9j446cbjqihpk9z6ryriim5ip";
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
      version = "0.25.0";
      sha256 = "079mswv7s1rvqs0n5dz31x5w135nl7iph1fwxqsc493x77df2s0f";
    }
    {
      name = "language-purescript";
      publisher = "nwolverson";
      version = "0.2.5";
      sha256 = "1ggrpqaa8826rpwflj5cxj0g9r7qnihkcj1z2gg2rsisrhc2k3zf";
    }
    {
      name = "quicktype";
      publisher = "quicktype";
      version = "12.0.46";
      sha256 = "0mzn1favvrzqcigr74gmy167qak5saskhwcvhf7f00z7x0378dim";
    }
    {
      name = "vscode-data-preview";
      publisher = "RandomFractalsInc";
      version = "2.3.0";
      sha256 = "1zasffg86c295qmw68516qm0sgsc3p99yz132xa9kcklvclw1ac4";
    }
    {
      name = "java";
      publisher = "redhat";
      version = "0.80.0";
      sha256 = "0gyp0sw6n6qbhww9liwv153cp9cy717hl1vr7z6zy5mbaanmyyrb";
    }
    {
      name = "vscode-yaml";
      publisher = "redhat";
      version = "0.20.0";
      sha256 = "14dzr1b0dfc4iv0cc45ix3f21xhah8x15zas6mdg6qjp0labmh4c";
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
      version = "0.5.3";
      sha256 = "0isw8jh845hj2fw7my1i19b710v3m5qsjy2faydb529ssdqv463p";
    }
    {
      name = "metals";
      publisher = "scalameta";
      version = "1.10.6";
      sha256 = "11ihg8d94hfg731r280wj9nvymgd2plaw01my1mfibjxlaf1h2i3";
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
      version = "0.34.0";
      sha256 = "0yjm39r5f8b0d1gb4xswk82wf05dryqq0dssa20j4klm9yhygz14";
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
      version = "0.5.4";
      sha256 = "08dfl5h1k6s542qw5qx2czm1wb37ck9w2vpjz44kp2az352nmksb";
    }
  ];
in
vscode-with-extensions.override {
  vscodeExtensions = vscode-utils.extensionsFromVscodeMarketplace extensions;
}
