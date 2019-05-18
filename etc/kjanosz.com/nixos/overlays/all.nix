{ ulib }:

self: super:

with ulib;

rec {
  # 2019-03-16T13:48:55+01:00
  unstable = nixpkgsOf {
    rev = "da1a2b1eeafa66b4419b4f275396d8a731eccb61";
    sha256 = "0pyifm3p93v96izdjzqwrxn5612ylfcnq8gmxi42ygiq52zs23xi";
  };

  kanboard = super.callPackage ./pkgs/kanboard { };

  kanboardPlugins = super.callPackage ./pkgs/kanboard/plugins.nix { };

  pg_prometheus = super.callPackage ./pkgs/pg_prometheus {
    postgresql = postgresql_11;
  };

  postgresql_11 = unstable.postgresql_11;

  prometheus-postgresql-adapter = super.callPackage ./pkgs/prometheus-postgresql-adapter { };

  timescaledb = unstable.timescaledb.overrideAttrs (oldAttrs: rec {
    name = "timescaledb-${version}";
    version = "1.2.0";
    buildInputs = [ postgresql_11 super.openssl ];
    patchPhase = ''
      ${oldAttrs.patchPhase}
      for x in src/CMakeLists.txt tsl/src/CMakeLists.txt; do
        substituteInPlace "$x" \
          --replace 'DESTINATION ''${PG_PKGLIBDIR}' "DESTINATION \"$out/lib\""
      done
    '';
    src = super.pkgs.fetchFromGitHub {
        owner  = "timescale";
        repo   = "timescaledb";
        rev    = "${version}";
        sha256 = "0md27yq7rdnwv1ws1m9fqjp9vfyqjylvblz6d47aa67a6jmjf489";
    };
  });
}
