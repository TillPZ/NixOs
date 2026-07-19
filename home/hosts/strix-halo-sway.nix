{ ... }:
{
  # Workspaces: Prioritätslisten statt statisch —
  # Sway nimmt den ersten vorhandenen Output der Liste, dynamisch bei An-/Abstecken
  wayland.windowManager.sway.config.workspaceOutputAssign = [
    # 1-5: bevorzugt externer Monitor 1, sonst intern
    { workspace = "1";  output = [ "DP-9" ]; }
    { workspace = "2";  output = [ "DP-9" ]; }
    { workspace = "3";  output = [ "DP-9" ]; }
    { workspace = "4";  output = [ "DP-9" ]; }
    { workspace = "5";  output = [ "DP-9" ]; }
    # 6-10: bevorzugt externer Monitor 2, sonst externer 1, sonst intern
    { workspace = "6";  output = [ "DP-10" ]; }
    { workspace = "7";  output = [ "DP-10" ]; }
    { workspace = "8";  output = [ "DP-10" ]; }
    { workspace = "9";  output = [ "DP-10" ]; }
    { workspace = "10"; output = [ "DP-10" ]; }
  ];

    services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "standard";
        profile.outputs = [
          { criteria = "Dell Inc. DELL U2518D 3C4YP8CDD3FL"; status = "enable"; position = "0,0"; }
          { criteria = "Dell Inc. DELL U2518D 3C4YP8C7B7AL"; status = "enable"; position = "2560,0"; }
        ];
      }
    ];
  };
}
