{ config, pkgs, ... }:

let
  nixpkgs-unstable = import <nixpkgs-unstable> { };
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ./modules/channels.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
  };
    
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "pl";
    defaultLocale = "en_DK.UTF-8";
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  services.logind.extraConfig = ''
    KillUserProcesses=yes
  '';

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
  };

  nix = {
    channels = {
      "nixpkgs" = {
        address = "https://nixos.org/channels/nixos-16.09";
        name = "nixos";
      };

      "nixpkgs-unstable" = {
        address = "https://nixos.org/channels/nixos-unstable";
        name = "nixos-unstable";
      };
    };
    useSandbox = true;
  };

  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    inherit (nixpkgs-unstable) oh-my-zsh;
  };
  
  environment.pathsToLink = [ "/share/oh-my-zsh" ];
  environment.systemPackages = with pkgs; [
    calc
    cloc
    coreutils
    file
    findutils
    git
    gnupg
    gnupg1compat
    htop
    jq
    lsof
    ltrace
    mkpasswd
    nix-repl
    nox
    oh-my-zsh
    psmisc
    pwgen
    ranger
    strace
    vim
  ];
}
