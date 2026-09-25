# ly.nix
{ self, inputs, lib, ... }: {
  flake.nixosModules.ly = { config, pkgs, ... }: {
    services.displayManager.ly = {
      enable = true;
    };

    # Import your custom animation
    environment.etc."ly/animations/custom.dur".source = ./blackhole-smooth-240x67.dur;

    # Set the animation in config
    environment.etc."ly/config.ini".text = ''
      [general]
      bg = 0x${self.themeNoHash.base00}
      fg = 0x${self.themeNoHash.base07}
      error_fg = 0x${self.themeNoHash.base08}
      error_bg = 0x${self.themeNoHash.base00}
      border_fg = 0x${self.themeNoHash.base0A}
      animation = custom
      load = true
      clock = %A %B %d
    '';

    services.xserver.enable = true;
  };

  perSystem = { pkgs, ... }: {
    packages.ly = pkgs.ly;
  };
}

