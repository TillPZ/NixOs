# Audio-Menü für fuzzel (PipeWire/PulseAudio via pactl)
# Abhängigkeiten: fuzzel, pactl

menu() { fuzzel --dmenu --prompt "$1 " ; }

main_choice=$(printf '%s\n' \
    "🔊 Ausgabegerät wechseln" \
    "🎤 Eingabegerät wechseln" \
    "🔇 Stummschalten an/aus" \
    "➕ Lautstärke +5%" \
    "➖ Lautstärke -5%" \
    "🎚️ Lautstärke setzen" \
    | menu "Audio:")

case "$main_choice" in
    "🔊 Ausgabegerät wechseln")
        sink=$(pactl list sinks | grep -E "Name:|Description:" \
            | paste - - | sed 's/.*Name: \(\S*\).*Description: /\1\t/' \
            | fuzzel --dmenu --prompt "Ausgabe: " --with-nth 2 || true)
        # Fallback falls fuzzel kein --with-nth kennt:
        if [ -z "$sink" ]; then exit 0; fi
        sink_name=$(printf '%s' "$sink" | cut -f1)
        pactl set-default-sink "$sink_name"
        # laufende Streams mit umziehen
        pactl list short sink-inputs | cut -f1 | while read -r id; do
            pactl move-sink-input "$id" "$sink_name"
        done
        notify-send "Audio" "Ausgabe: $(printf '%s' "$sink" | cut -f2)" 2>/dev/null
        ;;
    "🎤 Eingabegerät wechseln")
        source=$(pactl list sources | grep -E "Name:|Description:" \
            | paste - - | sed 's/.*Name: \(\S*\).*Description: /\1\t/' \
            | grep -v '\.monitor' \
            | fuzzel --dmenu --prompt "Eingabe: " --with-nth 2 || true)
        [ -z "$source" ] && exit 0
        pactl set-default-source "$(printf '%s' "$source" | cut -f1)"
        notify-send "Audio" "Eingabe: $(printf '%s' "$source" | cut -f2)" 2>/dev/null
        ;;
    "🔇 Stummschalten an/aus")
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    "➕ Lautstärke +5%")
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    "➖ Lautstärke -5%")
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    "🎚️ Lautstärke setzen")
        vol=$(printf '100\n90\n80\n70\n60\n50\n40\n30\n20\n10\n0' | menu "Lautstärke %:")
        [ -n "$vol" ] && pactl set-sink-volume @DEFAULT_SINK@ "${vol}%"
        ;;
esac
