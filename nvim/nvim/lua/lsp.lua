local wk = require('which-key')

-- nvim-go
-- First time only need to install quicktype with npm
-- require('go').config.update_tool('quicktype', function(tool)
--     tool.pkg_mgr = 'npm'
-- end)
require('go').setup({})

-- null-ls
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint, -- eslint or eslint_d
    null_ls.builtins.code_actions.eslint, -- eslint or eslint_d
    null_ls.builtins.formatting.prettier, -- prettier, eslint, eslint_d, or prettierd
  },
})


-- Map following keys to no particular buffer
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.register({
  ['<space>e'] = {'<cmd>lua vim.diagnostic.open_float()<CR>', 'Show diagnostics'},
  ['[d'] = {'<cmd>lua vim.diagnostic.goto_prev()<CR>', 'Go to diagnostic prev'},
  [']d'] = {'<cmd>lua vim.diagnostic.goto_next()<CR>', 'Go to diagnostic next'},
  ['<space>q'] = {'<cmd>lua vim.diagnostic.setloclist()<CR>', 'Set diagnostic loclist'},
})

-- Register keymaps via which key inside lsp servers on_attach
local wk_register_on_attach = function(bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  wk.register({
    ['gD'] = {'<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration'},
    ['gd'] = {'<cmd>lua vim.lsp.buf.definition()<CR>', 'Definition'},
    ['K'] = {'<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover'},
    ['gi'] = {'<cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation'},
    ['<C-k>'] = {'<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature help'},
    ['<space>wa'] = {'<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add workspace folder'},
    ['<space>wr'] = {'<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove workspace folder'},
    ['<space>wl'] = {'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'List workspace folders'},
    ['<space>D'] = {'<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type definition'},
    ['<space>rn'] = {'<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename'},
    ['<space>ca'] = {'<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Action'},
    ['gr'] = {'<cmd>lua vim.lsp.buf.references()<CR>', 'References'},
    ['<space>f'] = {'<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format'},
  }, { buffer = bufnr })

  -- Range Formatting With a Motion
  -- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion
  function format_range_operator()
    local old_func = vim.go.operatorfunc
    _G.op_func_formatting = function()
      local start = vim.api.nvim_buf_get_mark(bufnr, '[')
      local finish = vim.api.nvim_buf_get_mark(bufnr, ']')
      vim.lsp.buf.range_formatting({}, start, finish)
      vim.go.operatorfunc = old_func
      _G.op_func_formatting = nil
    end
    vim.go.operatorfunc = 'v:lua.op_func_formatting'
    vim.api.nvim_feedkeys('g@', 'n', false)
  end

  wk.register({
    gm = {'<cmd>lua format_range_operator()<CR>', 'Range formatting with a motion'},
  })
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  wk_register_on_attach(bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local lspconfig = require('lspconfig')

local servers = { 'gopls', 'tsserver' }
for _, server in pairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }
end


-- Setup lua language server for neovim itself
local luadev = require("lua-dev").setup({
  -- add any options here, or leave empty to use the default settings
  lspconfig = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  },
})
lspconfig.sumneko_lua.setup(luadev)


-- Setup Typescript language server using nvim-lsp-ts-utils
lspconfig.tsserver.setup({
  -- Needed for inlayHints. Merge this table with your settings or copy
  -- it from the source if you want to add your own init_options.
  init_options = require("nvim-lsp-ts-utils").init_options,
  on_attach = function(client, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")

    -- defaults
    ts_utils.setup({
      debug = false,
      disable_commands = false,
      enable_import_on_completion = false,

      -- import all
      import_all_timeout = 5000, -- ms
      -- lower numbers = higher priority
      import_all_priorities = {
        same_file = 1, -- add to existing import statement
        local_files = 2, -- git files or files with relative path markers
        buffer_content = 3, -- loaded buffer content
        buffers = 4, -- loaded buffer names
      },
      import_all_scan_buffers = 100,
      import_all_select_source = false,
      -- if false will avoid organizing imports
      always_organize_imports = true,

      -- filter diagnostics
      filter_out_diagnostics_by_severity = {},
      filter_out_diagnostics_by_code = {},

      -- inlay hints
      auto_inlay_hints = true,
      inlay_hints_highlight = "Comment",
      inlay_hints_priority = 200, -- priority of the hint extmarks
      inlay_hints_throttle = 150, -- throttle the inlay hint request
      inlay_hints_format = { -- format options for individual hint kind
        Type = {},
        Parameter = {},
        Enum = {},
        -- Example format customization for `Type` kind:
        -- Type = {
        --     highlight = "Comment",
        --     text = function(text)
        --         return "->" .. text:sub(2)
        --     end,
        -- },
      },

      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil,
    })

    -- required to fix code action ranges and filter diagnostics
    ts_utils.setup_client(client)

    -- no default maps, so you may want to define some here
    -- local opts = { silent = true }
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)
    wk_register_on_attach(bufnr)
  end,
  capabilities = capabilities,
})
