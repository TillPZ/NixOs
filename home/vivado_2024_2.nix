import ./lib/xilinx-box.nix {
  slug = "2024_2";
  version = "2024.2";
  image = "ubuntu:22.04";
  packages = [
    "locales" "libtinfo5" "libncurses5" "libstdc++6"
    "libx11-6" "libxext6" "libxrender1" "libxtst6" "libxi6"
    "libfreetype6" "libfontconfig1" "libnss3" "libasound2"
    "libcrypt1" "libyaml-0-2" "graphviz" "default-jre"
  ];
}
