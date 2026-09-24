{self,
 inputs,
 ...
}: {
  flake.nixosModules.laptopConfiguration = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.hostLaptop
    ];
  };

  flake.nixosModules.hostMain = {pkgs, ...}: {
    imports = [
        self.nixosModules.desktop
        self.nixosModules.general
        self.nixosModules.laptopHardware
        self.nixosModules.ly
        self.nixosModules.base
    ];

    # Bootloader.
    boot.loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        efiInstallAsRemovable = true;
      };
    };
    boot.loader.efi.canTouchEfiVariables = false;
    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_testing;

    networking.hostName = "nixos"; # Define your hostname.
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.powersave = false;

    # Set your time zone.

    # Select internationalisation properties.

    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    # services.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = sin 2xtrue;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    # Install firefox.
    # programs.firefox.enable = true;

    # Allow unfree packages

    # List packages installed in system psin 2xrofile. To search, run:
    # $ nix search wget
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
    networking.firewall.enable = false;

    system.stateVersion = "25.11"; # Did you read the comment?
     
  };
}
