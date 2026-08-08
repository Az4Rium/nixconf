{ self, inputs, ... }: {
  flake.nixosModules.base = { lib, ... }: {
    options.preferences.user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "alexander";
        description = "Primary user account name.";
      };

      description = lib.mkOption {
        type = lib.types.str;
        default = "Alexander";
        description = "Primary user account description (full name).";
      };
    };
  };
}
