# NixOS Configuration

A flake-based NixOS configuration for a single-host setup (`laptop`, AMD, GNOME on X11),
built around [flake-parts](https://github.com/hercules-ci/flake-parts), the
[wrappers](https://github.com/Lassulus/wrappers) /
[wrapper-modules](https://github.com/BirdeeHub/nix-wrapper-modules) framework for declarative
program configuration, and [stylix](https://github.com/danth/stylix) for theming.

## Quick start

```bash
# Build / rebuild the system
sudo nixos-rebuild switch --flake ~/nixconf#laptop

# Build a single wrapped program
nix build ~/nixconf#neovim

# Run the "dynamic" (impure) neovim — reads lua/ directly from the repo
nix run ~/nixconf#neovimDynamic

# Update flake inputs
nix flake update
```

> **Git gotcha:** the flake is loaded with `git+file://`, so **only tracked files are
> copied into the Nix store**. After adding a new file, run `git add` in the repo or the
> flake evaluation will fail with a "missing attribute" error.

## Structure

```
nixconf/
├── flake.nix                      # inputs + auto-import of every *.nix file
├── flake.lock
├── parts.nix                      # flake-parts bootstrap, supported systems
├── theme.nix                      # shared 16-color palette (base16-ish)
├── nixos/
│   ├── features/                  # reusable NixOS modules (each declares flake.nixosModules.*)
│   └── hosts/
│       └── laptop/
│           ├── configuration.nix  # wires the feature modules together
│           └── hardware.nix       # disk layout, kernel modules, microcode
└── wrappedPrograms/               # declarative program configs (perSystem packages + modules)
    ├── fish.nix                   # fish + zoxide prompt
    ├── kitty.nix                  # terminal, themed from theme.nix
    ├── ly.nix                     # display manager, themed from stylix
    ├── niri.nix                   # wayland compositor
    └── neovim/
        ├── neovim.nix             # main neovim wrapper module (2 packages)
        ├── lsp.nix                # per-language LSP modules
        └── lua/                   # runtime Lua config (see docs/neovim.md)
```

### Auto-import

`flake.nix` recursively imports every `.nix` file in the repo except `flake.nix` itself and
files whose name starts with `_`. Each file returns a flake-parts module declaring either:

- `flake.nixosModules.<name>` — NixOS modules
- `flake.modules.<namespace>.<name>` — wrapper-modules used by wrapped programs
- `perSystem.packages.<name>` — standalone wrapped packages
- `flake.<attr>` — plain flake outputs (e.g. `flake.theme`)

## Inputs

| Input             | Follows nixpkgs | Purpose                              |
| ----------------- | --------------- | ------------------------------------ |
| `nixpkgs`         | —               | `nixos-unstable`                     |
| `flake-parts`     | —               | flake module framework               |
| `wrappers`        | ✔               | low-level `wrapPackage` helper       |
| `wrapper-modules` | ✔               | typed settings/specs for programs    |
| `stylix`          | ✔               | system-wide theming                  |

## Theming

- `theme.nix` defines a hand-tuned 16-color base16 palette plus semantic colors
  (`bg`, `fg`, `accent`, …) and exposes them as `flake.theme` / `flake.themeNoHash`.
  Wrapped programs read it directly (e.g. `kitty.nix` uses `self.theme.base00` …).
- `stylix` generates the base16 scheme from `ayu-dark.yaml` and writes
  `/etc/stylix/palette.json` (hex values **without** `#`). Neovim and the display
  manager consume this palette at runtime — see `docs/neovim.md`.

## NixOS feature modules (`nixos/features/`)

| Module        | Summary                                                              |
| ------------- | -------------------------------------------------------------------- |
| `boot`        | GRUB (UEFI removable), testing kernel, `userns_clone` sysctl          |
| `networking`  | NetworkManager (wifi powersave off), Bluetooth                        |
| `locale`      | `Europe/Moscow`, `en_US.UTF-8` + `ru_RU` extra locales                |
| `desktop`     | X11 + GNOME                                                          |
| `printing`    | CUPS                                                                 |
| `audio`       | PipeWire (+ ALSA 32bit, PulseAudio compat, rtkit)                     |
| `graphics`    | AMD (`amdgpu`) with 32-bit support                                   |
| `users`       | user `alexander` (networkmanager, wheel, docker)                      |
| `nix`         | flakes + `nix-command` experimental features                         |
| `packages`    | firefox, steam, allowed unfree, system packages, `EDITOR=neovim`      |
| `throne`      | Throne proxy (`tunMode`)                                            |
| `docker`      | Docker daemon                                                       |
| `firewall`    | disabled                                                            |
| `stylix`      | ayu-dark scheme, JetBrainsMono Nerd Font, Bibata cursor              |
| `laptopHardware` | NVMe/EFI mounts, swap, AMD microcode                              |

Host `laptop` (`nixos/hosts/laptop/configuration.nix`) imports all of the above plus
`niri` and `ly`, with `system.stateVersion = "25.11"`.

## Wrapped programs (`wrappedPrograms/`)

Configuration is declared in Nix (typed via wrapper-modules) and the resulting binaries are
exposed as flake packages.

| Program | Package(s)         | Highlights                                                        |
| ------- | ------------------ | ----------------------------------------------------------------- |
| fish    | `#fish`            | zoxide, custom prompt, vi keybindings, lf, direnv hook            |
| kitty   | `#myKitty`         | themed from `theme.nix`, fish shell, cursor trail                 |
| ly      | (display manager)  | themed from stylix colors                                         |
| niri    | (compositor)       | full keybinds, 10 workspaces, xwayland-satellite, stylix focus    |
| neovim  | `#neovim`, `#neovimDynamic` | lz.n plugin manager, per-language LSP, stylix palette   |

### niri keybindings

`Mod` = Super/Win. Layout `us,ru` toggled with `Alt+Shift`.

| Keys               | Action                         |
| ------------------ | ------------------------------ |
| `Mod+Return`       | spawn kitty                    |
| `Mod+Space`        | launcher (`qs ipc`)            |
| `Mod+M`            | power menu (`qs ipc`)          |
| `Mod+Q`            | close window                   |
| `Mod+F` / `Mod+G`  | maximize column / fullscreen   |
| `Mod+Shift+F`      | toggle floating                |
| `Mod+H/J/K/L`      | focus window                   |
| `Mod+Shift+H/J/K/L`| move window                    |
| `Mod+Ctrl+H/J/K/L` | resize (column/height)         |
| `Mod+[` / `Mod+]`  | consume / expel window         |
| `Mod+1..0`         | workspaces `w0`–`w9`           |
| `Mod+Shift+1..0`   | move window to workspace       |
| `Mod+Wheel`        | focus column left/right        |
| Media keys         | `wpctl` volume / `brightnessctl` brightness |

## Neovim

See **[docs/neovim.md](docs/neovim.md)** for the full documentation: package setup,
dynamic-mode workflow, LSP server modules, plugins and keymaps.
