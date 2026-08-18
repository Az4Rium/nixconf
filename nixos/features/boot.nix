{ self, inputs, ... }: {
  flake.nixosModules.boot = { pkgs, lib, ... }: {
    boot.loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        efiInstallAsRemovable = true;
        extraEntries = ''
	menuentry "UEFI Firmware Settings" --class setup {
	  fwsetup
	}
        '';
      };
    };
    boot.loader.efi.canTouchEfiVariables = false;
    boot.kernel.sysctl = {
      "kernel.unprivileged_userns_clone" = 1;
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
    };
    boot.kernelPackages = pkgs.linuxPackages_testing;
  };
}
