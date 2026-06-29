# home/vivado_2026_1.nix  — 24.04: libtinfo5 fehlt, Symlink als Workaround
import ./lib/xilinx-box.nix {
  slug = "2026_1";
  version = "2026.1";
  image = "ubuntu:24.04";
  extraInitHooks = ";ln -sf /lib/x86_64-linux-gnu/libtinfo.so.6 /lib/x86_64-linux-gnu/libtinfo.so.5 || true";
}
