{ self, inputs, lib, ... }: {
  flake.nixosModules.ly = { ... }: {
    services.displayManager.ly = {
      enable = true;
      settings = {
        bg = "0x00${self.themeNoHash.base00}";
        fg = "0x00${self.themeNoHash.base07}";
        error_fg = "0x01${self.themeNoHash.base08}";
        error_bg = "0x00${self.themeNoHash.base00}";
        border_fg = "0x00${self.themeNoHash.base0A}";
      };
    };
  };

  perSystem = { pkgs, ... }: let
    configIni = pkgs.writeText "ly-config.ini" ''
      [ly]
      bg = 0x00${self.themeNoHash.base00}
      fg = 0x00${self.themeNoHash.base07}
      error_fg = 0x01${self.themeNoHash.base08}
      error_bg = 0x00${self.themeNoHash.base00}
      border_fg = 0x00${self.themeNoHash.base0A}
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
