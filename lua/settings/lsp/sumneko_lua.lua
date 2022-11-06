local M = {}

local utils = require("settings.lsp.utils")

function M.config()
  return require('neodev').setup({
    lspconfig = {
      on_attach = utils.lsp_attach(),
      capabilities = utils.get_capabilities(),
      flags = { debounce_text_changes = 150 },
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    }
  })
end

function M.setup()
  return M.config()
end

return M
