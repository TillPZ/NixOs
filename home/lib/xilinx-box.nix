{ slug, version, image, extraInitHooks ? "", vivadoIcon ? null, vitisIcon ? null }:
{ pkgs, ... }:
let
  box = "vivado_${slug}";

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
    additional_packages="locales libncurses5 libstdc++6"
    additional_packages="libx11-6 libxext6 libxrender1 libxtst6 libxi6"
    additional_packages="libfreetype6 libfontconfig1 libnss3 libasound2"
    additional_packages="libcrypt1 libyaml-0-2 graphviz default-jre"
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
