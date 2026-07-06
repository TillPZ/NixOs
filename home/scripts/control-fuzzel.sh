#!/usr/bin/env bash
# "Control Center" – Hauptmenü, das die Untermenüs aufruft
# Pfad ggf. anpassen:
DIR="$HOME/.config/fuzzel/scripts"

choice=$(printf '%s\n' \
    "🔊 Audio" \
    "📡 Netzwerk" \
    "🎧 Bluetooth" \
    "⏻ Power" \
    | fuzzel --dmenu --prompt "System: ")

case "$choice" in
    "🔊 Audio")     "$DIR/fuzzel-audio.sh" ;;
    "📡 Netzwerk")  "$DIR/fuzzel-network.sh" ;;
    "🎧 Bluetooth") "$DIR/fuzzel-bluetooth.sh" ;;
    "⏻ Power")
        p=$(printf '🔒 Sperren\n🌙 Suspend\n🔁 Neustart\n⏻ Herunterfahren\n🚪 Logout' \
            | fuzzel --dmenu --prompt "Power: ")
        case "$p" in
            "🔒 Sperren")        loginctl lock-session ;;
            "🌙 Suspend")        systemctl suspend ;;
            "🔁 Neustart")       systemctl reboot ;;
            "⏻ Herunterfahren")  systemctl poweroff ;;
            "🚪 Logout")         loginctl terminate-user "$USER" ;;
        esac
        ;;
esac
