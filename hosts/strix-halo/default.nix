# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;


 nixpkgs.config.allowUnfree = true; 

  system.stateVersion = "26.05";


  fileSystems."/home/till/ramdisk" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "mode=700"
      "size=32G"
      "uid=till"
      "gid=users"
    ];
  };
}


