-- plugins/init.lua
-- Configure plugins installation via packer.nvim
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local packer = require('packer').startup(function(use)
  -- Plugins here
  use 'wbthomason/packer.nvim'

  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use 'lukas-reineke/indent-blankline.nvim'

  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {
        -- empty configuration
      }
    end
  }

  use { 'ibhagwan/fzf-lua',
    requires = { 'vijaymarupudi/nvim-fzf' }
  }

  use { 'hrsh7th/nvim-cmp',
    requires = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
    }
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function()
      require('nvim-tree').setup {
        -- empty configuration
      }
    end
  }

  -- Languages
  -- This section is for additional plugins to enhance experience with
  -- programming languages

  use 'folke/lua-dev.nvim'

  use { 'crispgm/nvim-go',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
    }
  }

  use { 'jose-elias-alvarez/nvim-lsp-ts-utils',
    requires = {
      'jose-elias-alvarez/null-ls.nvim',
      'nvim-lua/plenary.nvim',
    }
  }

  use { 'jose-elias-alvarez/null-ls.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    }
  }

  -- Misc

  use 'folke/tokyonight.nvim'

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup {
	on_attach = function(bufnr)
	  local wk = require('which-key')
	  wk.register({
            -- Navigation
            [']c'] = {"&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", 'Gitsigns next hunk'},
            ['[c'] = {"&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", 'Gitsigns prev hunk'},

	    -- Actions
            ['<leader>hs'] = {'<cmd>Gitsigns stage_hunk<CR>', 'Gitsigns stage hunk'},
            ['<leader>hr'] = {'<cmd>Gitsigns reset_hunk<CR>', 'Gitsigns reset hunk'},
            ['<leader>hS'] = {'<cmd>Gitsigns stage_buffer<CR>', 'Gitsigns stage buffer'},
            ['<leader>hu'] = {'<cmd>Gitsigns undo_stage_hunk<CR>', 'Gitsigns undo stage hunk'},
            ['<leader>hR'] = {'<cmd>Gitsigns reset_buffer<CR>', 'Gitsigns reset buffer'},
            ['<leader>hp'] = {'<cmd>Gitsigns preview_hunk<CR>', 'Gitsigns preview hunk'},
            ['<leader>hb'] = {'<cmd>lua require"gitsigns".blame_line{full=true}<CR>', 'Gitsigns blame line'},
            ['<leader>tb'] = {'<cmd>Gitsigns toggle_current_line_blame<CR>', 'Gitsigns toggle current line blame'},
            ['<leader>hd'] = {'<cmd>Gitsigns diffthis<CR>', 'Gitsigns diffthis'},
            ['<leader>hD'] = {'<cmd>lua require"gitsigns".diffthis("~")<CR>', 'Gitsigns diffthis to HEAD'},
            ['<leader>td'] = {'<cmd>Gitsigns toggle_deleted<CR>', 'Gitsigns toggle deleted'},
	  }, { buffer = bufnr})

	  wk.register({
            ['<leader>hs'] = {'<cmd>Gitsigns stage_hunk<CR>', 'Gitsigns stage hunk'},
            ['<leader>hr'] = {'<cmd>Gitsigns reset_hunk<CR>', 'Gitsigns reset hunk'},
	  }, { buffer = bufnr, mode = 'v'})

          -- Text object
	  wk.register({['ih'] = {':<C-U>Gitsigns select_hunk<CR>', 'Gitsigns select hunk'}}, { buffer = bufnr, mode = 'o'})
	  wk.register({['ih'] = {':<C-U>Gitsigns select_hunk<CR>', 'Gitsigns select hunk'}}, { buffer = bufnr, mode = 'x'})
        end
      }
    end
  }

  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup {
        -- empty configuration
      }
    end
  }

  use {
    'klen/nvim-test',
    config = function()
      require('nvim-test').setup()
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)


-- nvim-treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- indent-blankline.nvim
require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = true,
}


-- Setup nvim-cmp.
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'cmdline' },
    { name = 'buffer' },
  })
})


return packer
