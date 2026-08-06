{ self, inputs, ... }: {
  flake.nixosModules.users = { pkgs, lib, ... }: {
    users.users.alexander = {
      isNormalUser = true;
      description = "Alexander";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [
      ];
    };
  };
}
