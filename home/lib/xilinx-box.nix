{ slug, version, image, packages, extraInitHooks ? "", vivadoIcon ? null, vitisIcon ? null }:
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
      exec distrobox enter ${box} -- bash -c '
        ${guiEnv}
        source /tools/Xilinx/${subdir}/${version}/settings64.sh
        exec ${tool} "$@"
      ' ${tool} "$@"
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

  xdg.desktopEntries."vivado_${slug}" = {
    name = "Vivado ${version}";
    exec = "${vivado}/bin/vivado_${slug} %F";
    terminal = false;
    categories = [ "Development" ];
    icon = if vivadoIcon != null then "${vivadoIcon}" else "applications-engineering";
  };

  xdg.desktopEntries."vitis_${slug}" = {
    name = "Vitis ${version}";
    exec = "${vitis}/bin/vitis_${slug} %F";
    terminal = false;
    categories = [ "Development" ];
    icon = if vitisIcon != null then "${vitisIcon}" else "applications-engineering";
  };
}
