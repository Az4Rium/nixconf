{ self, inputs, ... }: {
  flake.nixosModules.printing = { pkgs, lib, ... }: {
    services.printing.enable = true;
  };
}
