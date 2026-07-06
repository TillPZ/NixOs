#!/usr/bin/env bash
# "Control Center" – Hauptmenü, das die Untermenüs aufruft

choice=$(printf '%s\n' \
    "🔊 Audio" \
    "📡 Netzwerk" \
    "🎧 Bluetooth" \
    "󰋊 Disks" \
    "⏻ Power" \
    | fuzzel --dmenu --prompt "System: ")

case "$choice" in
    "🔊 Audio")     fuzzel-audio ;;
    "📡 Netzwerk")  fuzzel-network ;;
    "🎧 Bluetooth") fuzzel-bluetooth ;;
    "󰋊 Disks")      fuzzel-disk ;;
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
