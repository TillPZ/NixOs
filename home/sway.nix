{ pkgs, lib, ... }:
let
  mod = "Mod4";
  term = "foot";
  menu = "rofi -show drun";
in
{
  home.packages = with pkgs; [
    grim slurp swappy
    wl-clipboard cliphist
    pavucontrol pamixer pulsemixer
    brightnessctl playerctl
    networkmanagerapplet blueman
    wlsunset libnotify
    swaybg xdg-utils
    imv zathura mpv
    udiskie wf-recorder wev
    xarchiver
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = null;                       # System-Sway nutzen, HM schreibt nur Config
    config = {
      modifier = mod;
      terminal = term;
      menu = menu;
      bars = [];

      input."type:keyboard".xkb_layout = "de";

      window.commands = [
        { criteria = { app_id = "music"; }; command = "move scratchpad"; }
      ];

      startup = [
        { command = "waybar"; }
        { command = "mako"; }
        { command = "nm-applet --indicator"; }
        { command = "blueman-applet"; }
        { command = "udiskie --tray"; }
        { command = "wl-paste --watch cliphist store"; }
        { command = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent"; }
        { command = "wlsunset -l 52.4 -L 9.7"; }
        { command = "foot --app-id=music rmpc"; }   # Musik-Scratchpad
      ];

      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec ${term}";
        "${mod}+d" = "exec ${menu}";
        "${mod}+q" = "kill";
        "${mod}+e" = "exec thunar";
        "${mod}+m" = "[app_id=\"music\"] scratchpad show";
        "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "XF86AudioRaiseVolume" = "exec pamixer -i 5";
        "XF86AudioLowerVolume" = "exec pamixer -d 5";
        "XF86AudioMute" = "exec pamixer -t";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
      };
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main.font = "JetBrainsMono Nerd Font:size=11";
      colors.alpha = 0.95;
    };
  };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      modules-left = [ "sway/workspaces" ];
      modules-center = [ "mpris" "clock" ];
      modules-right = [ "pulseaudio" "network" "bluetooth" "battery" "tray" ];
      clock.format = "{:%a %d.%m  %H:%M}";
      mpris = {
        format = "{player_icon} {artist} – {title}";
        format-paused = " {artist} – {title}";
        player-icons.default = "▶";
        max-length = 40;
      };
      network.format-wifi = "  {essid}";
      network.format-ethernet = "  {ipaddr}";
      network.format-disconnected = "⚠ off";
      pulseaudio.format = "  {volume}%";
      bluetooth.format = "  {status}";
      battery.format = "{icon} {capacity}%";
      battery.format-icons = [ "" "" "" "" "" ];
    };
    style = ''
      * { font-family: "JetBrainsMono Nerd Font"; font-size: 12px; }
      window#waybar { background: rgba(30,30,46,0.9); color: #cdd6f4; }
      #workspaces button.focused { background: #45475a; }
      #clock, #network, #pulseaudio, #battery, #bluetooth, #tray, #mpris { padding: 0 10px; }
    '';
  };

  services.mako.enable = true;

  programs.rofi = { enable = true; package = pkgs.rofi; };

  programs.yazi = { enable = true; enableFishIntegration = true; };

  programs.swaylock.enable = true;
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { timeout = 600; command = "swaymsg 'output * dpms off'";
        resumeCommand = "swaymsg 'output * dpms on'"; }
    ];
  };
}
