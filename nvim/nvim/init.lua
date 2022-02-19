require('plugins')
require('lsp')

-- Colorscheme
vim.cmd [[colorscheme tokyonight]]

-- Option
vim.o.number = true
vim.o.textwidth = 80
vim.o.mouse = 'a'
vim.o.colorcolumn = '80,120'
vim.o.smarttab = true

-- Keybindings using which-key
local wk = require('which-key')
wk.register({
  -- <leader>
  ['<leader>'] = {
    e = {'<cmd>NvimTreeToggle<CR>', ':NvimTreeToggle'},
    t = {'<cmd>TroubleToggle<CR>', ':TroubleToggle'},
  },
  -- fzf-lua mappings
  ['<C-p>'] = {
    name = '+fzf-lua',
    ['<CR>'] = {"<cmd>lua require('fzf-lua').builtin()<CR>", 'fzf-lua builtin commands'},
    b = {"<cmd>lua require('fzf-lua').buffers()<CR>", 'open buffers'},
    f = {"<cmd>lua require('fzf-lua').files()<CR>", 'find or fd on a path'},
    g = {"<cmd>lua require('fzf-lua').live_grep()<CR>", 'live grep current project'},
    h = {"<cmd>lua require('fzf-lua').oldfiles()<CR>", 'opened files history'},
  },
})

