local lsp_providers = {
  "sumneko_lua",
  "pyright",
  "efm",
  "gopls",
  "terraformls",
  "yamlls",
}

local lspconfig = require("lspconfig")
require("nvim-lsp-installer").setup({
  automatic_installation = true
})

for _, server in pairs(lsp_providers) do
  local options = require("settings.lsp." .. server).setup()
  lspconfig[server].setup(vim.tbl_deep_extend("force", options, {}))
end
