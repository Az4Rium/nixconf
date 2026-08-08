# Neovim Configuration

This is a fully declarative Neovim build. Plugins are declared in Nix
(`nix-wrapper-modules`), the Lua runtime configuration lives in `lua/`, and the whole thing
is exposed as a flake package so Neovim is reproducible and installed with
`environment.systemPackages` (`EDITOR` is set to it in `nixos/features/packages.nix`).

## Directory layout

```
wrappedPrograms/neovim/
├── neovim.nix            # main wrapper module + the two flake packages
├── lsp.nix               # one wrapper-module per language server (LSP)
└── lua/
    ├── init.lua          # entry point: opts, filetype, keymap, lz.n.load('plugins')
    ├── opts.lua          # global options + colorscheme
    ├── keymap.lua        # global keymaps
    ├── palette.lua       # reads stylix palette.json, falls back to ayu-dark
    ├── colorscheme.lua   # mini.base16 colorscheme
    ├── filetype.lua      # (reserved / empty)
    └── plugins/          # lz.n plugin specs (one file per plugin)
        ├── blink-cmp.lua
        ├── fastaction.lua
        ├── gitsigns.lua
        ├── lazydev.lua
        ├── lspconfig.lua
        ├── lualine.lua
        ├── luasnip.lua
        ├── neo-tree.lua
        ├── nvim-autopairs.lua
        ├── snacks.lua
        └── treesitter.lua
```

## Packages

Two builds are exposed (`perSystem.packages` in `neovim.nix`):

| Package            | Build type              | Use case                              |
| ------------------ | ----------------------- | ------------------------------------- |
| `#neovim`          | pure — config is copied into the Nix store from `./.` | production, installed on the system |
| `#neovimDynamic`   | impure — `dynamicMode = true` | development; reads `lua/` straight from `~/nixconf/wrappedPrograms/neovim` |

```bash
nix build /home/alexander/nixconf#neovim
nix run /home/alexander/nixconf#neovimDynamic
```

In **dynamic mode** the Lua configuration is read from
`vim.uv.os_homedir() .. '/nixconf/wrappedPrograms/neovim'` at startup instead of being
copied into the store. Editing any file under `lua/` takes effect on the next launch —
ideal for iterating on mappings/plugins without rebuilding. Changing the **set of plugins
or LSP binaries** (Nix-declared `specs`) still requires a rebuild.

## Module options (`flake.modules.neovim.main`)

| Option             | Type                    | Default                                                                      |
| ------------------ | ----------------------- | ---------------------------------------------------------------------------- |
| `dynamicMode`      | bool                    | `false`                                                                      |
| `initLua`          | stringable              | `./.` (this directory)                                                       |
| `dynamicInitLua`   | stringable / luaInline  | `vim.uv.os_homedir() .. '/nixconf/wrappedPrograms/neovim'`                    |
| `settings.config_directory` | (set by module) | `initLua` or `dynamicInitLua` depending on `dynamicMode`                |

### Runtime packages

Always available on `PATH` inside Neovim (`runtimePkgs`):

| Package       | Purpose                             |
| ------------- | ----------------------------------- |
| `wl-clipboard`| Wayland clipboard (`unnamedplus`)   |
| `fd`          | file finder backend                 |
| `ripgrep`     | grep backend                        |

## Plugin configuration (Nix `specs`)

