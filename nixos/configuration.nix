{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix { inherit pkgs; };
in
{
  imports = [
    ./common.nix
  ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  boot.loader.grub.device = "/dev/sda";

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/d8a24a3f-ea68-4b98-a0a4-f6a7613fc5ab";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/01fdde08-aff0-409d-b657-1f7b5cacd318";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0c6ae963-31eb-4f90-9ca6-a9c8edfcb833";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/mapper/home"; 
    fsType = "ext4";

    encrypted = {
      enable = true;
      blkDev = "/dev/disk/by-uuid/cb5fedef-4b68-4dfa-bb00-e0980a453937";
      keyFile = "${secrets.homeKey}";
      label = "home";
    };  
  };

  swapDevices = [
    {
      device = "/var/swap";
      size = 12288;
    }
  ];

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    extraConfig = ''
      load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
    '';
  };

  nix.maxJobs = 4;
  nix.buildCores = 4;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  environment.systemPackages = with pkgs; [
    chromium
    firefox
    gnome-mpv
    gnupg
    idea.idea-community
    keepassx2
    pass
    terminator
    thunderbird
  ];

  services.pcscd.enable = true;

  services.xserver = {
    enable = true;
    layout = "pl";
    
    desktopManager = {
      gnome3.enable = true;
      default = "gnome3";
    };

    displayManager = {
      gdm.enable = true;
    };
  };

  environment.gnome3.excludePackages = [
    pkgs.epiphany
    pkgs.gnome3.evolution
    pkgs.gnome3.gnome-calendar
    pkgs.gnome3.totem
  ];

  services.mopidy = {
    enable = true;
    extensionPackages = [ pkgs.mopidy-mopify pkgs.mopidy-spotify ];
    configuration = ''
      [audio]
      output = pulsesink server=127.0.0.1

      [spotify]
      enabled = true
      username = kjanosz
      password = ${secrets.spotifyPassword}
      bitrate = 320
    '';
  };

  users.extraUsers.kj = {
    hashedPassword = "${secrets.kjPassword}";
    uid = 1000;
    isNormalUser = true;
    home = "/home/kjanosz";
    description = "Krzysztof Janosz";
    extraGroups = [ "wheel" "networkmanager" ]; 
  };

  users.extraUsers.kjw = {
    hashedPassword = "${secrets.kjwPassword}";
    uid = 10000;
    isNormalUser = true;
    home = "/home/kjanosz_work";
    description = "Krzysztof Janosz (Work)";
    extraGroups = [ "networkmanager" ];
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "16.09";
}
