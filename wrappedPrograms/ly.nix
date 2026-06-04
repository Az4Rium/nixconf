{ self, inputs, lib, ... }: {
  flake.nixosModules.ly = { ... }: {
    services.displayManager.ly = {
      enable = true;
      settings = {
        bg = "0x00${self.themeNoHash.bg}";
        fg = "0x00${self.themeNoHash.fg}";
        error_fg = "0x01${self.themeNoHash.error}";
        error_bg = "0x00${self.themeNoHash.bg}";
        border_fg = "0x00${self.themeNoHash.accent}";
      };
    };
  };

  perSystem = { pkgs, ... }: let
    configIni = pkgs.writeText "ly-config.ini" ''
      [ly]
      bg = 0x00${self.themeNoHash.bg}
      fg = 0x00${self.themeNoHash.fg}
      error_fg = 0x01${self.themeNoHash.error}
      error_bg = 0x00${self.themeNoHash.bg}
      border_fg = 0x00${self.themeNoHash.accent}
    '';
  in {
    packages.ly = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.ly;
      flags = {
        "-c" = "${configIni}";
      };
    };
  };
}
