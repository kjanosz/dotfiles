{ config, lib, pkgs, ... }:

with lib;

{
  users.users.kjw = {
    extraGroups = [ "docker" "vboxusers" ];
    packages = with pkgs; [
      awscli
      aws-vault
      blessclient
      chamber
      cookiecutter
      docker_compose
      docker-machine
      elmPackages.elm-make	
      nailgun
      nodejs
      pre-commit
      shfmt
      slack
      terraform_0_11
      travis
      yarn
      zoom-us
    ];
  };
}
