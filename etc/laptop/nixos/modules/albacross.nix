{ config, lib, pkgs, ... }:

with lib;

{
  users.users.kjw = {
    extraGroups = [ "docker" "vboxusers" ];
    packages = with pkgs; [
      ansible
      awscli
      aws-vault
      docker_compose
      docker-machine
      nailgun
      nodejs
      slack
    ];
  };
}
