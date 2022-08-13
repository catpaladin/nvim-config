local M = {}

function M.setup(on_attach, lsp_flags, capabilities)
  require('lspconfig')['gopls'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          unusedvariable = true,
        },
        usePlaceholders = true,
      },
    },
  }
end

return M
