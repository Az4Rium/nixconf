# NixOS Feature Modules

Every `.nix` file under `nixos/` declares one or more `flake.nixosModules.*`. The host
`configuration.nix` imports exactly the modules it wants. This page documents each one.

## `base` (from `nixos/base/`)

The default layer. Several files contribute options to the single `base` module; it
defines **options only** — features/hosts consume them via `config.preferences.*`.

| Option | Type | Default | Used by |
| ------ | ---- | ------- | ------- |
| `preferences.user.name` | str | `"alexander"` | `users` |
| `preferences.user.description` | str | `"Alexander"` | `users` |
| `preferences.hostName` | str | `"laptop"` | `networking` |
| `preferences.keymap.layout` | str | `"us"` | `desktop` |
| `preferences.keymap.variant` | str | `""` | `desktop` |
| `preferences.timeZone` | str | `"Europe/Moscow"` | `locale` |
| `preferences.locale.defaultLocale` | str | `"en_US.UTF-8"` | `locale` |
| `preferences.locale.extra` | str | `"ru_RU.UTF-8"` | `locale` (all `LC_*`) |
| `preferences.autostart` | list of str/pkg | `[]` | hook for WM/DE autostart |
| `preferences.extraPackages` | list of pkg | `[]` | `packages` |

The `base` module is always imported by hosts; machines override these defaults in their
own `configuration.nix`.

## Feature modules

### `audio`
PipeWire with ALSA (incl. 32-bit), PulseAudio compatibility, and `rtkit`.
Disables PulseAudio.

### `boot`
GRUB (UEFI, removable media, `fwsetup` entry), `canTouchEfiVariables = false`,
`kernel.unprivileged_userns_clone = 1` sysctl, and `linuxPackages_testing`.
Boot entries/mounts are **not** here — they live in the host's `hardware.nix`.

### `desktop`
X11 + GNOME desktop manager. Keyboard layout comes from
`config.preferences.keymap` (`us`, no variant by default).

### `docker`
Enables the Docker daemon (`virtualisation.docker.enable`). The user is a member of the
`docker` group via `users`.

### `firewall`
Disables `networking.firewall`. This is a deliberate, machine-wide trade-off —
evaluate it before reusing on an untrusted network.

### `graphics`
`services.xserver.videoDrivers = [ "amdgpu" ]` (via `mkDefault`), hardware acceleration
with 32-bit support.

### `locale`
`time.timeZone` from `preferences.timeZone`, default locale from
`preferences.locale.defaultLocale`, and all `LC_*` categories set to
`preferences.locale.extra`. Input method framework is enabled (empty config — extend as
needed).

### `networking`
NetworkManager (wifi powersave off), Bluetooth enabled. `networking.hostName` defaults
to `preferences.hostName` via `mkDefault`.

### `nix`
Enables `nix-command` and `flakes` experimental features.

### `packages`
- `programs.firefox`, `programs.steam`
- `allowUnfree`, plus `electron-40.10.5` in `permittedInsecurePackages`
- Base `environment.systemPackages` (neovim, git, curl, wget, vscodium, python3+tkinter,
  distrobox, gcc, btop, htop, docker-compose, opencode, libreoffice, lan-mouse, busybox,
  cifs-utils, obsidian, ollama, qbittorrent, …) **plus** `config.preferences.extraPackages`
- `EDITOR` set to the wrapped neovim

Machine-specific apps (wine/gaming, v2rayn, …) live in the **host** via
`preferences.extraPackages`, not here.

### `printing`
Enables CUPS (`services.printing.enable`).

### `stylix`
Stylix theming: `ayu-dark` base16 scheme, JetBrainsMono Nerd Font (mono + sans), Bibata
cursor. Writes `/etc/stylix/palette.json` consumed by neovim and the display manager.

### `users`
Creates the primary user from `preferences.user.name` / `preferences.user.description`,
member of `networkmanager`, `wheel`, `docker`. (No password set here — use `passwd` or a
host-level `initialHashedPassword`.)

## Host modules

### `<host>Hardware` (e.g. `laptopHardware`, from `hosts/<name>/hardware.nix`)
Wraps the output of `nixos-generate-config` for the machine: `fileSystems`, `swapDevices`,
initrd/kernel modules, `nixpkgs.hostPlatform`, CPU microcode. This is the only
machine-specific file that should ever be edited during a port.

### `<host>` (from `hosts/<name>/configuration.nix`)
Declares `flake.nixosConfigurations.<name>` and imports the features the machine needs,
sets `preferences.*` overrides and `system.stateVersion`. See `docs/deployment.md` for the
template.
