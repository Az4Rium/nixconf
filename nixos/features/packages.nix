{ self, inputs, ... }: {
  flake.nixosModules.packages = { pkgs, lib, ... }: {
    programs.firefox.enable = true;
    programs.steam.enable = true;

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [ "electron-40.10.5" ];

    environment.systemPackages = with pkgs; [
      self.packages.${pkgs.stdenv.hostPlatform.system}.neovim 
      wget
      curl
      git
      vscodium
      (python3.withPackages(ps: [ps.tkinter]))
      distrobox
      gcc
      winboat
      bottles-unwrapped
      wine
      v2rayn
      wine64Packages.stagingFull
      btop
      htop
      lutris
      file-roller

      docker-compose
      opencode
      libreoffice-fresh
      lan-mouse
      busybox
      cifs-utils
      prismlauncher

      obsidian
      ollama
      qbittorrent
    ];
    environment.variables.EDITOR = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
  };
}
