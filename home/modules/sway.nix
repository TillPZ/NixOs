{ pkgs, lib, ... }:
let
  mod = "Mod4";
  term = "foot";
  menu = "fuzzel";
in
{
  home.packages = with pkgs; [
    grim
    slurp
    swappy
    wl-clipboard
    cliphist
    pavucontrol
    pamixer
    pulsemixer
    brightnessctl
    playerctl
    networkmanagerapplet
    blueman
    wlsunset
    libnotify
    swaybg
    xdg-utils
    imv
    zathura
    mpv
    udiskie
    wf-recorder
    wev
    xarchiver
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = null; # System-Sway nutzen, HM schreibt nur Config
    config = {
      modifier = mod;
      terminal = term;
      menu = menu;
      bars = [ ];
      input."type:keyboard".xkb_layout = "de";
      output."*".bg = "${./wallpapers/diner-lonely-road.jpg} fill";

      window = {
        # <- NEU, hier auf config-Ebene
        titlebar = false;
        border = 2;
        commands = [
          # falls du die music-Regel hast:
          {
            criteria = {
              app_id = "music";
            };
            command = "move scratchpad";
          }
          {
            criteria = {
              app_id = "org.keepassxc.KeePassXC";
            };
            command = "move scratchpad";
          }
        ];
      };

      startup = [
        { command = "waybar"; }
        { command = "mako"; }
        { command = "nm-applet --indicator"; }
        { command = "blueman-applet"; }
        { command = "udiskie"; }
        { command = "wl-paste --watch cliphist store"; }
        { command = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent"; }
        { command = "wlsunset -l 52.4 -L 9.7"; }
        { command = "foot --app-id=music rmpc"; } # Musik-Scratchpad
        { command = "keepassxc"; }
        {
          command = "systemctl --user restart kanshi";
          always = true;
        }
      ];

      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec ${term}";
        "${mod}+d" = "exec ${menu}";
        "${mod}+n" = "exec makoctl dismiss"; # oberste Notification weg
        "${mod}+Shift+n" = "exec makoctl dismiss --all"; # alle weg
        "${mod}+p" = "exec keepmenu";
        "${mod}+Shift+p" = "[app_id=\"org.keepassxc.KeePassXC\"] scratchpad show";
        "${mod}+o" = "exec keepmenu -a \"{PASSWORD}{ENTER}\"";
        #"${mod}+q" = "kill";
        #"${mod}+e" = "exec thunar";
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

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      #height = 36;
      modules-left = [ "sway/workspaces" ];
      modules-center = [
        "mpris"
        "custom/sep"
        "sway/window"
      ];
      modules-right = [
        "cpu"
        "memory"
        "temperature"
        "power-profiles-daemon"
        "custom/sep"
        "pulseaudio"
        "network"
        "bluetooth"
        "battery"
        "custom/sep"
        "clock"
      ];

      "custom/sep" = {
        format = "│"; # oder "|", "·", "❘" — Geschmackssache
        tooltip = false;
      };

      clock = {
        format = "{:%H:%M}";
        tooltip-format = "<big>{:%A, %d. %B %Y}</big>\n<tt>{calendar}</tt>";
      };

      battery = {
        format = "{icon}{capacity}%";
        format-charging = "󰂄 {capacity}%"; # Blitz-Symbol beim Laden
        format-plugged = "󰚥 {capacity}%"; # am Netz, voll/nicht ladend
        format-icons = [
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
        interval = 10;
        states = {
          warning = 25;
          critical = 10;
        };
      };

      network = {
        format-wifi = "{icon} {essid}";
        format-ethernet = "󰈀 {ipaddr}";
        format-disconnected = "󰤮 offline";
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ]; # WLAN-Stärke: 0-20-40-60-80%
        interval = 5;
        tooltip-format-wifi = "{essid} ({signalStrength}%)  {frequency} GHz\n{ifname}: {ipaddr}/{cidr}\n {bandwidthUpBits}  {bandwidthDownBits}";
        tooltip-format-ethernet = "{ifname}: {ipaddr}/{cidr}\n {bandwidthUpBits}  {bandwidthDownBits}";
        on-click = "foot -e nmtui"; # Klick öffnet den Netzwerk-Manager im Terminal
      };

      bluetooth = {
        format = "󰂯"; # an, kein Gerät
        format-connected = "󰂱 {num_connections}"; # verbunden + Anzahl
        format-disabled = "󰂲"; # aus
        format-off = "󰂲";
        tooltip-format = "{controller_alias}\t{controller_address}";
        tooltip-format-connected = "{controller_alias}\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
        on-click = "bluetooth-menu"; # dein fuzzel-Script!
        on-click-right = "blueman-manager";
      };

      pulseaudio = {
        format = "{icon} {volume}% {format_source}";
        format-muted = "󰝟 {format_source}";
        format-source = ""; # Mikro aktiv
        format-source-muted = ""; # Mikro stumm
        format-icons = {
          headphone = "󰋋";
          headset = "󰋎";
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ]; # Lautsprecher, gestuft leise→laut
        };
        on-click = "pamixer -t"; # Klick: Ausgabe muten
        on-click-right = "pavucontrol"; # Rechtsklick: Mixer
        on-click-middle = "pamixer --default-source -t"; # Mittelklick: Mikro muten
        scroll-step = 5;
      };

      cpu = {
        format = " {usage}%";
        interval = 3;
        states = {
          warning = 70;
          critical = 90;
        };
      };

      memory = {
        format = "{percentage}%";
        interval = 5;
        tooltip-format = "{used:0.1f} / {total:0.1f} GiB";
        states = {
          warning = 75;
          critical = 90;
        };
      };

      temperature = {
        format = "{temperatureC}°C";
        interval = 5;
        critical-threshold = 85;
        # hwmon-path = "/sys/class/hwmon/hwmonX/tempY_input";  # siehe Hinweis
      };

      power-profiles-daemon = {
        format = " {icon} ";
        tooltip-format = "Power profile: {profile}nDriver: {driver}";
        tooltip = true;
        format-icons = {
          default = "";
          performance = "";
          balanced = "";
          power-saver = "";
        };
      };

      "sway/workspaces" = {
        all-outputs = true;
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
          "6" = [ ];
          "7" = [ ];
          "8" = [ ];
          "9" = [ ];
          "10" = [ ];
        };
      };
      mpris = {
        format = "{player_icon} {artist} – {title}";
        format-paused = " {artist} – {title}";
        player-icons.default = "▶";
        max-length = 40;
      };
    };
    style = ''
      * { font-family: "JetBrainsMono Nerd Font"; font-size: 14px; }
      window#waybar { background: rgba(30,30,46,0.9); color: #cdd6f4; }
            /* Workspaces des jeweils anderen Monitors: gedimmt */
      #workspaces button {
        color: #6c7086;
        padding: 0 6px;
      }
      #workspaces button.current_output {
        color: #cdd6f4;
        border-bottom: 2px solid #89b4fa;
      }
      #workspaces button.visible {
        background: #313244;
      }
      #workspaces button.focused {
        background: #45475a;
        color: #f5e0dc;
        border-bottom: 2px solid #f38ba8;
      }
      #workspaces button.urgent {
        background: #f38ba8;
        color: #1e1e2e;
      }
      #battery { padding: 0 6px; font-size: 14px }
      #battery.charging, #battery.plugged { color: #cdd6f4; }   
      #battery.warning:not(.charging) { color: #fab387; }
      #battery.critical:not(.charging) { color: #f38ba8; }
      #workspaces button.focused { background: #45475a; }
      #clock, #network, #pulseaudio,  #bluetooth, #tray, #mpris, #cpu, #temperature, #memory { padding: 0 6px; font-size: 14px }
    '';
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
  };

  services.mako = lib.mkDefault {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 11";
      background-color = "#1e1e2eee";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      border-size = 2;
      border-radius = 8;
      padding = "12";
      margin = "8";
      width = 350;
      default-timeout = 6000; # ms; 0 = bleibt bis zum Wegklicken
      anchor = "top-right";

      # kritische Meldungen abheben und liegen lassen:
      "urgency=critical" = {
        border-color = "#f38ba8";
        default-timeout = 0;
      };
    };
  };

  #programs.rofi = { enable = true; package = pkgs.rofi; };

  programs.fuzzel = lib.mkDefault {
    enable = true;
    settings = {
      main = {
        terminal = "foot";
        font = "JetBrainsMono Nerd Font:size=14";
        width = 40; # Zeichenbreite des Fensters
        lines = 12;
      };
      colors = {
        # passend zum Waybar-Look (Catppuccin-artig):
        background = "1e1e2eee";
        text = "cdd6f4ff";
        selection = "45475aff";
        selection-text = "cdd6f4ff";
        border = "89b4faff";
      };
      border = {
        radius = 4;
        width = 2;
      };
    };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.swaylock = lib.mkDefault {
    enable = true;
    settings = {
      image = "${./wallpapers/diner-lonely-road.jpg}"; # gleiches Bild wie Desktop
      scaling = "fill";
      indicator-radius = 100;
      inside-color = "1e1e2ecc";
      ring-color = "89b4fa";
      key-hl-color = "a6e3a1"; # Tastendruck: grün aufblitzen
      bs-hl-color = "f38ba8"; # Backspace: rot
      inside-ver-color = "1e1e2ecc";
      ring-ver-color = "f9e2af"; # beim Prüfen: gelb
      inside-wrong-color = "1e1e2ecc";
      ring-wrong-color = "f38ba8"; # falsches Passwort: rot
      text-color = "cdd6f4";
      show-failed-attempts = true;
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main.font = "JetBrainsMono Nerd Font:size=11";
      colors-dark = {
        alpha = 0.95; # dein bestehendes bleibt
        foreground = "cdd6f4";
        background = "1e1e2e";
        regular0 = "45475a"; # black   (surface1)
        regular1 = "f38ba8"; # red
        regular2 = "a6e3a1"; # green
        regular3 = "f9e2af"; # yellow
        regular4 = "89b4fa"; # blue
        regular5 = "f5c2e7"; # magenta (pink)
        regular6 = "94e2d5"; # cyan    (teal)
        regular7 = "bac2de"; # white   (subtext1)
        bright0 = "585b70"; # bright black (surface2)
        bright1 = "f38ba8";
        bright2 = "a6e3a1";
        bright3 = "f9e2af";
        bright4 = "89b4fa";
        bright5 = "f5c2e7";
        bright6 = "94e2d5";
        bright7 = "a6adc8"; # subtext0
        selection-foreground = "1e1e2e";
        selection-background = "f5e0dc"; # rosewater
        urls = "89b4fa";
      };
    };
  };

}
