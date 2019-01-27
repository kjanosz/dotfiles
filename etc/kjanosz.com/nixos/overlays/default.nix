self: super:

{
  kanboard = super.callPackage ./pkgs/kanboard { };

  kanboardPlugins = import ./pkgs/kanboard/plugins;

  prometheus-postgresql-adapter = super.callPackage ./pkgs/prometheus-postgresql-adapter { };
}