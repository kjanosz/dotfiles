{ config, lib, utils, pkgs, pkgs_unstable, ... }:

{
  environment.systemPackages = with pkgs_unstable; [
    awscli
    docker_compose
    ngrok
    nailgun
    shfmt
    zoom-us
  ];
}
