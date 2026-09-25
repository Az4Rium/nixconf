{ self, inputs, lib, ... }: {
  flake.nixosModules.ly = { ... }: {
    services.displayManager.ly = {
      enable = true;
      settings = {
        bg = "0x00${self.themeNoHash.base00}";
        fg = "0x00${self.themeNoHash.base06}";
        error_fg = "0x01${self.themeNoHash.base08}";
        error_bg = "0x00${self.themeNoHash.base00}";
        border_fg = "0x00${self.themeNoHash.base07}";
        animation = "./blackhole-smooth-240x67.dur";
      };
    };
  };

#  perSystem = { pkgs, ... }: let
#    configIni = pkgs.writeText "ly-config.ini" ''
#      [ly]
#      bg = 0x00${self.themeNoHash.bg}
#      fg = 0x00${self.themeNoHash.fg}
#      error_fg = 0x01${self.themeNoHash.error}
#      error_bg = 0x00${self.themeNoHash.bg}
#      border_fg = 0x00${self.themeNoHash.accent}
#    '';
#  in {
#    packages.ly = inputs.wrappers.lib.wrapPackage {
#      inherit pkgs;
#      package = pkgs.ly;
#      flags = {
#        "-c" = "${configIni}";
#      };
#    };
#  };
}
