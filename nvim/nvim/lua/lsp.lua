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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'gopls', 'tsserver', 'sumneko_lua' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
