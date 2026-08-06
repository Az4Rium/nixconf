local palette = require("palette").get()
local colors = {
    blue = palette.base0D, green = palette.base0B, yellow = palette.base0A,
    red = palette.base08, magenta = palette.base0E,
    bg = palette.base00, fg = palette.base05,
    gray = palette.base02, lightgray = palette.base01,
}
return {
    "lualine.nvim",
    lazy = false,
    after = function()
        require("lualine").setup({
            options = {
                theme = {
                    normal =  { a = { bg = colors.blue, fg = colors.bg, gui = 'bold' }, b = { bg = colors.lightgray, fg = colors.fg }, c = { bg = colors.lightgray, fg = colors.fg } },
                    insert =  { a = { bg = colors.green, fg = colors.bg, gui = 'bold' }, b = { bg = colors.lightgray, fg = colors.fg }, c = { bg = colors.lightgray, fg = colors.fg } },
                    visual =  { a = { bg = colors.yellow, fg = colors.bg, gui = 'bold' }, b = { bg = colors.lightgray, fg = colors.fg }, c = { bg = colors.lightgray, fg = colors.fg } },
                    replace = { a = { bg = colors.red, fg = colors.bg, gui = 'bold' }, b = { bg = colors.lightgray, fg = colors.fg }, c = { bg = colors.bg, fg = colors.fg } },
                    command = { a = { bg = colors.magenta, fg = colors.bg, gui = 'bold' }, b = { bg = colors.lightgray, fg = colors.fg }, c = { bg = colors.lightgray, fg = colors.fg } },
                    inactive = { a = { bg = colors.bg, fg = colors.gray, gui = 'bold' }, b = { bg = colors.bg, fg = colors.gray }, c = { bg = colors.bg, fg = colors.gray } },
                },
                globalstatus = true,
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {},
                lualine_c = { 'filename', 'branch', 'diff', 'diagnostics' },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' },
            },
        })
    end,
}
