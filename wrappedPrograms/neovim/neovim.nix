{
  inputs,
  self,
  ...
}: {
  flake.modules.neovim.main = {
    config, wlib, lib, pkgs, ...
  }: {
    options = {
      dynamicMode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If ture use impure config instead for fast edits
        ''; 
      }; 
      initLua = lib.mkOption {
        type = wlib.types.stringable;
        default = ./.; 
      };
      dynamicInitLua = lib.mkOption {
        type = lib.types.either wlib.types.stringable lib.types.luaInline;
        default = lib.generators.mkLuaInline "vim.uv.os_homedir() .. '/nixconf/wrappedPrograms/neovim'"; 
      };
    };
    config = {
      settings.config_directory = 
        if config.dynamicMode
        then config.dynamicInitLua
        else config.initLua; 

      runtimePkgs = [
        pkgs.wl-clipboard
        pkgs.fd
        pkgs.ripgrep
      ];

      specs.init = {
        data = null;
        before = ["MAIN_INIT"];
        config = "require('init')"; 
      };

      specs.plugins = {
        data = [
          pkgs.vimPlugins.lz-n
          pkgs.vimPlugins.plenary-nvim
          pkgs.vimPlugins.nvim-lspconfig
          (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
            p.tree-sitter-bash
            p.tree-sitter-c
            p.tree-sitter-cpp
            p.tree-sitter-javascript
            p.tree-sitter-json
            p.tree-sitter-lua
            p.tree-sitter-markdown
            p.tree-sitter-nix
            p.tree-sitter-python
            p.tree-sitter-qmljs
            p.tree-sitter-rust
            p.tree-sitter-toml
            p.tree-sitter-typescript
            p.tree-sitter-yaml
          ])) 
          pkgs.vimPlugins.nvim-web-devicons
          pkgs.vimPlugins.lspkind-nvim
          pkgs.vimPlugins.colorful-menu-nvim
          pkgs.vimPlugins.blink-cmp
          pkgs.vimPlugins.snacks-nvim
          pkgs.vimPlugins.lualine-nvim
          pkgs.vimPlugins.luasnip
          pkgs.vimPlugins.mini-nvim
          pkgs.vimPlugins.nui-nvim
        ];
      };
      
      specs.lazyPlugins = {
        lazy = true;  
        data = [
          pkgs.vimPlugins.lazydev-nvim
          pkgs.vimPlugins.gitsigns-nvim
          pkgs.vimPlugins.nvim-autopairs
          pkgs.vimPlugins.fastaction-nvim
          pkgs.vimPlugins.neo-tree-nvim
        ];
      };
    };
  };
  perSystem = {
    pkgs, self', ...
  }: {
    packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      imports = [
        self.modules.neovim.main
        self.modules.neovim.allServers 
      ];
    };
    packages.neovimDynamic = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs; 
      dynamicMode = true;
      imports = [
        self.modules.neovim.main
        self.modules.neovim.allServers 
      ];
    };
  };
}
