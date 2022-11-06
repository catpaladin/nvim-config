-- setup nvim-lsp-installer
require("nvim-lsp-installer").setup {
  automatic_installation = true
}

-- Setup nvim-cmp.
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local au = require('utils.au')
local utils = require('utils.lsp')
local kb = require('utils.kb')
local luasnip = require("luasnip")
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Mappings.
vim.lsp.protocol.CompletionItemKind = {
  ' (text)',
  ' (method)',
  ' (function)',
  ' (constructor)',
  'ﰠ (field)',
  ' (variable)',
  ' (class)',
  ' (interface)',
  ' (module)',
  ' (property)',
  ' (unit)',
  ' (value)',
  ' (enum)',
  ' (key)',
  '﬌ (snippet)',
  ' (color)',
  ' (file)',
  ' (reference)',
  ' (folder)',
  ' (enum member)',
  ' (constant)',
  ' (struct)',
  ' (event)',
  ' (operator)',
  ' (type)',
}

local signs = {
  Error = vim.g.diagnostic_icons.Error,
  Warn = vim.g.diagnostic_icons.Warning,
  Hint = vim.g.diagnostic_icons.Hint,
  Info = vim.g.diagnostic_icons.Information,
}

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  { virtual_text = false, update_in_insert = false }
)
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = vim.g.floating_window_border })
vim.lsp.handlers['textDocument/formatting'] = utils.format_async

au.augroup('ShowDiagnostics', {
  {
    event = 'CursorHold,CursorHoldI',
    pattern = '*',
    callback = function()
      vim.diagnostic.open_float(nil, {
        focusable = false,
        border = vim.g.floating_window_border,
        source = 'if_many',
      })
    end,
  },
})

local disabled_signature_lsp = {
  terraformls = true,
  efm = true,
  tflint = true,
  --['null-ls'] = true,
}

-- on_attach
local on_attach = function(client, bufnr)
  require('illuminate').on_attach(client)

  if disabled_signature_lsp[client.name] == nil then
    require('lsp_signature').on_attach({
      bind = true,
      hint_enable = false,
      hi_parameter = 'CursorLine',
      handler_opts = { border = 'single' },
    })
  end

  --if client.name ~= 'null-ls' then
  --  client.resolved_capabilities.document_formatting = false
  --end

  if client.resolved_capabilities.document_formatting then
    au.augroup('LspFormatOnSave', {
      {
        event = 'BufWritePost',
        pattern = [[<buffer>]],
        callback = function()
          vim.lsp.buf.formatting()
        end,
      },
    }, true)
  end

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  buf_set_keymap('n', 'K', '<CMD>lua require("utils.lsp").show_documentation()<CR>', kb.silent_noremap)
  buf_set_keymap('n', '<leader>rn', '<CMD>lua vim.lsp.buf.rename()<CR>', kb.silent_noremap)
  buf_set_keymap('n', '<leader>ce', '<CMD>LspRestart<CR>', kb.silent_noremap)
  buf_set_keymap('n', '<leader>cf', '<CMD>lua vim.lsp.buf.formatting_sync()<CR>', kb.silent_noremap)
  buf_set_keymap('n', ']g', '<CMD>lua vim.lsp.diagnostic.goto_next()<CR>', kb.silent_noremap)
  buf_set_keymap('n', '[g', '<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>', kb.silent_noremap)
end

-- flags
local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- Languages
require('lsp.lua').setup(on_attach, lsp_flags, capabilities)
require('lsp.go').setup(on_attach, lsp_flags, capabilities)
require('lsp.python').setup(on_attach, lsp_flags, capabilities)
require('lsp.terraform').setup(on_attach, lsp_flags, capabilities)
require('lsp.yaml').setup(on_attach, lsp_flags, capabilities)
require('lsp.bash').setup(on_attach, lsp_flags, capabilities)
require('lsp.efm').setup(on_attach, lsp_flags, capabilities)
