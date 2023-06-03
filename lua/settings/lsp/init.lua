local lsp_providers = {
  "lua_ls",
  "pyright",
  "efm",
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
