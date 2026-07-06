
#!/usr/bin/env bash
# Netzwerk-Menü für fuzzel (WLAN + LAN via NetworkManager)
# Abhängigkeiten: fuzzel, nmcli

menu() { fuzzel --dmenu --prompt "$1 " ; }

wifi_state=$(nmcli radio wifi)
if [ "$wifi_state" = "enabled" ]; then
    toggle_label="📴 WLAN ausschalten"
else
    toggle_label="📶 WLAN einschalten"
fi

main_choice=$(printf '%s\n' \
    "📡 Mit WLAN verbinden" \
    "$toggle_label" \
    "🔌 Verbindung trennen" \
    "🌐 Gespeicherte Verbindung aktivieren" \
    "ℹ️ Status anzeigen" \
    | menu "Netzwerk:")

case "$main_choice" in
    "📡 Mit WLAN verbinden")
        notify-send "Netzwerk" "Scanne WLANs..." 2>/dev/null
        nmcli device wifi rescan 2>/dev/null
        sleep 2
        ssid=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | awk -F: 'length($1)>0 && !seen[$1]++ {printf "%s  [%s%%  %s]\n", $1, $2, ($3==""?"offen":$3)}' | menu "WLAN:" | sed 's/  \[.*//')
        [ -z "$ssid" ] && exit 0
        # Bereits bekannt? Dann einfach verbinden
        if nmcli -t -f NAME connection show | grep -qxF "$ssid"; then
            nmcli connection up "$ssid" && notify-send "Netzwerk" "Verbunden mit $ssid" 2>/dev/null
        else
            pass=$(fuzzel --dmenu --password --prompt "Passwort für $ssid: " </dev/null)
            
            # HIER KORRIGIERT: Befehle werden direkt im 'if' ausgeführt und geprüft
            if [ -n "$pass" ]; then
                if nmcli device wifi connect "$ssid" password "$pass"; then
                    notify-send "Netzwerk" "Verbunden mit $ssid" 2>/dev/null
                else
                    notify-send "Netzwerk" "Verbindung zu $ssid fehlgeschlagen" 2>/dev/null
                fi
            else
                if nmcli device wifi connect "$ssid"; then
                    notify-send "Netzwerk" "Verbunden mit $ssid" 2>/dev/null
                else
                    notify-send "Netzwerk" "Verbindung zu $ssid fehlgeschlagen" 2>/dev/null
                fi
            fi
        fi
        ;;
    "📴 WLAN ausschalten")
        nmcli radio wifi off
        ;;
    "📶 WLAN einschalten")
        nmcli radio wifi on
        ;;
    "🔌 Verbindung trennen")
        active=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: 'length($2)>0 {print $1}' | menu "Trennen:")
        [ -n "$active" ] && nmcli connection down "$active"
        ;;
    "🌐 Gespeicherte Verbindung aktivieren")
        conn=$(nmcli -t -f NAME connection show | menu "Verbindung:")
        [ -n "$conn" ] && nmcli connection up "$conn"
        ;;
    "ℹ️ Status anzeigen")
        nmcli -t -f NAME,TYPE,DEVICE connection show --active | sed 's/:/  |  /g' | menu "Aktiv:" >/dev/null
        ;;
esac
