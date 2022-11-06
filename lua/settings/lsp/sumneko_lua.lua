local M = {}

local utils = require("settings.lsp.utils")

function M.config()
  return {
      on_attach = utils.lsp_attach(),
      capabilities = utils.get_capabilities(),
      flags = { debounce_text_changes = 150 },
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          completion = {
            callSnippet = 'Replace',
          },
          diagnostics = {
            enable = true,
            globals = {'vim', 'use'},
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            maxPreload = 10000,
            preloadFileSize = 10000,
          },
          telemetry = {enable = false},
        },
      },
    }
end

function M.setup()
  return M.config()
end

return M
