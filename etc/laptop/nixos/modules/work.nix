{ config, lib, pkgs, ... }:

with lib;

{
  users.users.kjw = {
    extraGroups = [ "docker" "vboxusers" ];
    packages = with pkgs; with albacross; [
      ansible
      awscli
      aws-vault
      chamber
      clojure
      docker_compose
      leiningen
      mysql57
      nailgun
      nodejs
      packer
      slack
      summon-aws-secrets
      terraform
    ];
  };
}

