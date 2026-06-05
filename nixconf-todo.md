# NixConf — Master TODO

## Conventions

| Prefix | Meaning |
|--------|---------|
| `[BASE]` | `nixos/base/*` — option declarations |
| `[FEAT]` | `nixos/features/*` — implementations |
| `[PCK]` | `wrappedPrograms/*` — package wrappers |
| `[HOST]` | `nixos/hosts/*` — host-specific |
| `[THM]` | `theme.nix` — theme |

---

## Phase 0: Create example reference

- [ ] 0.1 Create `~/nixconf-example/` with full extracted module structure
- [ ] 0.2 Each file demonstrates the pattern, nothing is linked to real `~/nixconf`

---

## Phase 1: Structural refactor (zero behavior change)

### BASE — option declarations

- [ ] 1.1 `[BASE]` Create `nixos/base/users/` directory with individual user modules:
  - `alexander.nix` — defines alexander user with `enable` option
  - `guest.nix` — defines guest user with `enable` option
  - Each exposes `my.users.<name>.enable` toggle
  - Hosts enable only the users they need
- [ ] 1.2 `[BASE]` Create `nixos/base/locale.nix` — declare `my.timeZone`, `my.defaultLocale`, `my.extraLocaleSettings`
- [ ] 1.3 `[BASE]` Create `nixos/base/nix.nix` — declare `my.nixSettings` (experimental-features, allowUnfree)

### FEATURES — implementations

- [ ] 1.4 `[FEAT]` `nixos/features/users.nix` — reads `my.users.*.enable`, creates users for enabled ones
- [ ] 1.5 `[FEAT]` `nixos/features/locale.nix` — wires timezone and locale from options
- [ ] 1.6 `[FEAT]` `nixos/features/nix.nix` — wires nix settings from options
- [ ] 1.7 `[FEAT]` `nixos/features/pipewire.nix` — extract pipewire block
- [ ] 1.8 `[FEAT]` `nixos/features/bluetooth.nix` — extract + add `powerOnBoot = true`, persist `/var/lib/bluetooth`
- [ ] 1.9 `[FEAT]` `nixos/features/printing.nix` — extract printing
- [ ] 1.10 `[FEAT]` `nixos/features/firefox.nix` — extract firefox
- [ ] 1.11 `[FEAT]` `nixos/features/packages.nix` — extract common CLI packages

### Trim laptop host config

- [ ] 1.12 `[HOST]` Rewrite `nixos/hosts/laptop/configuration.nix` — only imports + host-specifics (bootloader, kernel, docker, throne, vscodium, v2rayn, prismlauncher, opencode, lan-mouse, gnome scaffolding)
- [ ] 1.13 **Verify:** `nh os switch` — boot, confirm everything identical

---

## Phase 2: Desktop PC

- [ ] 2.1 `[HOST]` Install NixOS on desktop, copy `hardware-configuration.nix` → `nixos/hosts/desktop/hardware.nix`
- [ ] 2.2 `[HOST]` `nixos/hosts/desktop/default.nix` — define `nixosConfigurations.desktop`
- [ ] 2.3 `[HOST]` `nixos/hosts/desktop/configuration.nix` — reuse shared features, add GPU drivers, desktop kernel
- [ ] 2.4 **Verify:** `nixos-rebuild build --flake ~/nixconf#desktop`

---

## Phase 3: Theme — Cyberpunk × ayu-dark

- [ ] 3.1 `[THM]` Extend `theme.nix` — keep `base00-base15` as ayu, add `cyberpunk` attrset:
  - `neon = "#00ffc8"` — cyan glow for borders/focus
  - `hack = "#00ff41"` — matrix green for prompt/status
  - `pulse = "#ff0080"` — hot pink for errors/markers
  - `dim = "#1a1a2e"` — deep blue-black for panels
  - `grid = "#0d1017"` — grid-line background
- [ ] 3.2 `[FEAT]` `nixos/features/desktop/ly.nix` — DM theme with `self.cyberpunk.neon` border
- [ ] 3.3 `[PCK]` Niri — focus-ring uses `self.theme.base0C` or `self.cyberpunk.neon`
- [ ] 3.4 `[PCK]` Kitty — cursor = `self.cyberpunk.neon`, selection bg = `self.cyberpunk.pulse`
- [ ] 3.5 `[PCK]` Fish — color `$` with `self.cyberpunk.hack`
- [ ] 3.6 `[FEAT]` Find/store dark grid/neon wallpaper in `nixos/features/wallpaper/`

---

## Phase 4: Neovim (via wrapper-modules)

- [ ] 4.1 `[PCK]` `wrappedPrograms/neovim/neovim.nix` — adapt from vimjoyer ref:
  - Drop vjxl stuff
  - Pick your plugins: lsp-zero, telescope, treesitter, blink-cmp, snacks-nvim, oil, lualine, mini.files, codecompanion
- [ ] 4.2 `[PCK]` Port ayu-dark colorscheme into neovim lua config
- [ ] 4.3 `[PCK]` `init.lua` — lazy-load with lz-n
- [ ] 4.4 `[PCK]` Wire into `environment.nix` — `EDITOR=neovim`
- [ ] 4.5 `[PCK]` `wrappedPrograms/environment.nix` — the shell env package bundling fish + neovim + lf + git + qalc + nix tools

---

## Phase 5: Noctalia → Quickshell

- [ ] 5.1 `[PCK]` Remove `wrappedPrograms/noctalia.nix` + directory
- [ ] 5.2 `[PCK]` `wrappedPrograms/quickshell/default.nix` — wrap quickshell with `-c ./`
- [ ] 5.3 `[PCK]` `shell.qml` — main shell file
- [ ] 5.4 `[PCK]` Port modules (bar, clock, workspaces, sys tray, keyboard layout, launcher) as QML files
- [ ] 5.5 `[PCK]` Port services (layout, music) as QML files
- [ ] 5.6 `[PCK]` Apply cyberpunk theme to quickshell widgets
- [ ] 5.7 `[PCK]` Update niri wrapper: `spawn-at-startup` = quickshell
- [ ] 5.8 `[PCK]` Update niri keybinds: quickshell IPC instead of noctalia IPC
- [ ] 5.9 `[HOST]` Update host config: `preferences.autostart = [self'.packages.quickshellWrapped]`

---

## Phase 6: Bluetooth fix

- [ ] 6.1 `[FEAT]` Covered in 1.8 — `hardware.bluetooth.powerOnBoot = true`
- [ ] 6.2 `[FEAT]` If impermanence: persist `/var/lib/bluetooth`
- [ ] 6.3 **Verify:** `systemctl status bluetooth`, `bluetoothctl scan on`

---

## Phase 7: Polish & TUI cyberpunk vibe

- [ ] 7.1 `[HOST]` Delete `services.xserver + gnome` from laptop host (Niri-only)
- [ ] 7.2 `[THM]` Confirm TUI app strategy: lf (files), btop (monitor), pulsemixer (audio), nmtui (network), qalc (calc)
- [ ] 7.3 `[FEAT]` Minimal notification daemon (mako/dunst with neon border)
- [ ] 7.4 `[THM]` Final pass: all wrapped programs reference `self.theme` or `self.cyberpunk` consistently

---

## Priority order

```
Phase 1 → Phase 6 → Phase 3 → Phase 4 → Phase 2 → Phase 5 → Phase 7
(safe)    (quick)   (fun)     (standalone) (parallel) (big)   (polish)
```
