{ self, inputs, ... }: {
  flake.nixosModules.throne = { pkgs, lib, ... }: {
    programs.throne = {
      enable = true;
      tunMode.enable = true;
    };
  };
}
