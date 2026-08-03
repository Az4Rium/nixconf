{ self, inputs, lib, ... }: {
  flake.nixosModules.ly = { config, lib, ... }: {
    services.displayManager.ly = {
      enable = true;
      settings = let
        colors = config.lib.stylix.colors;
      in {
        bg = "0x00${colors.base00}";
        fg = "0x00${colors.base05}";
        error_fg = "0x01${colors.base08}";
        error_bg = "0x00${colors.base00}";
        border_fg = "0x00${colors.base0F}";
      };
    };
  };
}
