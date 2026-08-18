{ self, inputs, ... }: {
  flake.nixosModules.star-citizen = { pkgs, lib, ... }: {
    imports = [ inputs.nix-citizen.nixosModules.StarCitizen ];

    programs.rsi-launcher = {
      enable = true;
      patchXwayland = true;
      gamescope.enable = false;
      umu.enable = false;
    };
  };
}
