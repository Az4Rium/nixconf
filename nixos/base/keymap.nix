{ self, inputs, ... }: {
  flake.nixosModules.base = { lib, ... }: {
    options.preferences.keymap = lib.mkOption {
      type = lib.types.submodule {
        options = {
          layout = lib.mkOption {
            type = lib.types.str;
            default = "us";
            description = "X11 keyboard layout.";
          };

          variant = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "X11 keyboard layout variant.";
          };
        };
      };
      default = {};
      description = "Keyboard layout used by the desktop environment.";
    };
  };
}
