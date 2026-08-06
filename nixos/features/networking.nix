{ self, inputs, ... }: {
  flake.nixosModules.networking = { pkgs, lib, ... }: {
    networking.hostName = lib.mkDefault "nixos";
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.powersave = false;
    hardware.bluetooth.enable = true;
  };
}
