return {
  "render-markdown.nvim",
  ft = "markdown",
  after = function ()
    require("render-markdown").setup({})
  end,
  keys = {
    {"<leader>md", function() require("render-markdown").toggle() end, desc = "Toggle Markdown Render"},
  },
}
