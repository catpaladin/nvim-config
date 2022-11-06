local M = {}

local utils = require("settings.lsp.utils")

function M.config()
  return {
    on_attach = utils.lsp_attach,
    capabilities = utils.get_capabilities(),
    flags = { debounce_text_changes = 150 },
    settings = {
      yaml = {
        validate = false,
        format = {
          enable = false,
        },
      },
    },
  }
end

function M.setup()
  return M.config()
end

return M
