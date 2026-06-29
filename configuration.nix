# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #<home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-d333bd83-affe-4e99-9123-60081b678914".device = "/dev/disk/by-uuid/d333bd83-affe-4e99-9123-60081b678914";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


 # 2. Home Manager systemweit konfigurieren
  #home-manager.useGlobalPkgs = true;
  #home-manager.useUserPackages = true;

  # 3. Konfiguration für deinen spezifischen User (z.B. "deinusername")
  #home-manager.users.till = { pkgs, ... }: {
    #home.stateVersion = "26.05"; # Muss mit deiner NixOS-Version übereinstimmen

    # Pakete, die nur für diesen User installiert werden
    #home.packages = with pkgs; [
    #  htop
    #];

        # Dotfiles / Programme über Home Manager verwalten
#    programs.git = {
#      enable = true;
#      userName = "Till";
#      userEmail = "fubar@email.de";
#    };
#  };


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
  
  # Ensure Firefox is installed using the module


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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
     btop

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

  # ... viele andere, bereits vorhandene Zeilen Ihres Systems ...

  # Hier fügen Sie den neuen Code ein:
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

} 
