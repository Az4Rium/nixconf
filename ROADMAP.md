# NixConf Modularization & Cyberpunk Rice — ROADMAP

---


## Phase 1: Structural refactor of `~/nixconf`

*Goal: zero behavior change, pure extraction*

### BASE — option declarations

- [ ] 1.1 `nixos/base/users.nix` — declare `my.userName`, `my.extraGroups`, `my.userHome` options
- [ ] 1.2 `nixos/base/users/alexander.nix` — set `my.userDefinitions.alexander`
- [ ] 1.3 `nixos/base/users/guest.nix` — set `my.userDefinitions.guest`
- [ ] 1.4 `nixos/base/locale.nix` — declare `my.timeZone`, `my.defaultLocale`, `my.extraLocaleSettings`
- [ ] 1.5 `nixos/base/nix.nix` — declare `my.nixSettings` (experimental-features, allowUnfree)

### FEATURES — implementations

- [ ] 1.6 `nixos/features/users.nix` — create `users.users` from `config.my.enabledUsers` + `config.my.userDefinitions`
- [ ] 1.7 `nixos/features/locale.nix` — wire locale/timezone from `config.my.*`
- [ ] 1.8 `nixos/features/nix.nix` — wire nix settings from `config.my.*`
- [ ] 1.9 `nixos/features/pipewire.nix` — extract pipewire block
- [ ] 1.10 `nixos/features/bluetooth.nix` — extract + add `powerOnBoot = true`, persist `/var/lib/bluetooth` if applicable
- [ ] 1.11 `nixos/features/printing.nix` — extract printing
- [ ] 1.12 `nixos/features/firefox.nix` — extract firefox
- [ ] 1.13 `nixos/features/packages.nix` — extract common CLI packages (vim, wget, curl, git, gcc, python3, docker-compose, busybox, cifs-utils)

### Trim host configuration

- [ ] 1.14 `hosts/laptop/users.nix` — select `my.enabledUsers = [ "alexander" "guest" ]`
- [ ] 1.15 Rewrite `hosts/laptop/configuration.nix` — only imports + host-specifics (bootloader, kernel, docker, throne, vscodium, v2rayn, prismlauncher, opencode, lan-mouse, gnome scaffolding)
- [ ] 1.16 Verify: `sudo nixos-rebuild switch` — confirm everything identical

---

## Phase 2: Desktop PC

- [ ] 2.1 Install NixOS on desktop, copy `/etc/nixos/hardware-configuration.nix` → `hosts/desktop/hardware.nix`
- [ ] 2.2 `hosts/desktop/default.nix` — define `nixosConfigurations.desktop`
- [ ] 2.3 `hosts/desktop/configuration.nix` — reuse all shared features, add GPU drivers, kernel, bootloader
- [ ] 2.4 `hosts/desktop/users.nix` — select `my.enabledUsers = [ "alexander" ]`
- [ ] 2.5 Verify: build from laptop via `nixos-rebuild build --flake ~/nixconf#desktop`

---

## Phase 3: Theme — Cyberpunk × ayu-dark

- [ ] 3.1 Extend `theme.nix` — keep `base00-base15` as ayu, add `cyberpunk` attrset (`neon = "#00ffc8"`, `hack = "#00ff41"`, `pulse = "#ff0080"`, `dim = "#1a1a2e"`, `grid = "#0d1017"`)
- [ ] 3.2 `nixos/features/desktop/ly.nix` — port ly from `wrappedPrograms/ly.nix` into feature module, wire `self.cyberpunk.neon` for border
- [ ] 3.3 Niri focus-ring — use `self.theme.base0C` (teal) or `self.cyberpunk.neon`
- [ ] 3.4 Kitty theme — cursor `self.cyberpunk.neon`, selection `self.cyberpunk.pulse`
- [ ] 3.5 Fish prompt — color `$` with `self.cyberpunk.hack`
- [ ] 3.6 Wallpaper — find dark grid/neon wallpaper, store in `nixos/features/wallpaper/`

---

## Phase 4: Neovim (via wrapper-modules)

- [ ] 4.1 `wrappedPrograms/neovim/neovim.nix` — adapt from vimjoyer ref: drop vjxl stuff, pick your plugins
- [ ] 4.2 `wrappedPrograms/neovim/lua/init.lua` — lazy-load config with lz-n
- [ ] 4.3 Wire into `environment.nix` — `EDITOR=neovim`, add to runtimeInputs
- [ ] 4.4 Create `wrappedPrograms/environment.nix` — shell env package (fish + neovim + lf + git + qalc + nix tools)

---

## Phase 5: Noctalia → Quickshell migration

- [ ] 5.1 Remove `wrappedPrograms/noctalia.nix` + `wrappedPrograms/noctalia/`
- [ ] 5.2 `wrappedPrograms/quickshell/default.nix` — wrap quickshell with `-c` pointing to `./.`
- [ ] 5.3 `wrappedPrograms/quickshell/shell.qml` — main shell file
- [ ] 5.4 Port modules (bar, clock, workspaces, sys tray, keyboard layout, launcher) under `quickshell/modules/`
- [ ] 5.5 Port services (layout, music) under `quickshell/services/`
- [ ] 5.6 Apply cyberpunk theme to quickshell widgets
- [ ] 5.7 Update `niri.nix` — `spawn-at-startup` quickshell instead of noctalia
- [ ] 5.8 Update niri keybinds — replace noctalia IPC with quickshell IPC
- [ ] 5.9 Update `features/desktop/niri.nix` — `preferences.autostart = [self'.packages.quickshellWrapped]`

---

## Phase 6: Bluetooth fix

- [ ] 6.1 Already covered in 1.10 (`powerOnBoot = true`)
- [ ] 6.2 If using impermanence: add `/var/lib/bluetooth` to persistent directories
- [ ] 6.3 Verify: `systemctl status bluetooth`, `bluetoothctl scan on`

---

## Phase 7: Polish & cyberpunk TUI vibe

- [ ] 7.1 Replace gnome scaffolding with Niri-only (delete `services.xserver + gnome` from host)
- [ ] 7.2 Confirm TUI-only app strategy: `lf` (files), `btop` (monitor), `pulsemixer` (audio), `nmtui` (network), `qalc` (calc)
- [ ] 7.3 Set up minimal notification daemon (dunst or mako with neon borders)
- [ ] 7.4 Final theme pass: ensure all wrapped programs reference `self.theme` or `self.cyberpunk` consistently
