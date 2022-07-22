local M = {}

function M.setup(on_attach, lsp_flags, capabilities)
  require('lspconfig').yamlls.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
      yaml = {
        validate = false,
        format = {
          enable = false,
        },
      },
    },
  })
end

return M
