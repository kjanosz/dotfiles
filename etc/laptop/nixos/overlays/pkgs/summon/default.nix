{ lib, buildGoModule, fetchFromGitHub, makeWrapper, providers ? [], ... }:

with lib;

buildGoModule rec {
  name = "summon-${version}";
  version = "0.8.0";

  modSha256 = "0r8rassxr1cv8hsrqpfcw3arjxzq8qg3a1lchdkawhw4sady8vc6"; 

  buildInputs = [ makeWrapper ];

  patches = [ ./custom-provider-dir.patch ];

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon";
    rev = "v${version}";
    sha256 = "1d3y2wkrkkj08nv8wsxda8jjk1p70mcjabj645mfqcwm2rz3r6mj";
  };

  postInstall = ''
    mv $out/bin/cmd $out/bin/summon
    wrapProgram $out/bin/summon --set SUMMON_PROVIDERS_DIR "/run/current-system/sw/lib/summon"
  '';
}
