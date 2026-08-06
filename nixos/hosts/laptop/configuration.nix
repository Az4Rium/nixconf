{ self, inputs, ... }: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostLaptop
    ];
  };

  flake.nixosModules.hostLaptop = {
    imports = [
      self.nixosModules.boot
      self.nixosModules.networking
      self.nixosModules.locale
      self.nixosModules.desktop
      self.nixosModules.printing
      self.nixosModules.audio
      self.nixosModules.graphics
      self.nixosModules.users
      self.nixosModules.nix
      self.nixosModules.packages
      self.nixosModules.throne
      self.nixosModules.docker
      self.nixosModules.firewall
      self.nixosModules.stylix
      self.nixosModules.niri
      self.nixosModules.ly
      self.nixosModules.laptopHardware
    ];
    system.stateVersion = "25.11";
  };
}
