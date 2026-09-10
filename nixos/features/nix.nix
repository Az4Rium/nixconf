{ self, inputs, ... }: {
  flake.nixosModules.nix = { pkgs, lib, ... }: {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      extra-substituters = [
        "https://nix-gaming.cachix.org"
        "https://nix-citizen.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
      ];
    };
  };
}
