# Disk-Menü für fuzzel — mounten/unmounten/auswerfen via udisksctl
menu() { fuzzel --dmenu --prompt "$1 " ; }

action=$(printf '%s\n' \
    "󰉍 Einhängen" \
    "󰗇 Aushängen" \
    "󰐥 Auswerfen (Strom aus)" \
    | menu "Disk:")


list_candidates() {
  # $1 = "unmounted" oder "mounted" — nur Wechselmedien (hotplug)
  lsblk -Ppo NAME,TYPE,SIZE,LABEL,MOUNTPOINT,HOTPLUG | while read -r line; do
      eval "$line"    # setzt NAME, TYPE, SIZE, LABEL, MOUNTPOINT, HOTPLUG
      [ "$TYPE" = "part" ] || continue
      [ "$HOTPLUG" = "1" ] || continue
      if [ "$1" = "mounted" ] && [ -n "$MOUNTPOINT" ]; then
          printf '%s (%s, %s)\n' "$NAME" "${LABEL:-ohne Label}" "$SIZE"
      elif [ "$1" = "unmounted" ] && [ -z "$MOUNTPOINT" ]; then
          printf '%s (%s, %s)\n' "$NAME" "${LABEL:-ohne Label}" "$SIZE"
      fi
  done
}


case "$action" in
    "󰉍 Einhängen")
        dev=$(list_candidates unmounted | menu "Einhängen:" | awk '{print $1}')
        [ -z "$dev" ] && exit 0
        if out=$(udisksctl mount -b "$dev" 2>&1); then
            notify-send "Disk" "$out" 2>/dev/null || true
        else
            notify-send "Disk" "Fehler: $out" 2>/dev/null || true
        fi
        ;;
    "󰗇 Aushängen")
        dev=$(list_candidates mounted | menu "Aushängen:" | awk '{print $1}')
        [ -z "$dev" ] && exit 0
        udisksctl unmount -b "$dev" || notify-send "Disk" "Aushängen fehlgeschlagen (Datei offen?)" 2>/dev/null || true
        ;;
    "󰐥 Auswerfen (Strom aus)")
        dev=$(list_candidates mounted | menu "Auswerfen:" | awk '{print $1}')
        [ -z "$dev" ] && exit 0
        udisksctl unmount -b "$dev" 2>/dev/null || true
        base=$(printf '%s' "$dev" | sed 's/[0-9]*$//')
        if udisksctl power-off -b "$base"; then
            notify-send "Disk" "Kann entfernt werden" 2>/dev/null || true
        fi
        ;;
esac
