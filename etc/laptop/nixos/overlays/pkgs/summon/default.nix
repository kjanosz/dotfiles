{ lib, fetchFromGitHub, buildGoPackage, makeWrapper, ... }:

with lib;

rec {
  generic = buildGoPackage rec {
    name = "summon-${version}";
    version = "0.6.8";
    goPackagePath = "github.com/cyberark/summon";

    src = fetchFromGitHub {
      owner = "cyberark";
      repo = "summon";
      rev = "v${version}";
      sha256 = "09nm8qs72ix0pfg4f8y8ajn4k80hg87v38w3hxpk02lqpwvxzib0";
    };
  };

  withPlugins = { providers }: generic.overrideAttrs (oldAttrs: rec {
    buildInputs = [ makeWrapper ] ++ providers;

    patches = [ ./custom-provider-dir.patch ];

    postInstall = ''
      mkdir -p $bin/lib/summon
      ${concatMapStringsSep "\n" (p: "cp --symbolic-link " + p + "/bin/* $bin/lib/summon") providers}
      wrapProgram $bin/bin/summon --set SUMMON_PROVIDER_DIR "$bin/lib/summon"
    '';
  });
}
