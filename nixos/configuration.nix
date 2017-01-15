{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix { inherit pkgs; };
in
{
  imports = [
    ./common.nix
    ./modules/foxcommerce.nix
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
    package = pkgs.pulseaudioFull;
    support32Bit = true;
    extraConfig = ''
      load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
    '';
  };

  nix.maxJobs = 4;
  nix.buildCores = 4;

  networking = {
    hostName = "nixos";
    nameservers = [ "130.255.73.90" "104.238.186.189" "185.121.177.177" "185.121.177.53" "50.116.40.226" ]; # OpenNIC DNS servers with DNSCrypt enabled
    networkmanager = {
      enable = true;
      insertNameservers = config.networking.nameservers;
    };
  };

  time.timeZone = "Europe/Warsaw";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    emacs = callPackage ./pkgs/emacs { };
    desktop_utils = callPackage ./pkgs/desktop_utils { };
  };

  environment.pathsToLink = [ "/share/oh-my-zsh" ];
  environment.systemPackages = with pkgs; [
    acpi
    arc-gtk-theme
    bindfs
    chromium
    desktop_utils.i3-lock-screen
    desktop_utils.i3-merge-configs
    dunst
    exiv2
    firefox
    feh
    gnupg
    gnupg1compat
    i3lock
    i3status
    imagemagick
    keepassx2
    libreoffice
    lightdm
    mpv
    ncmpcpp
    networkmanagerapplet
    oh-my-zsh
    pass
    pavucontrol
    rofi
    terminator
    texlive.combined.scheme-small
    thunderbird
    xorg.xev
    xss-lock
    zathura

    # dev
    emacs
    idea.idea-community
    ack
    ag
    go
    gotools
    ghc
    stack
    haskellPackages.idris
    cargo
    rustc
    rustfmt
    openjdk
    sbt
    scala
    scalafmt
    python
    racket
  ];

  fonts = {
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      anonymousPro
      hack-font
      inconsolata
      terminus_font
      unifont
      unifont_upper
    ];
  };

  programs.ssh.startAgent = false;

  services.emacs = {
    defaultEditor = true;
    enable = false;
    install = true;
    package = pkgs.emacs;
  };
  
  services.pcscd.enable = true;

  services.xserver = {
    enable = true;
    layout = "pl";

    synaptics = {
      enable = true;
      twoFingerScroll = true;
      tapButtons = true;
      fingersMap = [1 3 2];
    };
    
    displayManager.lightdm.enable = true;
    desktopManager.xterm.enable = false;
    windowManager.i3.enable = true;
  };

  services.mopidy = {
    enable = true;
    extensionPackages = [ pkgs.mopidy-mopify pkgs.mopidy-spotify pkgs.mopidy-spotify-tunigo ];
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

  systemd.services.gnupgshare = {
    description = "Share .gpg directory beetwen normal and work user";
    wantedBy = [ "user-10000.slice" ];
    partOf = [ "user-10000.slice" ];
    path = [ pkgs.bindfs pkgs.utillinux ];
    preStart = "mkdir -p ${config.users.users.kjw.home}/.gnupg";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = ''
        ${pkgs.bindfs}/bin/bindfs -u kjw -g users -M kjw -p 0600,u+D \
          ${config.users.users.kj.home}/.gnupg ${config.users.users.kjw.home}/.gnupg
      '';
      ExecStop = "${pkgs.utillinux}/bin/umount ${config.users.users.kjw.home}/.gnupg";
    };
  };

  users.extraUsers.kj = {
    hashedPassword = "${secrets.kjPassword}";
    uid = 1000;
    isNormalUser = true;
    home = "/home/kjanosz";
    description = "Krzysztof Janosz";
    extraGroups = [ "docker" "networkmanager" "vboxusers" "wheel" ]; 
  };

  users.extraUsers.kjw = {
    hashedPassword = "${secrets.kjwPassword}";
    uid = 10000;
    isNormalUser = true;
    home = "/home/kjanosz_work";
    description = "Krzysztof Janosz (Work)";
    extraGroups = [ "docker" "networkmanager" "vboxusers" ];
  };
  
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  
  system.stateVersion = "16.09";
}
