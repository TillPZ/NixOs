{ pkgs, ... }:
{ 
  imports = [ 
    ./home/vivado_2024_2.nix
    ./home/vivado_2026_1.nix
    ./home/nvim.nix
    ./home/starship.nix
    ./home/sway.nix
    ./home/music.nix
  ];
  home.username = "till";
  home.homeDirectory = "/home/till";
  home.stateVersion = "26.05";

  programs.fish.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      userName = "Till";
      userEmail = "coredump@segfault.eu";
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
  ];
}
