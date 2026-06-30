# NixOS Config

Flake-basierte NixOS- und Home-Manager-Konfiguration.
Pin: `nixos-26.05` (siehe `flake.lock`). Host: `renoir`. User: `till`.

> **Grundregel:** Quelle der Wahrheit ist dieses Repo, **nicht** `/etc/nixos`.
> Neue Datei angelegt → **immer zuerst `git add`**, sonst sieht die Flake sie nicht.

## Struktur

```
~/.config/nixos/
├── flake.nix                # inputs (nixpkgs, home-manager) + nixosConfigurations
├── flake.lock               # gepinnte Commits – IMMER mitcommitten
├── configuration.nix        # System-Config
├── hardware-configuration.nix
├── home.nix                 # Home-Manager: User-Settings + imports
└── home/
    ├── lib/
    │   └── xilinx-box.nix   # Helper: erzeugt .ini + Launcher + Desktop-Eintrag pro Box
    ├── icons/               # Logos für die Desktop-Einträge (git-getrackt)
    └── vivado_2024_2.nix    # eine Box = ein kleiner import-Aufruf des Helpers
```

Die Distrobox-`.ini`-Dateien werden von Home Manager generiert und liegen als
**read-only Symlinks** unter `~/.config/distrobox/`. Nie direkt editieren –
stattdessen die `.nix` ändern und neu bauen.

## System bauen / aktualisieren

```bash
cd ~/.config/nixos

# Config-Änderung übernehmen (häufigster Befehl):
sudo nixos-rebuild switch --flake .#renoir

# Nur bauen, ohne zu aktivieren (zum Testen, ob es überhaupt evaluiert):
sudo nixos-rebuild build --flake .#renoir

# Auf die vorherige Generation zurück (falls ein Switch Mist baut):
sudo nixos-rebuild switch --rollback
```

> Nach dem Switch in der Ausgabe auf `home-manager-till.service` achten –
> das ist das Signal, dass Home Manager tatsächlich Dateien geschrieben hat.

### Inputs aktualisieren (nixpkgs / home-manager hochziehen)

```bash
cd ~/.config/nixos
nix flake update                              # schreibt flake.lock neu
sudo nixos-rebuild switch --flake .#renoir
git add flake.lock && git commit -m "flake update $(date +%F)"
```

Update gefällt nicht? `flake.lock` aus Git wiederherstellen und neu bauen:

```bash
git checkout flake.lock
sudo nixos-rebuild switch --flake .#renoir
```

## Distroboxen erstellen

Die `.ini` entsteht beim `nixos-rebuild switch`. **Danach** den Container bauen.
Wichtig: Der Container heißt nach dem **Sektionsnamen** in der `.ini`
(z. B. `[vivado_2024_2]`), nicht nach dem Dateinamen.

```bash
# Container aus generierter .ini bauen / neu bauen:
distrobox assemble create --replace --file ~/.config/distrobox/vivado_2024_2.ini

# Reingehen:
distrobox enter vivado_2024_2

# Container löschen:
distrobox rm vivado_2024_2
```

### Tools starten

Launcher liegen im Host-`PATH` und als Desktop-Icons. Sie sourcen `settings64.sh`
im Container und starten dann das Tool:

```bash
vivado_2024_2      # Vivado 2024.2
vitis_2024_2       # Vitis 2024.2
```

## Neue Version hinzufügen

1. Box-Datei anlegen (per Heredoc, damit keine Klammer verlorengeht):

   ```bash
   cd ~/.config/nixos
   cat > home/vivado_2026_1.nix << 'EOF'
   import ./lib/xilinx-box.nix {
     slug = "2026_1";
     version = "2026.1";
     image = "ubuntu:24.04";   # OS-Support pro Version in UG973 prüfen!
     # extraInitHooks = ";...";  # z. B. libtinfo5-Workaround auf 24.04
   }
   EOF
   ```

2. In `home.nix` unter `imports` eintragen:

   ```nix
   imports = [
     ./home/vivado_2024_2.nix
     ./home/vivado_2026_1.nix
   ];
   ```

3. Tracken, bauen, Container erstellen:

   ```bash
   git add -A
   sudo nixos-rebuild switch --flake .#renoir
   distrobox assemble create --replace --file ~/.config/distrobox/vivado_2026_1.ini
   ```

> **Hinweis Ubuntu-Version:** Vivado/Vitis supporten je Release unterschiedliche
> OS-Versionen. 2024.x → Ubuntu 22.04 (libtinfo5 nativ verfügbar).
> Spätere Releases ggf. 24.04+ (libtinfo5 fehlt → Symlink-/Paket-Workaround per
> `extraInitHooks`). Maßgeblich ist UG973 der jeweiligen Version.
>
> **PetaLinux** braucht einen eigenen Helper (`settings.sh` statt `settings64.sh`,
> andere Tool-Befehle, andere Abhängigkeiten). Schema: `peta_<version>`.

## Zweites Gerät

Repo klonen, dann pro Host eine eigene `hardware-configuration.nix`.
Gemeinsame Teile (`home/…`) werden geteilt; nur Host-Spezifisches unterscheidet sich.
Da `flake.lock` mitcheckt, laufen beide Geräte auf bit-genau demselben nixpkgs-Commit.
