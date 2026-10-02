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
#      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen5
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

    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.powersave = true;
    hardware.bluetooth.enable = true;
    # hardware.bluetooth = {
    #     enable = true; 
    #     powerOnBoot = true;
    #     # settings = {
    #     #     General = {
    #     #         ControllerMode = "dual" ;
    #     #         FastConnectable = "true";
    #     #     };
    #     #};
    # };
    hardware.trackpoint = {
      enable = true; 
      sensitivity = 100;
      speed = 70;
    };

    security.pam.services = {
        greetd.fprintAuth = true; 
        login.fprintAuth = true;
        sudo.fprintAuth = true;
    };
    services.xserver.enable = true;
    services.timesyncd.enable = true;
    networking.hostName = "Alexander_laptop"; # Define your hostname.
    services.fprintd.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
    services.fwupd.enable = true;
    services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="power_suppy", KERNEL=="BAT0", \
        RUN+="${pkgs.bash}/bin/bash -c 'chown -R root:users /sys/class/power_supply/BAT0/ && chmod -R g+w /sys/class/power_supply/BAT0"
    '';
    powerManagement.resumeCommands = ''
      modprobe -r ath11k_pci || true 
      modprobe ath11k_pci || true 
    '';

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
