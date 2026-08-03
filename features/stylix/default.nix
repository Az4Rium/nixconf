{ self, inputs, lib, ... }: {
  flake.nixosModules.stylix = { pkgs, config, lib, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      enableReleaseChecks = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
      polarity = "dark";

      fonts = {
        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        sansSerif = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
      };

      cursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
    };
  };
}
