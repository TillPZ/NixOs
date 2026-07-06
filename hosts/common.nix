{ pkgs, ... }:
{

  imports =
    [ # Include the results of the hardware scan.
      ../modules/sway-system.nix
    ];



  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };


  # Enable hardware graphics acceleration
  hardware.graphics = {
    enable = true;
    # Extra packages based on your GPU (e.g., intel-media-driver, nvidia-vaapi-driver)
    # extraPackages = with pkgs; [ intel-media-driver nvidia-vaapi-driver ]; 
  };

  services.libinput.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    #alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."till" = {
    isNormalUser = true;
    description = "Till";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget
     git
     vim
     distrobox
     neovim
     distrobox
     git
     gnumake
     gcc
     ripgrep
     unzip
     eza
     fd
     vscode

  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # 2. Nerd Fonts installieren (Moderne Syntax ab NixOS 24.11 / 25.05)
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # Nützlich: Globale Shell-Aliase für eza definieren
  environment.shellAliases = {
    ls = "eza --icons --group-directories-first";
    ll = "eza -lah --icons --git";
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  # 1. Schaltet das Fish-Systemmodul frei
  programs.fish.enable = true;

  # 2. Setzt Fish als Standard-Shell für alle normalen Benutzer
  users.defaultUserShell = pkgs.fish;

  # =========================================================================
  # HIER REINKOPIEREN (z. B. am Ende der Datei vor der letzten Klammer)
  # =========================================================================
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "52-xilinx-jtag.rules";
      text = ''
        # Regeln für Digilent / Xilinx JTAG-Kabel
        ATTR{idVendor}=="1443", MODE:="666"
        ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
        ACTION=="add", ATTR{idVendor}=="03fd", MODE:="666"
      '';
      destination = "/etc/udev/rules.d/52-xilinx-jtag.rules";
    })
  ];
  # =========================================================================

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


# hierher wandern die geteilten Zeilen
}
