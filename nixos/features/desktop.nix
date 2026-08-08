{ self, inputs, ... }: {
  flake.nixosModules.desktop = { config, pkgs, lib, ... }: {
    services.xserver.enable = true;

    services.desktopManager.gnome.enable = true;

    services.xserver.xkb = config.preferences.keymap;
  };
}
