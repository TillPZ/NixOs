{ ... }:
{
  # Workspaces: Prioritätslisten statt statisch —
  # Sway nimmt den ersten vorhandenen Output der Liste, dynamisch bei An-/Abstecken
  wayland.windowManager.sway.config.workspaceOutputAssign = [
    # 1-5: bevorzugt externer Monitor 1, sonst intern
    { workspace = "1";  output = [ "HDMI-A-1" "eDP-1" ]; }
    { workspace = "2";  output = [ "HDMI-A-1" "eDP-1" ]; }
    { workspace = "3";  output = [ "HDMI-A-1" "eDP-1" ]; }
    { workspace = "4";  output = [ "HDMI-A-1" "eDP-1" ]; }
    { workspace = "5";  output = [ "HDMI-A-1" "eDP-1" ]; }
    # 6-10: bevorzugt externer Monitor 2, sonst externer 1, sonst intern
    { workspace = "6";  output = [ "DP-2" "HDMI-A-1" "eDP-1" ]; }
    { workspace = "7";  output = [ "DP-2" "HDMI-A-1" "eDP-1" ]; }
    { workspace = "8";  output = [ "DP-2" "HDMI-A-1" "eDP-1" ]; }
    { workspace = "9";  output = [ "DP-2" "HDMI-A-1" "eDP-1" ]; }
    { workspace = "10"; output = [ "DP-2" "HDMI-A-1" "eDP-1" ]; }
  ];

  # kanshi: Output-Profile je Docking-Situation
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "mobil";
        profile.outputs = [
          { criteria = "eDP-1"; status = "enable"; }
        ];
      }
      {
        profile.name = "ein-externer";
        profile.outputs = [
          { criteria = "eDP-1"; status = "enable"; position = "0,1440"; }
          { criteria = "'Dell Inc. DELL U2518D 3C4YP8CDD3FL"; status = "enable"; position = "0,0"; }
        ];
      }
      {
        profile.name = "voll-gedockt";
        profile.outputs = [
          { criteria = "eDP-1"; status = "disable"; }   # intern aus bei zwei Externen
          { criteria = "Dell Inc. DELL U2518D 3C4YP8CDD3FL"; status = "enable"; position = "0,0"; }
          { criteria = "Dell Inc. DELL U2518D 3C4YP8C7B7AL"; status = "enable"; position = "2560,0"; }
        ];
      }
    ];
  };
}
