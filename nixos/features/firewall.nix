{ self, inputs, ... }: {
  flake.nixosModules.firewall = { pkgs, lib, ... }: {
    networking.firewall.enable = false;
  };
}
