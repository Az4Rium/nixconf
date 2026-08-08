{ self, inputs, ... }: {
  flake.nixosModules.networking = { config, pkgs, lib, ... }: {
    networking.hostName = lib.mkDefault config.preferences.hostName;
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.powersave = false;
    hardware.bluetooth.enable = true;
  };
}
