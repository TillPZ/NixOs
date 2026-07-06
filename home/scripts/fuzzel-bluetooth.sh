#!/usr/bin/env bash
# Bluetooth-Menü für fuzzel
# Abhängigkeiten: fuzzel, bluetoothctl (bluez)

menu() { fuzzel --dmenu --prompt "$1 " ; }

if bluetoothctl show | grep -q "Powered: yes"; then
    power_label="📴 Bluetooth ausschalten"
else
    power_label="🔵 Bluetooth einschalten"
fi

main_choice=$(printf '%s\n' \
    "🎧 Gerät verbinden" \
    "🔌 Gerät trennen" \
    "$power_label" \
    "🔍 Neues Gerät pairen" \
    "🗑️ Gerät entfernen" \
    | menu "Bluetooth:")

pick_device() {
    # $1 = bluetoothctl devices Argument (Paired/Connected/leer)
    bluetoothctl devices "$1" | awk '{mac=$2; $1=$2=""; sub(/^  /,""); printf "%s\t%s\n", $0, mac}' \
        | menu "Gerät:" | awk -F'\t' '{print $2}'
}

case "$main_choice" in
    "🎧 Gerät verbinden")
        bluetoothctl power on >/dev/null
        mac=$(pick_device Paired)
        [ -z "$mac" ] && exit 0
        if bluetoothctl connect "$mac"; then
          notify-send "Bluetooth" "Verbunden" 2>/dev/null || true
        else
          notify-send "Bluetooth" "Fehler beim Verbinden" 2>/dev/null || true
        fi
        ;;
    "🔌 Gerät trennen")
        mac=$(pick_device Connected)
        [ -n "$mac" ] && bluetoothctl disconnect "$mac"
        ;;
    "📴 Bluetooth ausschalten")
        bluetoothctl power off
        ;;
    "🔵 Bluetooth einschalten")
        bluetoothctl power on
        ;;
    "🔍 Neues Gerät pairen")
        bluetoothctl power on >/dev/null
        notify-send "Bluetooth" "Scanne 10 Sekunden..." 2>/dev/null || true
        bluetoothctl --timeout 10 scan on >/dev/null || true
        mac=$(pick_device "")
        [ -z "$mac" ] && exit 0
        if bluetoothctl pair "$mac" && bluetoothctl trust "$mac" && bluetoothctl connect "$mac"; then
          notify-send "Bluetooth" "Gepairt und verbunden" 2>/dev/null || true
        else
          notify-send "Bluetooth" "Pairing fehlgeschlagen" 2>/dev/null || true
        fi
        ;;
    "🗑️ Gerät entfernen")
        mac=$(pick_device Paired)
        [ -n "$mac" ] && bluetoothctl remove "$mac"
        ;;
esac
