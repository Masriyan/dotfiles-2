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

-- Keybindings using which-key
local wk = require('which-key')
wk.register({
  -- <leader>
  ['<leader>'] = {
    e = {'<cmd>NvimTreeToggle<CR>', ':NvimTreeToggle'},
  },
  -- fzf-lua mappings
  ['<C-p>'] = {
    name = '+fzf-lua',
    b = {"<cmd>lua require('fzf-lua').buffers()<CR>", 'open buffers'},
    f = {"<cmd>lua require('fzf-lua').files()<CR>", 'find or fd on a path'},
    g = {"<cmd>lua require('fzf-lua').live_grep()<CR>", 'live grep current project'},
    h = {"<cmd>lua require('fzf-lua').oldfiles()<CR>", 'opened files history'},
  },
})

