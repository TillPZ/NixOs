{ pkgs, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/till/musik";   # anpassen! Ordner muss existieren
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire"
      }
      auto_update "yes"
    '';
  };

  services.mpd-mpris.enable = true;   # MPRIS-Brücke → Waybar/playerctl sehen MPD

  home.packages = with pkgs; [ rmpc mpc ];
}
