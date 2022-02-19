require('plugins')
require('lsp')

-- Colorscheme
local cmd = vim.cmd
cmd [[colorscheme pablo]]

-- Options
local o = vim.o

o.number = true
o.textwidth = 80
o.mouse = "a"
o.colorcolumn = "80,120"
o.smarttab = true
