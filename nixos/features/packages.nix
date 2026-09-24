{inputs, ...}: {
  flake.nixosModules.packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      firefox
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      curl
      git
      gcc
      v2rayn
      vscodium
      steam
      busybox
      cifs-utils
      prismlauncher
    ];  
  };
}
