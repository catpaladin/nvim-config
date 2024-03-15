local lsp_providers = {
  "lua_ls",
  "pyright",
  "gopls",
  "terraformls",
  "yamlls",
  "rust_analyzer",
}

local lspconfig = require("lspconfig")
require("mason").setup()
require("mason-lspconfig").setup({
  automatic_installation = true,
  ensure_installed = {
    "lua_ls",
    "pyright",
    "gopls",
    "terraformls",
    "yamlls",
    "rust_analyzer",
    "tsserver",
  }
})

for _, server in pairs(lsp_providers) do
  local options = require("settings.lsp." .. server).setup()
  lspconfig[server].setup(vim.tbl_deep_extend("force", options, {}))
end

lspconfig.tsserver.setup {}

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
              "-",
            },
            stdin = true
          }
        end,
        function()
          return {
            exe = "black",
            args = {
              "--fast",
              "-",
            },
            stdin = true
          }
        end,
      },
      go = {
        function()
          return {
            exe = "golines",
            args = {
              "-",
            },
            stdin = true,
          }
        end,
        function()
          return {
            exe = "goimports-reviser",
            args = {
              "-imports-order",
              "std,general,company,project,blanked,dotted",
              "-rm-unused",
              "-set-alias",
              "-format",
              "-",
            },
            stdin = true,
          }
        end,
      },
      ["*"] = {
        require("formatter.filetypes.any").remove_trailing_whitespace
      }
    }
  }
)
