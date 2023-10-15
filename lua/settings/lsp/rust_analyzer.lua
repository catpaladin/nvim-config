local M = {}

local utils = require("settings.lsp.utils")

function M.config()
  return {
    on_attach = utils.lsp_attach,
    capabilities = utils.get_capabilities(),
    flags = { debounce_text_changes = 150 },
    settings = {
      rust_analyzer = {}
    },
  }
end

function M.setup()
  require('rust-tools').setup()
  return M.config()
end

return M
