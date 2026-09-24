{self,
 inputs,
 ...
}: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostLaptop
    ];
  };

  flake.nixosModules.hostLaptop = {pkgs, ...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.desktop
      self.nixosModules.locale
      self.nixosModules.packages
      self.nixosModules.niri
      self.nixosModules.ly
      self.nixosModules.laptopHardware
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

    services.xserver.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Or disable the firewall altogether.
    networking.firewall.enable = false;

    system.stateVersion = "25.11"; # Did you read the comment?
  };
}