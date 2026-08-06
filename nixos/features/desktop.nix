{ self, inputs, ... }: {
  flake.nixosModules.desktop = { pkgs, lib, ... }: {
    services.xserver.enable = true;

    services.desktopManager.gnome.enable = true;

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
