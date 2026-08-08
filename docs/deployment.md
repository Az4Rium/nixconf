# Deployment

How to install this configuration on a new machine, and how to add a new host.

## Prerequisites

1. **NixOS installed** with the default single-disk layout (the config's `hardware.nix`
   assumes an ext4 root + EFI/boot + swap; adjust it to your disk scheme).
2. **Git** (available on the NixOS installer ISO).
3. Access to the repository (clone over HTTPS/SSH, or copy the folder).

## Adding a new machine (the intended flow)

Every machine is one directory under `nixos/hosts/<name>/`. Because of the
auto-import, dropping the directory in is all it takes to register the host —
no central registry.

1. **Get the repo** (from the installer shell):

   ```bash
   nix-shell -p git --run "git clone <your-repo-url> nixconf && cd nixconf"
   ```

2. **Generate the hardware config** for the new machine:

   ```bash
   sudo nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix nixos/hosts/<name>/hardware.nix
   ```

3. **Create the host module** `nixos/hosts/<name>/configuration.nix`:

   ```nix
   { self, inputs, ... }: {
     flake.nixosConfigurations.<name> = inputs.nixpkgs.lib.nixosSystem {
       modules = [
         self.nixosModules.host<Name>
       ];
     };

     flake.nixosModules.host<Name> = { pkgs, ... }: {
       imports = [
         self.nixosModules.base
         self.nixosModules.boot
         self.nixosModules.networking
         self.nixosModules.locale
         self.nixosModules.desktop
         self.nixosModules.audio
         self.nixosModules.graphics
         self.nixosModules.users
         self.nixosModules.nix
         self.nixosModules.packages
         # …only the features this machine needs…

         self.nixosModules.<name>Hardware   # defined below
       ];

       preferences = {
         hostName = "<name>";
         # extraPackages = with pkgs; [ …machine-specific apps… ];
       };

       system.stateVersion = "<stateVersion of the target NixOS>";
     };
   }
   ```

   The `<name>Hardware` module is already defined by `hardware.nix` (its
   `flake.nixosModules.<name>Hardware` wraps the generated file — see the laptop's
   `hardware.nix` for the shape).

4. **Install / rebuild**:

   ```bash
   # first install from the ISO
   sudo nixos-install --flake .#<name>

   # or, on an existing system
   sudo nixos-rebuild switch --flake .#<name>
   ```

## Overriding preferences per host

`nixos/base/` ships defaults; a host overrides them in its own `configuration.nix`:

```nix
preferences = {
  hostName = "mini";
  user.name = "yurii";                  # different primary user
  user.description = "Yurii";
  timeZone = "Europe/Kyiv";
  locale.defaultLocale = "uk_UA.UTF-8";
  locale.extra = "uk_UA.UTF-8";
  keymap.layout = "ua";
  extraPackages = with pkgs; [ … ];
  autostart = [ "waybar" ];
};
```

## Updating after changes

```bash
# build a single machine
sudo nixos-rebuild switch --flake ~/nixconf#laptop

# build a single wrapped program without touching the system
nix build ~/nixconf#neovim

# bump the flake inputs (nixpkgs, …)
nix flake update
```

## Gotchas

- **Untracked files are invisible.** The flake is `git+file://`, so after adding a new
  host dir, `git add` it before building, or evaluation fails.
- **Hardware specifics.** `boot.kernelPackages`, initrd/kernel modules and microcode are
  host concerns — keep them in the host's `hardware.nix`, not in shared features.
- **`flake.lock` ownership.** Rebuilding with `sudo` can leave `flake.lock` root-owned;
  run `sudo chown $USER flake.lock` if you want to edit it without sudo.
