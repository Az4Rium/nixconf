{ self, inputs, ... }: {
  flake.nixosModules.graphics = { pkgs, lib, ... }: {
    services.xserver.videoDrivers = lib.mkDefault [ "amdgpu" ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
