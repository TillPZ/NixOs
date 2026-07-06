{ pkgs, ... }:
{
  programs.btop.enable = true;

  home.packages = with pkgs; [
    tio
    # künftige CLI-Werkzeuge hierher
  ];
}
