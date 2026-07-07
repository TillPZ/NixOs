{pkgs, ...}: {
  programs.btop.enable = true;

  home.packages = with pkgs; [
    glow
    tio
    alejandra
    statix       # Nix-Linter (Anti-Pattern-Checks)
    nixd         # falls noch kein Nix-LSP da ist — siehe unten
  ];
}
