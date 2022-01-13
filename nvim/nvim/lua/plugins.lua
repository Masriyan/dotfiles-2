return require('packer').startup(function(use)
  -- Plugins here
  use { 'ibhagwan/fzf-lua',
    requires = { 'vijaymarupudi/nvim-fzf' }
  }

  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use { 'hrsh7th/nvim-cmp',
    requires = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
    }
  }
end)
