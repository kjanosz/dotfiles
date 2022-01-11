{ pkgs, ... }:

let
  extensions = [
    {
      name = "vscode-openapi";
      publisher = "42Crunch";
      version = "4.7.1";
      sha256 = "0mk3ma3ybrmg9a8j4zlhj8zsvlalfi1i06dj7rbcid7h9wz249g1";
    }
    {
      name = "project-manager";
      publisher = "alefragnani";
      version = "12.4.0";
      sha256 = "0q6zkz7pqz2prmr01h17h9a5q6cn6bjgcxggy69c84j8h2w905wy";
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
      version = "11.7.0";
      sha256 = "0apjjlfdwljqih394ggz2d8m599pyyjrb0b4cfcz83601b7hk3x6";
    }
    {
      name = "code-runner";
      publisher = "formulahendry";
      version = "0.11.6";
      sha256 = "1q1gdzjgvksmnwrd7ikg87b4wvddwkxdk577jrfwijcqqh7zspc8";
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
      version = "0.35.2021122309";
      sha256 = "0szrqmn1ardhx9xf1lvdl2fnkmmg89rq7dgcdigb54kdx2m0iv2x";
    }
    {
      name = "go";
      publisher = "golang";
      version = "0.30.0";
      sha256 = "15rmc79ad743hb6pmnzv91rkvl2fb1qwh5gk5q6n9f9vygiyjrix";
    }
    {
      name = "terraform";
      publisher = "hashicorp";
      version = "2.17.0";
      sha256 = "00c31ll9lc48lrlls26c35pwxjiz19hqj4mpvrqb0v92avb71691";
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
      version = "8.22.0";
      sha256 = "1j1qqwihzjlfs5w0nddd7msgi8r21jmgsyk2rg0abh9qi524f17f";
    }
    {
      name = "plantuml";
      publisher = "jebbs";
      version = "2.17.0";
      sha256 = "0mznh5rxpdnz25nyc90bq3zmgw9wcww2imhbz5bkzxp8bbghygdg";
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
      version = "1.5.8";
      sha256 = "0gqjwy5y3y096n53g0jiqkvijdqnwamv028l3lnvx4fbqngv0zyq";
    }
    {
      name = "beancount";
      publisher = "Lencerf";
      version = "0.8.0";
      sha256 = "10s4b2ipyvrs5bnmfhma8q12aiv14b1f4g38aaqwg958jynsbgg4";
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
      version = "1.18.0";
      sha256 = "0hhlhx3xy7x31xx2v3srvk67immajs6dm9h0wi49ii1rwx61zxah";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2021.12.1559732655";
      sha256 = "0ghwj1n57zgfqnlwdxy18ahkljixv6dd2810rzw6vfqvp1kxax45";
    }
    {
      name = "vscode-database-client2";
      publisher = "cweijan";
      version = "4.4.0";
      sha256 = "1961z7myc4iljc3alk34rjibzjyg8xki7lqagp9rkq0sfb6x83sr";
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
      version = "1.2.0";
      sha256 = "1m0iqc33gvigbh2xck0slv6l2xnl01d233afh0v2aragd0apfr32";
    }
    {
      name = "vscode-yaml";
      publisher = "redhat";
      version = "1.2.2";
      sha256 = "06n4fxqr3lqmiyns9jdk3rdnanamcpzhrivllai8z9d997xmwcx6";
    }
    {
      name = "rust-analyzer";
      publisher = "matklad";
      version = "0.3.879";
      sha256 = "1zsrzgj050vdjr1nfyn5z1r897x6ylcp7lgii00sj2zha565z9xd";
    }
    {
      name = "scala";
      publisher = "scala-lang";
      version = "0.5.5";
      sha256 = "1gqgamm97sq09za8iyb06jf7hpqa2mlkycbx6zpqwvlwd3a92qr1";
    }
    {
      name = "metals";
      publisher = "scalameta";
      version = "1.10.15";
      sha256 = "1yzvwdxipilxpg50sh1glm6p2mmn75pzq8kadk7cyl1kqlqd40ii";
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
      version = "0.37.0";
      sha256 = "00dpjp9badb09a9md92vqc7vmgqp066q67bhg29sqsdyk8qn40wx";
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
      name = "vscode-proto3";
      publisher = "zxh404";
      version = "0.5.5";
      sha256 = "08gjq2ww7pjr3ck9pyp5kdr0q6hxxjy3gg87aklplbc9bkfb0vqj";
    }
    {
      name = "vscode-graphql";
      publisher = "GraphQL";
      version = "0.3.50";
      sha256 = "1yf6v2vsgmq86ysb6vxzbg2gh6vz03fsz0d0rhpvpghayrjlk5az";
    }
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "1.0.7";
      sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
    }
    {
      name = "vscode-lldb";
      publisher = "vadimcn";
      version = "1.6.10";
      sha256 = "1q3d99l57spkln4cgwx28300d9711kc77mkyp4y968g3zyrmar88";
    }
    {
      name = "magic-racket";
      publisher = "evzen-wybitul";
      version = "0.6.1";
      sha256 = "1p476v3kgn92lnxvln3hizs5rar1hsdjd9ipiw46bxn2wfld5kmf";
    }
    {
      name = "magic-racket";
      publisher = "evzen-wybitul";
      version = "0.6.1";
      sha256 = "1p476v3kgn92lnxvln3hizs5rar1hsdjd9ipiw46bxn2wfld5kmf";
    }
    {
      name = "flutter";
      publisher = "Dart-Code";
      version = "3.31.20211214";
      sha256 = "0rvlj4d00rb1n9w7wqcd34j16m43rg64saxsfz1fnla52pjb3m29";
    }
    {
      name = "haskell";
      publisher = "haskell";
      version = "1.8.0";
      sha256 = "0yzcibigxlvh6ilba1jpri2irsjnvyy74vzn3rydcywfc17ifkzs";
    }
    {
      name = "Kotlin";
      publisher = "mathiasfrohlich";
      version = "1.7.1";
      sha256 = "0zi8s1y9l7sfgxfl26vqqqylsdsvn5v2xb3x8pcc4q0xlxgjbq1j";
    }
    {
      name = "kotlin-formatter";
      publisher = "cstef";
      version = "0.0.6";
      sha256 = "16glm0vyks57fv9jy19zac0shjn6fq5s0fd2118dfy17g5jhdp5w";
    }
  ];
in
pkgs.vscode-with-extensions.override {
  vscodeExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace extensions;
}
