local g = vim.g
local o = vim.opt

o.swapfile = true
o.dir = '/tmp'

o.smartcase = true
o.hlsearch = true
o.incsearch = true
o.ignorecase = true

o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"

o.wrap = false
o.clipboard = "unnamedplus"
o.encoding = "utf-8"
o.hidden = true

o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true

o.updatetime = 300
o.termguicolors = true
o.mouse = "a"

o.splitbelow = true
o.splitright = true
o.scrolloff = 9
o.scroll = 6
o.pumheight = 16
o.winborder = "single"

o.langmap =
[[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz]]

g.mapleader = " "

o.background = "dark"

require("colorscheme")
