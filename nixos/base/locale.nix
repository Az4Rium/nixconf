{ self, inputs, ... }: {
  flake.nixosModules.base = { lib, ... }: {
    options.preferences = {
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/Moscow";
        description = "System timezone.";
      };

      locale = {
        defaultLocale = lib.mkOption {
          type = lib.types.str;
          default = "en_US.UTF-8";
          description = "Default system locale.";
        };

        extra = lib.mkOption {
          type = lib.types.str;
          default = "ru_RU.UTF-8";
          description = "Extra locale used for the LC_* categories.";
        };
      };
    };
  };
}
