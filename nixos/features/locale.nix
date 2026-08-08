{ self, inputs, ... }: {
  flake.nixosModules.locale = { config, pkgs, lib, ... }: {
    time.timeZone = lib.mkDefault config.preferences.timeZone;

    i18n.defaultLocale = lib.mkDefault config.preferences.locale.defaultLocale;
    i18n.inputMethod = {
      enable = true;

    };

    i18n.extraLocaleSettings =
      lib.genAttrs [
        "LC_ADDRESS"
        "LC_IDENTIFICATION"
        "LC_MEASUREMENT"
        "LC_MONETARY"
        "LC_NAME"
        "LC_NUMERIC"
        "LC_PAPER"
        "LC_TELEPHONE"
        "LC_TIME"
      ] (_: config.preferences.locale.extra);
  };
}
