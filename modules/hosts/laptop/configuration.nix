{self,inputs,...}:{
  flake.nixosModules.laptopConfiguration = {pkgs,lib,...}: {
    imports =
    [
      self.nixosModules.laptopHardware
      self.nixosModules.stylix
      self.nixosModules.niri
      self.nixosModules.ly
    ];

  
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      efiInstallAsRemovable = true;
      extraEntries = ''
	menuentry "UEFI Firmware Settings" --class setup {
	  fwsetup
	}
      '';
    };
  };
  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
  boot.kernelPackages = pkgs.linuxPackages_testing;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  hardware.bluetooth.enable = true;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enable = true;

  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.enable = true;

  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

  };
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users.users.alexander = {
    isNormalUser = true;
    description = "Alexander";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
    ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.firefox.enable = true;
  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "electron-40.10.5" ];

  environment.systemPackages = with pkgs; [
    vim
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
  programs.throne = {
	enable = true;
	tunMode.enable = true;
  };
  virtualisation.docker.enable = true;




  networking.firewall.enable = false;
  system.stateVersion = "25.11";

  };
}
