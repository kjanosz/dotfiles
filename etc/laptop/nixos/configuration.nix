{ config, pkgs, pkgs_unstable, ... }:

let
  secrets = import ./secrets.nix;
in
{
  imports = [
    ./common.nix
    ./modules/dev.nix
    ./modules/foxcommerce.nix
  ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.blacklistedKernelModules = [ "bcma" ];	
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

  nix = {
    buildCores = 4;
    maxJobs = 4;
  };  

  networking = {
    hostName = "nixos";
    extraHosts = "127.0.0.1 ${config.networking.hostName}";
    nameservers = [ "130.255.73.90" "104.238.186.189" "185.121.177.177" "185.121.177.53" "50.116.40.226" ]; # OpenNIC DNS servers with DNSCrypt enabled
    networkmanager = {
      enable = true;
      insertNameservers = config.networking.nameservers;
    };
  };

  fonts = {
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      anonymousPro
      font-awesome-ttf
      hack-font
      inconsolata
      terminus_font
      unifont
      unifont_upper
    ];
  };

  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ m17n table-other ];
  };
  
  time.timeZone = "Europe/Warsaw";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    ammonite2_10 = callPackage ./pkgs/ammonite { scala = "2.10"; };
    ammonite2_11 = callPackage ./pkgs/ammonite { scala = "2.11"; };
    ammonite2_12 = callPackage ./pkgs/ammonite { scala = "2.12"; };
    
    base16-builder = callPackage ./pkgs/base16-builder { };

    desktop_utils = callPackage ./pkgs/desktop_utils { };

    emacs = callPackage ./pkgs/emacs { };

    calibre = pkgs.calibre.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ python27Packages.dns ];
    });

    inherit (pkgs_unstable) i3;
  };

  environment.systemPackages = with pkgs; [
    acpi
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.pl
    base16-builder
    bindfs
    calibre
    chromium
    conky
    desktop_utils.i3-lock-screen
    desktop_utils.i3-merge-configs
    dropbox
    dunst
    exiv2
    firefox
    feh
    ghostscript
    gimp-with-plugins
    gtk-engine-murrine
    haskellPackages.hledger
    i3lock
    i3status
    imagemagick
    inkscape
    keepassx2
    libnotify
    libreoffice
    lightdm
    mpv
    ncmpcpp
    networkmanagerapplet
    numix-gtk-theme
    numix-icon-theme
    numix-icon-theme-circle
    pass
    pavucontrol
    pdftk
    python27Packages.py3status
    rofi
    termite
    texlive.combined.scheme-full
    thunderbird
    wineFull
    xss-lock
    zathura
  ];
  
  programs.ssh.startAgent = false;
  
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

    desktopManager.xterm.enable = false;
    displayManager.lightdm.enable = true;
    windowManager.i3 = {
      enable = true;
      extraSessionCommands = ''
         # Set GTK_PATH so that GTK+ can find the theme engines.
         export GTK_PATH="${config.system.path}/lib/gtk-2.0:${config.system.path}/lib/gtk-3.0"

         # Set GTK_DATA_PREFIX so that GTK+ can find the Xfce themes.
         export GTK_DATA_PREFIX=${config.system.path}
      
         # SVG loader for pixbuf (needed for GTK svg icon themes)
         export GDK_PIXBUF_MODULE_FILE=$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)
      '';
    };  
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

  systemd.services.projectsshare = {
    wantedBy = [ "user-10000.slice" ];
    partOf = [ "user-10000.slice" ];

    path = [ pkgs.bindfs pkgs.utillinux ];
    preStart = "mkdir -p ${config.users.users.kjw.home}/Projects/Private";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = ''
        ${pkgs.bindfs}/bin/bindfs -u kjw -g users -M kjw -p 0600,u+D \
          ${config.users.users.kj.home}/Projects ${config.users.users.kjw.home}/Projects/Private
      '';
      ExecStop = "${pkgs.utillinux}/bin/umount ${config.users.users.kjw.home}/Projects/Private";
    };
  };

  systemd.user.services.gnupg = {
    wantedBy = [ "default.target" ];
    
    path = [ pkgs.gnupg ];
    script = ''
      gpg-agent --homedir $HOME/.gnupg --use-standard-socket --daemon
    '';
    serviceConfig = {
      Type = "forking";
      Restart = "always";
      KillSignal = "SIGKILL";
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
}
