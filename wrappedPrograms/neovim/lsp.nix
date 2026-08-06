{ self, ... }: {
	flake.modules.neovim.lua = {pkgs, ...}: {
		runtimePkgs = [ pkgs.lua-language-server ];
		specs.lua = {
			data = [ pkgs.vimPlugins.nvim-lspconfig ];
			config = ''vim.lsp.enable("lua_ls")'';
		};	
	};	

	flake.modules.neovim.rust = {pkgs, ...}: {
		runtimePkgs = [ pkgs.rust-analyzer ];
		specs.rust = {
			data = [ pkgs.vimPlugins.nvim-lspconfig ];
			config = ''vim.lsp.enable("rust_analyzer")'';
		};	
	};	

	flake.modules.neovim.python = {pkgs, ...}: {
		runtimePkgs = [ pkgs.pyright ];
		specs.python = {
			data = [ pkgs.vimPlugins.nvim-lspconfig ];
			config = ''vim.lsp.enable("pyright")'';
		};	
	};	

	flake.modules.neovim.nix = {pkgs, ...}: {
		runtimePkgs = [ pkgs.nixd pkgs.alejandra ];
		specs.nix = {
			data = [ pkgs.vimPlugins.nvim-lspconfig ];
			config = # lua
				''
					vim.lsp.config("nixd", {
						settings = {
							nixd = {
								formatting = {
									command = { "alejandra" },	
								},	
							},
						},
					})
					vim.lsp.enable("nixd")
				'';
		};	
	};	

	flake.modules.neovim.c = {pkgs, ...}: {
		runtimePkgs = [ pkgs.clang-tools ];
		specs.c = {
			data = [ pkgs.vimPlugins.nvim-lspconfig ];
			config = # lua
				''
					vim.lsp.config("clangd", {
						cmd = { "clangd", "--background-index" },
					})
					vim.lsp.enable("clangd")
				'';
		};	
	};	
	flake.modules.neovim.qml = {pkgs, ...}: {
		runtimePkgs = [ pkgs.kdePackages.qtdeclarative ];
		specs.qml = {
			data = [ pkgs.vimPlugins.nvim-lspconfig ];
			config = #lua 
				''
					vim.lsp.config("qmlls", {
						cmd = { "qmlls", "-E" },
					})
					vim.lsp.enable("qmlls")'';
		};	
	};	
	
	flake.modules.neovim.allServers = {
		imports = [
			self.modules.neovim.lua
			self.modules.neovim.rust
			self.modules.neovim.python
			self.modules.neovim.nix
			self.modules.neovim.c
			self.modules.neovim.qml
		];	
	};
}
