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
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen5
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
#     boot.extraModprobeConfig = ''
#       options ath11k_pci disable_idle_ps=1
#     '';

  # 1. Essential firmware configuration for ThinkPad hardware coexistence
  hardware.enableRedistributableFirmware = true;

  # 2. Adjust kernel parameters to keep the AMD PCIe/USB link awake 
  boot.kernelParams = [ "pcie_aspm=force" ];

  # 3. Dedicated systemd services for the T14 Gen 5 Qualcomm card
  systemd.services.ath11k-hibernate = {
    description = "Disconnect ath11k interface safely before hibernation";
    before = [ "systemd-suspend.service" "systemd-hibernate.service" "suspend.target" "hibernate.target" ];
    wantedBy = [ "systemd-suspend.service" "systemd-hibernate.service" "suspend.target" "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      # Unload ONLY the top-level driver wrapper, leaving MHI and USB subsystems fully powered
      ExecStart = "${pkgs.kmod}/bin/modprobe -r ath11k_pci"; 
      TimeoutSec = "10s";
    };
  };

  systemd.services.ath11k-resume = {
    description = "Reinitialize ath11k and synchronize USB Bluetooth upon wake";
    after = [ "systemd-suspend.service" "systemd-hibernate.service" "suspend.target" "hibernate.target" ];
    wantedBy = [ "systemd-suspend.service" "systemd-hibernate.service" "suspend.target" "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      # Reload the Wi-Fi driver, then cycle the USB Bluetooth driver to re-establish coexistence
      ExecStart = ''
        ${pkgs.kmod}/bin/modprobe ath11k_pci
        ${pkgs.kmod}/bin/modprobe -r btusb
        ${pkgs.kmod}/bin/modprobe btusb
      '';
    };
  };
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
    services.power-profiles-daemon = {
        enable = true;
    };
    #services.fwupd.enable = true;
    services.upower.enable = true;
    services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="power_suppy", KERNEL=="BAT0", \
        RUN+="${pkgs.bash}/bin/bash -c 'chown -R root:users /sys/class/power_supply/BAT0/ && chmod -R g+w /sys/class/power_supply/BAT0"
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
