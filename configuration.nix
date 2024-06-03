# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  mgnupg22 = pkgs.gnupg22.override { libgcrypt = pkgs.libgcrypt; };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./users.nix
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nas"; # Define your hostname.
  networking.hostId = "85307a5c";

  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    mgnupg22
    zfs
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.git = {
    enable = true;
    config = {
      safe.directory = "/etc/nixos";
    };
  };
  # otherwise get's enabled automatically, using ssh gpg-agent forwarding
  programs.gnupg.agent.enable = false;  

  # List services that you want to enable:

  # Enable periodic TRIM on zfs drives
  services.zfs.trim.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowGroups = [ "users" ];
    };
    extraConfig = ''
      StreamLocalBindUnlink yes  # used for gpg forwarding
    '';
  };

  systemd.user.services.gnupg-create-socketdir = {
    enable = true;
    wantedBy = [ "default.target" ];
    description = "Create GnuPG socket directory";

    serviceConfig = {
      Type = "simple";
      ExecStart = "${mgnupg22}/bin/gpgconf --create-socketdir";
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

