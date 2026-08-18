{ self, inputs, ... }: {
  flake.nixosModules.packages = { config, pkgs, lib, ... }: {
    programs.firefox.enable = true;
    programs.steam.enable = true;

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [ "electron-40.10.5" ];

    environment.systemPackages = with pkgs; [
      self.packages.${pkgs.stdenv.hostPlatform.system}.neovim 
      wget
      curl
      git
      gh
      vscodium
      (python3.withPackages(ps: [ps.tkinter]))
      distrobox
      gcc
      btop
      htop
      file-roller
      lug-helper

      docker-compose
      opencode
      libreoffice-fresh
      lan-mouse
      busybox
      cifs-utils

      obsidian
      ollama
      qbittorrent
    ] ++ config.preferences.extraPackages;
    environment.variables.EDITOR = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
  };
}
