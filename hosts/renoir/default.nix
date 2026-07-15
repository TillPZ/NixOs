# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-d333bd83-affe-4e99-9123-60081b678914".device =
    "/dev/disk/by-uuid/d333bd83-affe-4e99-9123-60081b678914";

  boot.extraModprobeConfig = ''
    options psmouse synaptics_intertouch=0
  '';

  systemd.services.psmouse-resume = {
    description = "Reload psmouse after suspend";
    after = [
      "suspend.target"
      "hibernate.target"
    ];
    wantedBy = [
      "suspend.target"
      "hibernate.target"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 2 && ${pkgs.kmod}/bin/modprobe -r psmouse && ${pkgs.kmod}/bin/modprobe psmouse'";
    };
  };

  networking.hostName = "renoir"; # Define your hostname.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05"; # Did you read the comment?

  fileSystems."/home/till/ramdisk" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "mode=700"
      "size=2G"
      "uid=till"
      "gid=users"
    ];
  };
}
