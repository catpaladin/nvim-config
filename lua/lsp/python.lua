local M = {}

function M.setup(on_attach, lsp_flags, capabilities)
  require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
      pyright = { disableLanguageServices = false, disableOrganizeImports = true },
      python = {
        analysis = {
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
        },
      },
    },
  }
end

return M
