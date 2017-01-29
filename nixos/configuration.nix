{ config, pkgs, ... }:

{
  import = [
    ./common.nix
    ./hardware-configuration.nix
    ./monitoring.nix
    ./web.nix
  ];

  boot.loader.grub.device = "/dev/vda";

  networking = {
    hostName = "kjanosz.com";
    firewall.allowedTCPPorts = [ 80 443 ];
    wireless.enable = false;
  };

  time.timeZone = "Europe/Frankfurt";

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  security.pam = {
    enableSSHAgentAuth = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.extraUsers.kj = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsk9lKuN4J3N1x39i20m+HoRetjeQh9BSP9pjhgtZq068Wv8xyrSkrgF6CR97DfWf/8nNZNHAMIOdcR0MYL5RqEpgT0NXUDvMOV6NwAw7g7hSUXueGq9lbAS1DjZkYm6/pkAsTUJ1lp7kEgCLFPVOmpaPMNpyANyTrNyuRmzndqyDIFgT5jLLo3Z0Y1Skwjj6LAQAw0k+FGVHguQkjsEaELjkXCnLx/yv4iVOBecbNbQmoL1Om2JPjTZzFPvRg5ClzD82opPtwCMxDSENs3ycVB7pvvpV4MbTbjdZxRbEO1kTGm5ApCpjKMjl2uocKEcr5v9HxI98fHJIqTy/mh5iauG04lsRPoyGDGMeQap/64DgqRcRs5R9sPqjKPbGdqUYGdGpjUodeTlTGbpVaoLIu6yW2oiejqTxUNdKofgWiW8neixSSDhGOX/ubaWBLHZi9ICymLdmlxMihU/lu6N7SScMKYMkafQTOV7Dr664C4yR3JUCffKQqIZtDxGkAlNot2vMK0oABrUK6y7NWi9662pq/rqwYugEjn7JL5tU8LLtyqBwe++27W94Z5tnausvewe7E+vUzXGK0vUISFsf8fTeZ254qcZ4nso/eAmmJvYPZ6vCzcmgPZ1qYNGlGjqtCBFakocLR3uFHMTHpQY+tyehiZcbm4uzdqHE9wDCEUQ== janosz.krzysztof@gmail.com" ];
  };

  services.nginx = {
    enable = true;
  };

  system.stateVersion = "16.09";

  virtualisation.docker.enable = true;
}
