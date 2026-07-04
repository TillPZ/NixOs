{ pkgs, ... }:
{
  programs.sway.enable = true;          # Session erscheint im GDM-Login

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # optional: hardware.bluetooth.settings.General.Experimental = true;  # BT-Akku-Anzeige
  services.blueman.enable = true;

  networking.networkmanager.enable = true;

  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];
}
