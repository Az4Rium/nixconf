local palette = require("palette").get()

require("mini.base16").setup({
    palette = palette,
    use_cterm = true,
})

vim.g.colors_name = "base16"
