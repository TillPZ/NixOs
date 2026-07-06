{ pkgs,  ... }:
{ 
  imports = [ 
    ./vivado_2024_2.nix
    ./vivado_2026_1.nix
    ./nvim.nix
    ./starship.nix
    ./sway.nix
    ./music.nix
    ./scripts.nix
    ./modules/cli.nix
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
catppuccin = {
  enable = true;        # globaler Schalter für alle unterstützten Programme
  autoEnable = true;
  flavor = "mocha";
  accent = "blue";      # passt zu deinem 89b4fa-Akzent
};

}
