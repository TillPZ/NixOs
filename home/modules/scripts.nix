{ pkgs, ... }:
let
  fuzzel-audio = pkgs.writeShellApplication {
    name = "fuzzel-audio";
    runtimeInputs = with pkgs; [
      fuzzel
      pulseaudio
      libnotify
      coreutils gnugrep gnused
    ];
    text = builtins.readFile ./scripts/fuzzel-audio.sh;
  };

  fuzzel-bluetooth = pkgs.writeShellApplication {
    name = "fuzzel-bluetooth";
    runtimeInputs = with pkgs; [
      fuzzel
      bluez
      libnotify
      coreutils gnugrep gnused
    ];
    text = builtins.readFile ./scripts/fuzzel-bluetooth.sh;
  };

  fuzzel-network = pkgs.writeShellApplication {
    name = "fuzzel-network";
    runtimeInputs = with pkgs; [
      fuzzel
      networkmanager
      libnotify
      coreutils gawk gnused
    ];
    text = builtins.readFile ./scripts/fuzzel-network.sh;
  };

  fuzzel-disk = pkgs.writeShellApplication {
    name = "fuzzel-disk";
    runtimeInputs = with pkgs; [
      fuzzel udisks libnotify
      util-linux    # lsblk
      gawk gnused coreutils
    ];
    text = builtins.readFile ./scripts/fuzzel-menu.sh;
  };

  # Hauptmenü umgestellt auf writeShellScriptBin, damit es nicht mehr abstürzt
  fuzzel-control = pkgs.writeShellScriptBin "fuzzel-control" ''
    #!/usr/bin/env bash
    
    # Packt alle drei Untermenüs in den direkten Suchpfad dieses Skripts
    export PATH="${pkgs.lib.makeBinPath [ fuzzel-audio fuzzel-bluetooth fuzzel-network pkgs.fuzzel pkgs.systemd pkgs.coreutils ]}:''$PATH"
    
    ${builtins.readFile ./scripts/fuzzel-control.sh}
  '';

  passmenu = pkgs.writeShellScriptBin "passmenu" ''
    entry=$(rbw list | ${pkgs.fuzzel}/bin/fuzzel --dmenu)
    [ -n "$entry" ] && rbw get "$entry" | ${pkgs.wl-clipboard}/bin/wl-copy
  '';


in
{
  home.packages = [ fuzzel-audio fuzzel-bluetooth fuzzel-network fuzzel-disk fuzzel-control ];

  xdg.desktopEntries.fuzzel-control = {
    name = "Control Center";
    comment = "Systemsteuerung für Audio, Netzwerk, Bluetooth und Power";
    exec = "${fuzzel-control}/bin/fuzzel-control";
    terminal = false;
    categories = [ "Utility" "Settings" ];
  };

  xdg.desktopEntries.passmenu = {
    name = "Password Manager";
    exec = "passemnu";
    terminal = false;
  };



}
