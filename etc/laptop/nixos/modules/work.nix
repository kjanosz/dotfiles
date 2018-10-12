{ config, lib, pkgs, ... }:

with lib;

{
  users.users.kjw = {
    extraGroups = [ "docker" "vboxusers" ];
    packages = with pkgs; with albacross; [
      ansible
      awscli
      aws-vault
      docker_compose
      clojure
      leiningen
      mysql57
      nailgun
      nodejs
      packer
      slack
      terraform
    ];
  };
}

