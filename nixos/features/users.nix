{ self, inputs, ... }: {
  flake.nixosModules.users = { config, pkgs, lib, ... }: {
    users.users.${config.preferences.user.name} = {
      isNormalUser = true;
      description = config.preferences.user.description;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [
      ];
    };
  };
}
