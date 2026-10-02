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

        self'.packages.nh

        pkgs.file
        pkgs.unzip
        pkgs.zip
        pkgs.p7zip
        pkgs.wget
        pkgs.killall
        pkgs.sshfs
        pkgs.fzf
        pkgs.htop
        pkgs.btop
        pkgs.eza
        pkgs.fd
        pkgs.zoxide
        pkgs.dust
        pkgs.ripgrep
        pkgs.fastfetch
        pkgs.tree-sitter
        pkgs.imagemagick
        pkgs.imv
        pkgs.ffmpeg-full
        pkgs.yt-dlp
        pkgs.lazygit
      ];
    };
  };
}
