local lsp_providers = {
  "lua_ls",
  "pyright",
  --"efm",
  "gopls",
  "terraformls",
  "yamlls",
}

local lspconfig = require("lspconfig")
require("mason").setup()
require("mason-lspconfig").setup({
  automatic_installation = true
})

for _, server in pairs(lsp_providers) do
  local options = require("settings.lsp." .. server).setup()
  lspconfig[server].setup(vim.tbl_deep_extend("force", options, {}))
end

local util = require "formatter.util"
require('formatter').setup(
  {
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
      python = {
        function()
          return {
            exe = "isort",
            args = {
              "--quiet",
              "-"
            },
            stdin = true
          }
        end,
        function()
          return {
            exe = "black",
            args = {
              "--fast",
              "-"
            },
            stdin = true
          }
        end,
      },
      ["*"] = {
        require("formatter.filetypes.any").remove_trailing_whitespace
      }
    }
  }
)
