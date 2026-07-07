{ pkgs, ... }:
{
  imports = [
    ./modules/vivado_2024_2.nix
    ./modules/vivado_2026_1.nix
    ./modules/nvim.nix
    ./modules/starship.nix
    ./modules/sway.nix
    ./modules/music.nix
    ./modules/scripts.nix
    ./modules/cli.nix
  ];
  home.username = "till";
  home.homeDirectory = "/home/till";
  home.stateVersion = "26.05";

  programs.fish.enable = true;

  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;

    # Behebt Warnung 2: Schaltet die alten impliziten Standardwerte ab
    enableDefaultConfig = false;

    # Behebt Warnung 1: Nutzt das neue 'settings' statt des alten 'matchBlocks'
    settings = {
      "*" = {
        # Wichtig: Optionen müssen jetzt im SSH-typischen CamelCase (Großbuchstaben) geschrieben werden!
        AddKeysToAgent = "yes";
      };
      "github.com" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_github";
        IdentitiesOnly = true;
      };
    };
  };

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
    keepassxc
    wl-clipboard
    keepmenu
    wtype
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.keepassxc ];
  };

  home.file.".mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json".text =
    builtins.toJSON
      {
        name = "org.keepassxc.keepassxc_browser";
        description = "KeePassXC integration with native messaging support";
        path = "${pkgs.keepassxc}/bin/keepassxc-proxy";
        type = "stdio";
        allowed_extensions = [ "keepassxc-browser@keepassxc.org" ];
      };

  xdg.configFile."keepmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = fuzzel --dmenu

    [database]
    database_1 = ~/sync/keepass/Passwords.kdbx
    pw_cache_period_min = 60
    type_library = wtype
  '';

  catppuccin = {
    enable = true; # globaler Schalter für alle unterstützten Programme
    autoEnable = true;
    flavor = "mocha";
    accent = "blue"; # passt zu deinem 89b4fa-Akzent
  };

}
