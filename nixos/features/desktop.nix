{self, ...}: {
  flake.nixosModules.desktop = {pkgs, ...}: let 
    selfpkgs = self.packages."${pkgs.system}";
  in {
    imports = [
      self.nixosModules.gtk
    ]; 
  
    environment.systemPackages = [
      selfpkgs.terminal
      pkgs.pcmanfm
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      ubuntu-sans
      cm_unicode
      corefonts
      unifont
    ];

    fonts.fontconfig.defaultFonts ={
      serif = [ "Ubuntu Sans" ];
      sansSerif = [ "Ubuntu Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
    };

    services.upower.enable = true;

    security.polkit.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    hardware = {
      enableAllFirmware = true;
      
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;

      opengl ={
        enable = true; 
        driSupport32Bit = true;
      };
    };
  };
}
