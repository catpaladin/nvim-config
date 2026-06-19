-- ============================================================================
-- Custom Filetype Detection
-- Runs before lazy.nvim setup, ensuring filetypes are registered
-- before any command-line files are opened.
-- ============================================================================

local config = require("config")

-- Terraform / OpenTofu / Terragrunt
if config.lang.terraform then
  vim.filetype.add({
    extension = {
      ["tfvars"] = "terraform-vars",
      ["tfplan"] = "json",
      ["tftest.hcl"] = "terraform-vars",
      tofu = "opentofu",
      ["tofu.json"] = "opentofu",
      ["tofu.tfvars"] = "terraform-vars",
    },
    filename = {
      ["terragrunt.hcl"] = "terragrunt",
      [".terraformrc"] = "terraform",
      ["terraform.rc"] = "terraform",
    },
  })

  -- Map custom filetypes to treesitter parsers.
  -- The generic FileType autocmd in init.lua tries to start a parser
  -- matching the filetype name; these aliases need explicit mapping.
  local group = vim.api.nvim_create_augroup("TerraformTreesitter", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "terraform-vars", "opentofu" },
    callback = function(args)
      pcall(vim.treesitter.start, args.buf, "terraform")
    end,
  })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "terragrunt",
    callback = function(args)
      pcall(vim.treesitter.start, args.buf, "hcl")
    end,
  })
end