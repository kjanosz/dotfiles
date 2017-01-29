{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
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
    oh-my-zsh
    psmisc
    pwgen
    ranger
    strace
    vim
  ];
}
