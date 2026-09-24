{
  lib,
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.desktop = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [ self.wrappersModules.niri ];
      terminal = lib.getExe self'.packages.terminal;
      env = {
        EDITOR = lib.getExe pkgs.neovim;
      };
    };

    packages.terminal = 
      (inputs.wrappers.wrapperModules.kitty.apply {
        inherit pkgs;
        imports = [ self.wrappersModules.kitty ];
        shell = lib.getExe self'.packages.environment;
      }).wrapper;

    packages.environment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.fish;
      runtimeInputs = [
        pkgs.fzf
        pkgs.btop
        pkgs.htop
        pkgs.fd
        pkgs.busybox
      ];
    };
  };
}