Plugins are grouped into **start plugins** (loaded at startup) and **lazy plugins**
(loaded on demand by [lz.n](https://github.com/nvim-org/lz.n)). The per-plugin behavior is
defined by the lz.n specs in `lua/plugins/`.

### Start plugins (`specs.plugins`)

| Plugin            | Notes                                                    |
| ----------------- | -------------------------------------------------------- |
| `lz-n`            | lazy-loading manager                                     |
| `plenary-nvim`    | shared library                                           |
| `nvim-lspconfig`  | LSP server configuration layer                           |
| `nvim-treesitter` | with grammars: bash, c, cpp, javascript, json, lua, markdown, nix, python, qmljs, rust, toml, typescript, yaml |
| `nvim-web-devicons` | file icons                                             |
| `lspkind-nvim`    | completion kind symbols                                  |
| `colorful-menu-nvim` | colorized completion labels                           |
| `blink-cmp`       | completion engine (sources: lsp, path, snippets, buffer) |
| `snacks-nvim`     | picker, notifier, words, image, quickfile, input         |
| `lualine-nvim`    | statusline (custom palette theme)                        |
| `luasnip`         | snippet engine                                           |
| `mini-nvim`       | provides `mini.base16` colorscheme                       |
| `nui-nvim`        | popup UI library (used by neo-tree)                      |

### Lazy plugins (`specs.lazyPlugins`)

| Plugin           | Trigger                                            |
| ---------------- | -------------------------------------------------- |
| `neo-tree.nvim`  | `:Neotree` / `<leader>e`                           |
| `gitsigns.nvim`  | attached to git buffers on demand                  |
| `nvim-autopairs` | on `DeferredUIEnter`                               |
| `fastaction.nvim`| on `<leader>a`                                     |
| `lazydev.nvim`   | on `ft = "lua"`                                    |

### Startup flow

`specs.init.config = "require('init')"` runs before `MAIN_INIT`. `init.lua` loads
`opts` (options + colorscheme), `filetype`, `keymap`, then hands over to
`require('lz.n').load('plugins')` which reads every spec in `lua/plugins/`.

## Language servers (`lsp.nix`)

Each server is its own wrapper-module under `flake.modules.neovim.*`, and `allServers`
imports them all. Every module adds the server binary to `runtimePkgs` and calls
`vim.lsp.enable(...)` (nvim 0.12 built-in LSP) with `nvim-lspconfig` as the data dependency.

| Module    | Server            | Binary package      | Extra config                          |
| --------- | ----------------- | ------------------- | ------------------------------------- |
| `lua`     | `lua_ls`          | `lua-language-server` | —                                   |
| `rust`    | `rust_analyzer`   | `rust-analyzer`     | —                                     |
| `python`  | `pyright`         | `pyright`           | —                                     |
| `nix`     | `nixd`            | `nixd`, `alejandra` | formatter `alejandra`                 |
| `c`       | `clangd`          | `clang-tools`       | `clangd --background-index`           |
| `qml`     | `qmlls`           | `kdePackages.qtdeclarative` | `qmlls -E`                    |

The servers are enabled globally and start automatically when you open a matching
filetype. `vim.lsp.config('*', ...)` (see `lua/plugins/lspconfig.lua`) applies common
capabilities (from blink.cmp) and the LSP keymaps to every server.

## Colorscheme & theming

Neovim is themed from the **same stylix palette** as the rest of the system:

1. `palette.lua` looks for `/etc/stylix/palette.json`, then
   `$XDG_CONFIG_HOME/stylix/palette.json`. Stylix writes hex values **without** `#`,
   so each value gets a `#` prepended.
2. If neither file exists, it falls back to the bundled ayu-dark table (`FALLBACK`).
3. `colorscheme.lua` feeds the palette into `mini.base16.setup(...)` and sets
   `vim.g.colors_name = "base16"`.

`lualine.nvim` and other plugins pull the same palette via `require("palette").get()`,
so the statusline matches the editor theme.

## Options (`lua/opts.lua`)

Highlights:

- Leader key: **Space**
- Search: `smartcase`, `hlsearch`, `incsearch`, `ignorecase`
- UI: relative line numbers, cursorline, `signcolumn=yes`, `winborder=single`, `scrolloff=9`, `pumheight=16`
- Tabs: 2-space soft tabs (`expandtab`)
- Clipboard: `unnamedplus` (Wayland)
- Splits: `splitbelow`, `splitright`
- Swap files in `/tmp`
- `langmap`: maps Cyrillic → Latin so commands keep working on a **Russian keyboard layout**
  (e.g. `Й` types as `Q`)
- `termguicolors`, `mouse=a`, `updatetime=300`
- `o.background = "dark"`

## Keymaps

Leader = Space.

### Global (`lua/keymap.lua`)

| Mode | Keys                          | Action                         |
| ---- | ----------------------------- | ------------------------------ |
| n    | `M-h` `M-j` `M-k` `M-l`       | window left / down / up / right |
| i    | `M-h` / `M-l`                 | cursor left / right            |
| v    | `J` / `K`                     | move selection down / up       |
| n    | `A-w`                         | cycle to next window           |
| n    | `z{` / `z(`                   | jump to matching `{` / `(`     |
| n    | `<leader><esc>`               | clear search highlight         |
| n    | `C-Left` `C-Right` `C-h` `C-l`| resize vertical ∓ 2            |
| n    | `C-Up` `C-Down` `C-k` `C-j`   | resize horizontal ∓ 2          |
| n    | `C-d` / `C-u`                 | scroll 5 lines                 |

### LSP (`lua/plugins/lspconfig.lua`, on attach)

| Mode | Keys         | Action                       |
| ---- | ------------ | ---------------------------- |
| v    | `F`          | format                        |
| n    | `<leader>F`  | format                        |
| n    | `<leader>k`  | open diagnostic float         |
| n    | `<space>q`   | send diagnostics to loclist   |
| n    | `gD`         | go to type definition         |
| n    | `gr`         | references (Snacks picker)    |
| n    | `gd`         | go to definition (Snacks)     |

### Plugins

| Mode | Keys           | Action                       |
| ---- | -------------- | ---------------------------- |
| n    | `<leader>e`    | toggle neo-tree explorer     |
| n    | `<leader>a`    | fastaction code actions      |
| n    | `<leader>ff`   | Snacks smart find files      |
| n    | `<leader>fo`   | Snacks recent files          |
| n    | `<leader>fg`   | Snacks grep                  |
| n    | `<leader>fG`   | Snacks grep (current ft)     |

## Development workflow

```bash
# iterate on lua/ without rebuilding
nix run /home/alexander/nixconf#neovimDynamic

# when done, rebuild the real package
nix build /home/alexander/nixconf#neovim

# apply to the system
sudo nixos-rebuild switch --flake /home/alexander/nixconf#laptop
```

### Troubleshooting

- **`error: attribute '…' missing` during evaluation** — the file is not tracked by git.
  The flake uses `git+file://`, so only committed/staged files are available:
  `git add wrappedPrograms/neovim && nix build .#neovim`.
- **LSP server not found** — the binary package is missing from the module's
  `runtimePkgs`; add it there (not to `nixpkgs.config`), rebuild, and confirm with
  `:echo exepath('<server>')`.
- **Wrong colors / no colors** — verify `/etc/stylix/palette.json` exists and that
  `:lua print(vim.g.colors_name)` reports `base16`.
