{ self, inputs, ... }: {
  flake.nixosModules.base = { lib, ... }: {
    options.preferences.hostName = lib.mkOption {
      type = lib.types.str;
      default = "laptop";
      description = "Networking hostname used for the machine.";
    };
  };
}
