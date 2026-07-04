import ./lib/xilinx-box.nix {
  slug = "2026_1";
  version = "2026.1";
  image = "ubuntu:24.04";
  packages = [
    "locales" "libncurses6" "libstdc++6"
    "libx11-6" "libxext6" "libxrender1" "libxtst6" "libxi6"
    "libfreetype6" "libfontconfig1" "libnss3" "libasound2t64"
    "libcrypt1" "libyaml-0-2" "graphviz" "default-jre"
  ];
  extraInitHooks = ";ln -sf /lib/x86_64-linux-gnu/libtinfo.so.6 /lib/x86_64-linux-gnu/libtinfo.so.5 || true";
}
