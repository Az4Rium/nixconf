{inputs, ...}: {
  flake.nixosModules.nix = {pkgs, ...}: {
    nix.settings.experimental-features = [ "nix-command" "flakes"];
    nixpkgs.config.allowUnfree = true;
    programs.nix-ld.enable = true;
  
  };
}
