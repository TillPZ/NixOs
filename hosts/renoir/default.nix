# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-d333bd83-affe-4e99-9123-60081b678914".device = "/dev/disk/by-uuid/d333bd83-affe-4e99-9123-60081b678914";
  networking.hostName = "renoir"; # Define your hostname.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05"; # Did you read the comment?


} 
