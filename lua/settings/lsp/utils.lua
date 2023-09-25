local M = {}

function M.lsp_diagnostics()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    underline = true,
    signs = true,
    update_in_insert = false,
  })

  local on_references = vim.lsp.handlers["textDocument/references"]
  vim.lsp.handlers["textDocument/references"] = vim.lsp.with(on_references, { loclist = true, virtual_text = true })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded",
  })
end

function M.lsp_highlight(client, bufnr)
  --if client.resolved_capabilities.document_highlight then
  vim.api.nvim_exec(
    [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#282f45
      hi LspReferenceText cterm=bold ctermbg=red guibg=#282f45
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#282f45
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]],
    false
  )
  --end
end

function M.lsp_config(client, bufnr)
  local kb = require('utils.kb')
  local au = require('utils.au')

  require('illuminate').on_attach(client)
  require("lsp_signature").on_attach {
    bind = true,
    hint_enable = false,
    hi_parameter = 'CursorLine',
    handler_opts = { border = 'single' },
  }

  -- fmt on write w/ lsp
  vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
  --vim.cmd [[autocmd BufWritePost * FormatWriteLock]]
  --vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({}, 1000)]]
  --au.augroup('LspFormatOnSave', {
  --  {
  --    event = 'BufWritePost',
  --    pattern = [[<buffer>]],
  --    callback = function()
  --      vim.lsp.buf.formatting()
  --    end,
  --  },
  --}, true)

  kb.buf_set_keymap('n', 'K', '<CMD>lua require("utils.lsp").show_documentation()<CR>', kb.silent_noremap)
  kb.buf_set_keymap('n', '[r', '<CMD>lua vim.lsp.buf.rename()<CR>', kb.silent_noremap)
  kb.buf_set_keymap('n', ']r', '<CMD>LspRestart<CR>', kb.silent_noremap)
  kb.buf_set_keymap('n', '[f', '<CMD>lua vim.lsp.buf.formatting_sync()<CR>', kb.silent_noremap)
  kb.buf_set_keymap('n', ']g', '<CMD>lua vim.lsp.diagnostic.goto_next()<CR>', kb.silent_noremap)
  kb.buf_set_keymap('n', '[g', '<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>', kb.silent_noremap)
end

-- on_attach
function M.lsp_attach(client, bufnr)
  M.lsp_config(client, bufnr)
  --M.lsp_highlight(client, bufnr)
  M.lsp_diagnostics()
end

-- capabilities
function M.get_capabilities()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- Code actions
  capabilities.textDocument.codeAction = {
    dynamicRegistration = true,
    codeActionLiteralSupport = {
      codeActionKind = {
        valueSet = (function()
          local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
          table.sort(res)
          return res
        end)(),
      },
    },
  }

  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities.experimental = {}
  capabilities.experimental.hoverActions = true

  return capabilities
end

return M
