# Structure & Flake Mechanics

How the flake is organized, how files get picked up, and where each layer lives.

## Auto-import (the dendritic pattern)

`flake.nix` walks the whole repository recursively and imports **every `.nix` file**
except:

- `flake.nix` itself
- any file whose name starts with `_` (use this for files you want in the repo
  but **not** evaluated, e.g. `_drafts/`, `_secrets.nix`)

Each imported file returns a **flake-parts module**, which may declare:

| Declared as | Produces |
| ----------- | -------- |
| `flake.nixosModules.<name>` | a NixOS module (`nixos/features/*`, `nixos/base/*`, hosts) |
| `perSystem.packages.<name>` | a standalone flake package (`wrappedPrograms/*`) |
| `flake.modules.<ns>.<name>` | a wrapper-modules spec used by wrapped programs |
| `flake.<attr>` | plain flake outputs (e.g. `flake.theme`, `flake.nixosConfigurations`) |

Because importing is recursive and implicit, **adding a file is enough to register it** —
there is no central list to update. Two files that set the same `flake.nixosModules.<name>`
are **merged** by flake-parts. This is how the `base` module is assembled from several
files in `nixos/base/`.

## Directory map

```
nixconf/
├── flake.nix                      # inputs + the auto-import function
├── flake.lock
├── parts.nix                      # flake-parts bootstrap; supported systems
├── theme.nix                      # shared 16-color palette -> flake.theme
├── README.md
├── docs/                          # this documentation
│   ├── structure.md               # you are here
│   ├── deployment.md              # installing on a new machine
│   ├── features.md                # NixOS modules, one page per feature
│   ├── wrapped-programs.md        # program configs built with wrappers
│   └── neovim.md                  # neovim build & lua config
├── nixos/
│   ├── base/                      # default preferences (all merge into `base`)
│   │   ├── user.nix               #   preferences.user.{name,description}
│   │   ├── hostname.nix           #   preferences.hostName
│   │   ├── keymap.nix             #   preferences.keymap.{layout,variant}
│   │   ├── locale.nix             #   preferences.timeZone, preferences.locale.*
│   │   ├── autostart.nix          #   preferences.autostart
│   │   └── extraPackages.nix      #   preferences.extraPackages
│   ├── features/                  # reusable NixOS modules
│   │   ├── audio.nix, boot.nix, desktop.nix, docker.nix, firewall.nix,
│   │   ├── graphics.nix, locale.nix, networking.nix, nix.nix,
│   │   ├── packages.nix, printing.nix, stylix.nix, users.nix
│   └── hosts/
│       └── laptop/                # one directory per machine
│           ├── configuration.nix  # imports features + host preferences
│           └── hardware.nix       # disk layout, kernel modules, microcode
└── wrappedPrograms/
    ├── fish.nix                   # #fish
    ├── kitty.nix                  # #myKitty
    ├── ly.nix                     # flake.nixosModules.ly (display manager)
    ├── niri.nix                   # flake.nixosModules.niri (compositor)
    └── neovim/                    # #neovim, #neovimDynamic (see docs/neovim.md)
```

## `parts.nix`

Bootstraps flake-parts and imports two flake modules:

- `wrapper-modules.flakeModules.wrappers` — enables the wrapper system
- `flake-parts.flakeModules.modules` — enables the `flake` namespace (what lets files
  declare `flake.nixosModules.*`, `flake.nixosConfigurations.*`, …)

Also declares the `systems` list (`x86_64-linux` + darwin/aarch64). Per-system outputs
are only evaluated for these systems.

## The `base` module & `preferences.*`

All files in `nixos/base/` define the **same** module `flake.nixosModules.base`;
flake-parts merges them into one module that only declares options (with defaults) —
no config of its own. Features then read these options via `config.preferences.*`.
This is what makes the configuration portable: a host overrides a preference instead of
editing shared modules.

See `docs/features.md` → *base* for the full option list and defaults.

## `theme.nix`

A hand-tuned 16-color base16 palette plus semantic colors (`bg`, `fg`, `accent`, …).
Exposed as `flake.theme` / `flake.themeNoHash` so wrapped programs can reference it
directly (e.g. `kitty.nix` sets `background = self.theme.bg`). System-wide theming on
top of this is provided by **stylix** (`nixos/features/stylix.nix`), which renders an
`ayu-dark` scheme to `/etc/stylix/palette.json` (hex values without `#`) for programs
that read it at runtime (neovim, ly).

## The wrapper system

`wrappedPrograms/*` build real binaries whose config is **declared in Nix** instead of
read from dotfiles. Two mechanisms:

- **`inputs.wrappers`** (Lassulus/wrappers) — low-level `wrapPackage`: wraps a package
  and injects runtime inputs + flags (see `fish.nix`).
- **`inputs.wrapper-modules`** (BirdeeHub/nix-wrapper-modules) — typed specs with
  `settings`, one per program (see `kitty.nix`, `niri.nix`). These are also importable
  as NixOS modules (kitty/niri) or standalone packages.

## Notes

- The flake is loaded with `git+file://`, so **only tracked files exist in the store**.
  After adding any file, `git add` it or evaluation fails with a missing-attribute error.
- `flake.lock` may be owned by `root` after a root rebuild; editing it may need `sudo`.
