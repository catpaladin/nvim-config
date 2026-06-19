local config = require("config")
if not config.lang.terraform then
  return {}
end

-- Terraform language plugin placeholder.
-- Filetype detection lives in lua/filetypes.lua (runs before lazy.nvim).
-- LSP config (terraformls) lives in lua/plugins/lsp.lua.
-- Formatting (terraform_fmt, tofu_fmt, terragrunt_hclfmt) lives in
-- lua/plugins/conform.lua.
-- Treesitter parsers (terraform, hcl) live in lua/plugins/treesitter.lua.
return {}