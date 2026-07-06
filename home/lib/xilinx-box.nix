{ slug, version, image, packages, extraInitHooks ? "", vivadoIcon ? ../icons/vivado.png, vitisIcon ? ../icons/vitis.png }:
{ pkgs, ... }:
let
  box = "vivado_${slug}";
  pkgList = pkgs.lib.concatStringsSep " " packages;

  guiEnv = ''
    export _JAVA_AWT_WM_NONREPARENTING=1
    export QT_QPA_PLATFORM=xcb
    export GDK_BACKEND=x11
  '';


  mkLauncher = { cmd, tool, subdir }:
    pkgs.writeShellScriptBin cmd ''
      LOGFILE="$HOME/.local/share/${cmd}-debug.log"
      echo "=== Start ${cmd} am $(date) ===" > "$LOGFILE"
      echo "=== Start ${box} am $(date) ===" > "$LOGFILE"


      # Pfade als Variablen definieren
      PATH_CLASSIC="/tools/Xilinx/${subdir}/${version}/settings64.sh"
      PATH_NEW="/tools/Xilinx/${version}/${subdir}/settings64.sh"

      exec distrobox enter "${box}" --no-tty -- bash -c "
        ${guiEnv}
        
        if [ -f '$PATH_CLASSIC' ]; then
          echo 'Nutze klassischen Pfad: $PATH_CLASSIC' >> '$LOGFILE'
          source '$PATH_CLASSIC' >> '$LOGFILE' 2>&1
          exec ${tool} >> '$LOGFILE' 2>&1
          
        elif [ -f '$PATH_NEW' ]; then
          echo 'Nutze neuen 2026er Pfad: $PATH_NEW' >> '$LOGFILE'
          source '$PATH_NEW' >> '$LOGFILE' 2>&1
          exec ${tool} >> '$LOGFILE' 2>&1
          
        else
          echo 'Fehler: settings64.sh konnte an keinem der folgenden Orte gefunden werden:' >> '$LOGFILE'
          echo '  1. $PATH_CLASSIC' >> '$LOGFILE'
          echo '  2. $PATH_NEW' >> '$LOGFILE'
          exit 1
        fi
      "
    '';


  vivado = mkLauncher { cmd = "vivado_${slug}"; tool = "vivado"; subdir = "Vivado"; };
  vitis  = mkLauncher { cmd = "vitis_${slug}";  tool = "vitis";  subdir = "Vitis";  };
in
{
  xdg.configFile."distrobox/vivado_${slug}.ini".text = ''
    [${box}]
    image=${image}
    home=/home/till/.local/share/distrobox-homes/${box}
    pull=true
    init=false
    root=false
    replace=true
    volume="/tools/Xilinx:/tools/Xilinx /home/till/dev:/home/till/dev"
    additional_packages="${pkgList}"
    init_hooks="locale-gen en_US.UTF-8 || true${extraInitHooks}"
  '';

  home.packages = [ vivado vitis ];


  xdg.desktopEntries."local.xilinx.vivado_${slug}" = {
    name = "Vivado ${version} (NixOS)";
    exec = "${vivado}/bin/vivado_${slug} %F";
    terminal = false;
    categories = [ "Development" ];
    icon = if vivadoIcon != null then "${vivadoIcon}" else "applications-engineering";
  };

  xdg.desktopEntries."local.xilinx.vitis_${slug}" = {
    name = "Vitis ${version} (NixOS)";
    exec = "${vitis}/bin/vitis_${slug} %F";
    terminal = false;
    categories = [ "Development" ];
    icon = if vitisIcon != null then "${vitisIcon}" else "applications-engineering";
  };

}
