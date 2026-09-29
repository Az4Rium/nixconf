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

    #For mt7902 to work properly
    boot.kernelParams = [ "mt7921e.disable-aspm=Y" ];
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.powersave = false;
    hardware.bluetooth = {
        enable = true; 
        powerOnBoot = true;
        settings = {
            General = {
                ControllerMode = "dual" ;
                FastConnectable = "true";
            };
        };
    };


    services.xserver.enable = true;
    services.timesyncd.enable = true;
    networking.hostName = "Alexander_laptop"; # Define your hostname.

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
