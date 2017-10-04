{ config, lib, pkgs, pkgs_unstable, ... }:

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
      base = "https://nixos.org/channels/nixos-17.09";

      additional = {
        "unstable" = {
          address = "https://nixos.org/channels/nixos-unstable";
        };
      };
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    useSandbox = true;
  };

  nixpkgs.config.allowUnfree = false;
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    inherit (pkgs_unstable) lnav oh-my-zsh;
  };
  
  environment.pathsToLink = [ "/share/oh-my-zsh" ];
  environment.systemPackages = with pkgs; [
    calc
    cloc
    coreutils
    duplicity
    file
    findutils
    git
    gptfdisk
    gnupg
    gnupg1compat
    gnutar
    htop
    jq
    lnav
    lsof
    ltrace
    mkpasswd
    nix-repl
    oh-my-zsh
    pciutils
    psmisc
    pwgen
    ranger
    strace
    unzip
    usbutils
    vim
    zip
  ];

  system.stateVersion = "17.09";
}
