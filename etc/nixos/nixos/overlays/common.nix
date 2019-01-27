self: super:

with super.lib;

foldlExtensions [  
  (self: super: rec {
    pg_prometheus = super.callPackage pkgs/pg_prometheus { };

    prometheus-postgresql-adapter = super.callPackage pkgs/prometheus-postgresql-adapter { };
  })
] self super