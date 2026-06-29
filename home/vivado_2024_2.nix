# home/vivado_2024_2.nix  — 22.04 hat libtinfo5 nativ
import ./lib/xilinx-box.nix {
  slug = "2024_2";
  version = "2024.2";
  image = "ubuntu:22.04";
  extraInitHooks = ";apt-get install -y libtinfo5 || true";
}
