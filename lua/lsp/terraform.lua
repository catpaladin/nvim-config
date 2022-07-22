local M = {}

function M.setup(on_attach, lsp_flags, capabilities)
  require('lspconfig')['terraformls'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
      terraformls = {}
    },
  }

  require('lspconfig').tflint.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  })
end

return M
