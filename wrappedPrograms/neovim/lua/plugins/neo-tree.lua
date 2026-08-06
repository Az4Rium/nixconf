return {
    "neo-tree.nvim",
    cmd = "Neotree",
    keys = {
        { "<leader>e", "<CMD>Neotree toggle<CR>", desc = "Toggle file explorer" },
    },
    after = function()
        require("neo-tree").setup({
            close_if_last_window = true,
            filesystem = {
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
            },
            window = {
                width = 30,
                mappings = { ["<space>"] = "none" },
            },
        })
    end,
}
