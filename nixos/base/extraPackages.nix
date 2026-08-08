{ self, inputs, ... }: {
  flake.nixosModules.base = { lib, ... }: {
    options.preferences.extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Host-specific packages appended to environment.systemPackages.";
    };
  };
}
