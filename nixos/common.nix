{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "pl";
    defaultLocale = "en_DK.UTF-8";
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  users.defaultUserShell = pkgs.zsh;

  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [
    coreutils
    emacs
    git
    mkpasswd
  ];
}
