return {
    "luasnip",
    lazy = false,
    after = function()
        local ls = require("luasnip")
        ls.config.setup({ history = true, updateevents = "TextChanged,TextChangedI" })
    end,
}
