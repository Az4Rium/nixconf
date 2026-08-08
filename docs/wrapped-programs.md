# Wrapped Programs

Configurations in `wrappedPrograms/` are built with the **wrapper system**:
binaries are wrapped at build time so their config lives in Nix instead of dotfiles.
Packages are exposed per-system (`#fish`, `#myKitty`, …) and some also expose NixOS
modules. See `docs/structure.md` for how the wrapper system works.

## fish — `#fish`

`perSystem.packages.fish`, built with low-level `inputs.wrappers.wrapPackage`:

- `runtimeInputs`: `zoxide`
- launches with `-C 'source <generated config>'` containing:
  - a colored prompt (`user@host cwd`)
  - `fish_vi_key_bindings`
  - `zoxide init fish`
  - `lf` wrapper that `cd`s into the last browsed dir on exit
  - `direnv hook fish`

```bash
nix run ~/nixconf#fish
```

## kitty — `#myKitty`

`perSystem.packages.myKitty`, built with `inputs.wrapper-modules.wrappers.kitty.wrap`
(typed `settings`):

- shell = the wrapped fish (`self'.packages.fish`)
- JetBrainsMono Nerd Font, 15pt, cursor trail/block shape
- colors read directly from `theme.nix` (`self.theme.base00..base15`, plus semantic
  `bg`/`fg`/`accent`/`selection` for UI elements)
- remote control + shell integration enabled

```bash
nix run ~/nixconf#myKitty
```

## ly — display manager

`flake.nixosModules.ly` (not a standalone package). Enables
`services.displayManager.ly` and themes its colors from stylix
(`config.lib.stylix.colors` → `bg`, `fg`, borders, error colors).

## niri — compositor

`flake.nixosModules.niri` — `programs.niri` with a full keybinding set
(`Mod` = Super/Win, layout `us,ru` toggled with `Alt+Shift`):

| Keys | Action |
| ---- | ------ |
| `Mod+Return` | spawn kitty |
| `Mod+Space` / `Mod+M` | launcher / power menu (`qs ipc`) |
| `Mod+Q` | close window |
| `Mod+F` / `Mod+G` | maximize column / fullscreen |
| `Mod+Shift+F` | toggle floating |
| `Mod+H/J/K/L` | focus window |
| `Mod+Shift+H/J/K/L` | move window |
| `Mod+Ctrl+H/J/K/L` | resize (column width / window height) |
| `Mod+[` / `Mod+]` | consume / expel window |
| `Mod+C` | center column |
| `Mod+1..0` | workspaces `w0`–`w9` |
| `Mod+Shift+1..0` | move window to workspace |
| `Mod+Wheel` | focus column left/right |
| `XF86Audio*` / `XF86MonBrightness*` | `wpctl` volume / `brightnessctl` brightness |

Also: focus-follows-mouse, touchpad natural-scroll + tap, flat mouse accel, 5px gaps,
rounded windows, Bibata cursor, stylix-derived focus ring colors.

## neovim — `#neovim`, `#neovimDynamic`

Documented separately in **[docs/neovim.md](neovim.md)**.
