{ config, lib, pkgs, ... }:

with pkgs;
with lib;

{
  config = {
    services.postfix = {
      enable = true;
      config = {
        inet_interfaces = "loopback-only";
        mydestination = "$myhostname, localhost.$mydomain, $mydomain";
      };
    };
  };
}
